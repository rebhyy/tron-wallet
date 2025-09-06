// Compiles a dart2wasm-generated main module from `source` which can then
// instantiatable via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(
      await WebAssembly.compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm modules from `bytes` which is then
// instantiatable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export async function instantiate(modulePromise, importObjectPromise) {
  var moduleOrCompiledApp = await modulePromise;
  if (!(moduleOrCompiledApp instanceof CompiledApp)) {
    moduleOrCompiledApp = new CompiledApp(moduleOrCompiledApp);
  }
  const instantiatedApp = await moduleOrCompiledApp.instantiate(await importObjectPromise);
  return instantiatedApp.instantiatedModule;
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export const invoke = (moduleInstance, ...args) => {
  moduleInstance.exports.$invokeMain(args);
}

class CompiledApp {
  constructor(module, builtins) {
    this.module = module;
    this.builtins = builtins;
  }

  // The second argument is an options object containing:
  // `loadDeferredWasm` is a JS function that takes a module name matching a
  //   wasm file produced by the dart2wasm compiler and returns the bytes to
  //   load the module. These bytes can be in either a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  // `loadDynamicModule` is a JS function that takes two string names matching,
  //   in order, a wasm file produced by the dart2wasm compiler during dynamic
  //   module compilation and a corresponding js file produced by the same
  //   compilation. It should return a JS Array containing 2 elements. The first
  //   should be the bytes for the wasm module in a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`. The second
  //   should be the result of using the JS 'import' API on the js file path.
  async instantiate(additionalImports, {loadDeferredWasm, loadDynamicModule} = {}) {
    let dartInstance;

    // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + value;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
      wrapped.dartFunction = dartFunction;
      wrapped[jsWrappedDartFunctionSymbol] = true;
      return wrapped;
    }

    // Imports
    const dart2wasm = {
            _4: (o, c) => o instanceof c,
      _7: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._7(f,arguments.length,x0) }),
      _8: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._8(f,arguments.length,x0,x1) }),
      _37: x0 => new Array(x0),
      _38: x0 => globalThis.Array.from(x0),
      _39: x0 => x0.length,
      _41: (x0,x1) => x0[x1],
      _42: (x0,x1,x2) => { x0[x1] = x2 },
      _43: x0 => new Promise(x0),
      _45: (x0,x1,x2) => new DataView(x0,x1,x2),
      _47: x0 => new Int8Array(x0),
      _48: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      _49: x0 => new Uint8Array(x0),
      _51: x0 => new Uint8ClampedArray(x0),
      _53: x0 => new Int16Array(x0),
      _55: x0 => new Uint16Array(x0),
      _57: x0 => new Int32Array(x0),
      _59: x0 => new Uint32Array(x0),
      _61: x0 => new Float32Array(x0),
      _63: x0 => new Float64Array(x0),
      _65: (x0,x1,x2) => x0.call(x1,x2),
      _70: (decoder, codeUnits) => decoder.decode(codeUnits),
      _71: () => new TextDecoder("utf-8", {fatal: true}),
      _72: () => new TextDecoder("utf-8", {fatal: false}),
      _73: (s) => +s,
      _74: x0 => new Uint8Array(x0),
      _75: (x0,x1,x2) => x0.set(x1,x2),
      _76: (x0,x1) => x0.transferFromImageBitmap(x1),
      _77: x0 => x0.arrayBuffer(),
      _78: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._78(f,arguments.length,x0) }),
      _79: x0 => new window.FinalizationRegistry(x0),
      _80: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      _81: (x0,x1) => x0.unregister(x1),
      _82: (x0,x1,x2) => x0.slice(x1,x2),
      _83: (x0,x1) => x0.decode(x1),
      _84: (x0,x1) => x0.segment(x1),
      _85: () => new TextDecoder(),
      _87: x0 => x0.click(),
      _88: x0 => x0.buffer,
      _89: x0 => x0.wasmMemory,
      _90: () => globalThis.window._flutter_skwasmInstance,
      _91: x0 => x0.rasterStartMilliseconds,
      _92: x0 => x0.rasterEndMilliseconds,
      _93: x0 => x0.imageBitmaps,
      _120: x0 => x0.remove(),
      _121: (x0,x1) => x0.append(x1),
      _122: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _123: (x0,x1) => x0.querySelector(x1),
      _125: (x0,x1) => x0.removeChild(x1),
      _203: x0 => x0.stopPropagation(),
      _204: x0 => x0.preventDefault(),
      _206: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _251: x0 => x0.unlock(),
      _252: x0 => x0.getReader(),
      _253: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _254: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      _255: (x0,x1) => x0.item(x1),
      _256: x0 => x0.next(),
      _257: x0 => x0.now(),
      _258: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._258(f,arguments.length,x0) }),
      _259: (x0,x1) => x0.addListener(x1),
      _260: (x0,x1) => x0.removeListener(x1),
      _261: (x0,x1) => x0.matchMedia(x1),
      _262: (x0,x1) => x0.revokeObjectURL(x1),
      _263: x0 => x0.close(),
      _264: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      _265: x0 => new window.ImageDecoder(x0),
      _266: x0 => ({frameIndex: x0}),
      _267: (x0,x1) => x0.decode(x1),
      _268: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._268(f,arguments.length,x0) }),
      _269: (x0,x1) => x0.getModifierState(x1),
      _270: (x0,x1) => x0.removeProperty(x1),
      _271: (x0,x1) => x0.prepend(x1),
      _272: x0 => x0.disconnect(),
      _273: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._273(f,arguments.length,x0) }),
      _274: (x0,x1) => x0.getAttribute(x1),
      _275: (x0,x1) => x0.contains(x1),
      _276: x0 => x0.blur(),
      _277: x0 => x0.hasFocus(),
      _278: (x0,x1) => x0.hasAttribute(x1),
      _279: (x0,x1) => x0.getModifierState(x1),
      _280: (x0,x1) => x0.appendChild(x1),
      _281: (x0,x1) => x0.createTextNode(x1),
      _282: (x0,x1) => x0.removeAttribute(x1),
      _283: x0 => x0.getBoundingClientRect(),
      _284: (x0,x1) => x0.observe(x1),
      _285: x0 => x0.disconnect(),
      _286: (x0,x1) => x0.closest(x1),
      _696: () => globalThis.window.flutterConfiguration,
      _697: x0 => x0.assetBase,
      _703: x0 => x0.debugShowSemanticsNodes,
      _704: x0 => x0.hostElement,
      _705: x0 => x0.multiViewEnabled,
      _706: x0 => x0.nonce,
      _708: x0 => x0.fontFallbackBaseUrl,
      _712: x0 => x0.console,
      _713: x0 => x0.devicePixelRatio,
      _714: x0 => x0.document,
      _715: x0 => x0.history,
      _716: x0 => x0.innerHeight,
      _717: x0 => x0.innerWidth,
      _718: x0 => x0.location,
      _719: x0 => x0.navigator,
      _720: x0 => x0.visualViewport,
      _721: x0 => x0.performance,
      _723: x0 => x0.URL,
      _725: (x0,x1) => x0.getComputedStyle(x1),
      _726: x0 => x0.screen,
      _727: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._727(f,arguments.length,x0) }),
      _728: (x0,x1) => x0.requestAnimationFrame(x1),
      _733: (x0,x1) => x0.warn(x1),
      _735: (x0,x1) => x0.debug(x1),
      _736: x0 => globalThis.parseFloat(x0),
      _737: () => globalThis.window,
      _738: () => globalThis.Intl,
      _739: () => globalThis.Symbol,
      _740: (x0,x1,x2,x3,x4) => globalThis.createImageBitmap(x0,x1,x2,x3,x4),
      _742: x0 => x0.clipboard,
      _743: x0 => x0.maxTouchPoints,
      _744: x0 => x0.vendor,
      _745: x0 => x0.language,
      _746: x0 => x0.platform,
      _747: x0 => x0.userAgent,
      _748: (x0,x1) => x0.vibrate(x1),
      _749: x0 => x0.languages,
      _750: x0 => x0.documentElement,
      _751: (x0,x1) => x0.querySelector(x1),
      _754: (x0,x1) => x0.createElement(x1),
      _757: (x0,x1) => x0.createEvent(x1),
      _758: x0 => x0.activeElement,
      _761: x0 => x0.head,
      _762: x0 => x0.body,
      _764: (x0,x1) => { x0.title = x1 },
      _767: x0 => x0.visibilityState,
      _768: () => globalThis.document,
      _769: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._769(f,arguments.length,x0) }),
      _770: (x0,x1) => x0.dispatchEvent(x1),
      _778: x0 => x0.target,
      _780: x0 => x0.timeStamp,
      _781: x0 => x0.type,
      _783: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      _790: x0 => x0.firstChild,
      _794: x0 => x0.parentElement,
      _796: (x0,x1) => { x0.textContent = x1 },
      _797: x0 => x0.parentNode,
      _799: x0 => x0.isConnected,
      _803: x0 => x0.firstElementChild,
      _805: x0 => x0.nextElementSibling,
      _806: x0 => x0.clientHeight,
      _807: x0 => x0.clientWidth,
      _808: x0 => x0.offsetHeight,
      _809: x0 => x0.offsetWidth,
      _810: x0 => x0.id,
      _811: (x0,x1) => { x0.id = x1 },
      _814: (x0,x1) => { x0.spellcheck = x1 },
      _815: x0 => x0.tagName,
      _816: x0 => x0.style,
      _818: (x0,x1) => x0.querySelectorAll(x1),
      _819: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _820: x0 => x0.tabIndex,
      _821: (x0,x1) => { x0.tabIndex = x1 },
      _822: (x0,x1) => x0.focus(x1),
      _823: x0 => x0.scrollTop,
      _824: (x0,x1) => { x0.scrollTop = x1 },
      _825: x0 => x0.scrollLeft,
      _826: (x0,x1) => { x0.scrollLeft = x1 },
      _827: x0 => x0.classList,
      _829: (x0,x1) => { x0.className = x1 },
      _831: (x0,x1) => x0.getElementsByClassName(x1),
      _832: (x0,x1) => x0.attachShadow(x1),
      _835: x0 => x0.computedStyleMap(),
      _836: (x0,x1) => x0.get(x1),
      _842: (x0,x1) => x0.getPropertyValue(x1),
      _843: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      _844: x0 => x0.offsetLeft,
      _845: x0 => x0.offsetTop,
      _846: x0 => x0.offsetParent,
      _848: (x0,x1) => { x0.name = x1 },
      _849: x0 => x0.content,
      _850: (x0,x1) => { x0.content = x1 },
      _854: (x0,x1) => { x0.src = x1 },
      _855: x0 => x0.naturalWidth,
      _856: x0 => x0.naturalHeight,
      _860: (x0,x1) => { x0.crossOrigin = x1 },
      _862: (x0,x1) => { x0.decoding = x1 },
      _863: x0 => x0.decode(),
      _868: (x0,x1) => { x0.nonce = x1 },
      _873: (x0,x1) => { x0.width = x1 },
      _875: (x0,x1) => { x0.height = x1 },
      _878: (x0,x1) => x0.getContext(x1),
      _937: x0 => x0.width,
      _938: x0 => x0.height,
      _940: (x0,x1) => x0.fetch(x1),
      _941: x0 => x0.status,
      _943: x0 => x0.body,
      _944: x0 => x0.arrayBuffer(),
      _947: x0 => x0.read(),
      _948: x0 => x0.value,
      _949: x0 => x0.done,
      _951: x0 => x0.name,
      _952: x0 => x0.x,
      _953: x0 => x0.y,
      _956: x0 => x0.top,
      _957: x0 => x0.right,
      _958: x0 => x0.bottom,
      _959: x0 => x0.left,
      _971: x0 => x0.height,
      _972: x0 => x0.width,
      _973: x0 => x0.scale,
      _974: (x0,x1) => { x0.value = x1 },
      _977: (x0,x1) => { x0.placeholder = x1 },
      _979: (x0,x1) => { x0.name = x1 },
      _980: x0 => x0.selectionDirection,
      _981: x0 => x0.selectionStart,
      _982: x0 => x0.selectionEnd,
      _985: x0 => x0.value,
      _987: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _988: x0 => x0.readText(),
      _989: (x0,x1) => x0.writeText(x1),
      _991: x0 => x0.altKey,
      _992: x0 => x0.code,
      _993: x0 => x0.ctrlKey,
      _994: x0 => x0.key,
      _995: x0 => x0.keyCode,
      _996: x0 => x0.location,
      _997: x0 => x0.metaKey,
      _998: x0 => x0.repeat,
      _999: x0 => x0.shiftKey,
      _1000: x0 => x0.isComposing,
      _1002: x0 => x0.state,
      _1003: (x0,x1) => x0.go(x1),
      _1005: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      _1006: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      _1007: x0 => x0.pathname,
      _1008: x0 => x0.search,
      _1009: x0 => x0.hash,
      _1013: x0 => x0.state,
      _1016: (x0,x1) => x0.createObjectURL(x1),
      _1018: x0 => new Blob(x0),
      _1020: x0 => new MutationObserver(x0),
      _1021: (x0,x1,x2) => x0.observe(x1,x2),
      _1022: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1022(f,arguments.length,x0,x1) }),
      _1025: x0 => x0.attributeName,
      _1026: x0 => x0.type,
      _1027: x0 => x0.matches,
      _1028: x0 => x0.matches,
      _1032: x0 => x0.relatedTarget,
      _1034: x0 => x0.clientX,
      _1035: x0 => x0.clientY,
      _1036: x0 => x0.offsetX,
      _1037: x0 => x0.offsetY,
      _1040: x0 => x0.button,
      _1041: x0 => x0.buttons,
      _1042: x0 => x0.ctrlKey,
      _1046: x0 => x0.pointerId,
      _1047: x0 => x0.pointerType,
      _1048: x0 => x0.pressure,
      _1049: x0 => x0.tiltX,
      _1050: x0 => x0.tiltY,
      _1051: x0 => x0.getCoalescedEvents(),
      _1054: x0 => x0.deltaX,
      _1055: x0 => x0.deltaY,
      _1056: x0 => x0.wheelDeltaX,
      _1057: x0 => x0.wheelDeltaY,
      _1058: x0 => x0.deltaMode,
      _1065: x0 => x0.changedTouches,
      _1068: x0 => x0.clientX,
      _1069: x0 => x0.clientY,
      _1072: x0 => x0.data,
      _1075: (x0,x1) => { x0.disabled = x1 },
      _1077: (x0,x1) => { x0.type = x1 },
      _1078: (x0,x1) => { x0.max = x1 },
      _1079: (x0,x1) => { x0.min = x1 },
      _1080: x0 => x0.value,
      _1081: (x0,x1) => { x0.value = x1 },
      _1082: x0 => x0.disabled,
      _1083: (x0,x1) => { x0.disabled = x1 },
      _1085: (x0,x1) => { x0.placeholder = x1 },
      _1087: (x0,x1) => { x0.name = x1 },
      _1089: (x0,x1) => { x0.autocomplete = x1 },
      _1090: x0 => x0.selectionDirection,
      _1092: x0 => x0.selectionStart,
      _1093: x0 => x0.selectionEnd,
      _1096: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _1097: (x0,x1) => x0.add(x1),
      _1100: (x0,x1) => { x0.noValidate = x1 },
      _1101: (x0,x1) => { x0.method = x1 },
      _1102: (x0,x1) => { x0.action = x1 },
      _1103: (x0,x1) => new OffscreenCanvas(x0,x1),
      _1109: (x0,x1) => x0.getContext(x1),
      _1111: x0 => x0.convertToBlob(),
      _1128: x0 => x0.orientation,
      _1129: x0 => x0.width,
      _1130: x0 => x0.height,
      _1131: (x0,x1) => x0.lock(x1),
      _1150: x0 => new ResizeObserver(x0),
      _1153: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1153(f,arguments.length,x0,x1) }),
      _1161: x0 => x0.length,
      _1162: x0 => x0.iterator,
      _1163: x0 => x0.Segmenter,
      _1164: x0 => x0.v8BreakIterator,
      _1165: (x0,x1) => new Intl.Segmenter(x0,x1),
      _1166: x0 => x0.done,
      _1167: x0 => x0.value,
      _1168: x0 => x0.index,
      _1172: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      _1173: (x0,x1) => x0.adoptText(x1),
      _1174: x0 => x0.first(),
      _1175: x0 => x0.next(),
      _1176: x0 => x0.current(),
      _1182: x0 => x0.hostElement,
      _1183: x0 => x0.viewConstraints,
      _1186: x0 => x0.maxHeight,
      _1187: x0 => x0.maxWidth,
      _1188: x0 => x0.minHeight,
      _1189: x0 => x0.minWidth,
      _1190: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1190(f,arguments.length,x0) }),
      _1191: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1191(f,arguments.length,x0) }),
      _1192: (x0,x1) => ({addView: x0,removeView: x1}),
      _1193: x0 => x0.loader,
      _1194: () => globalThis._flutter,
      _1195: (x0,x1) => x0.didCreateEngineInitializer(x1),
      _1196: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1196(f,arguments.length,x0) }),
      _1197: f => finalizeWrapper(f, function() { return dartInstance.exports._1197(f,arguments.length) }),
      _1198: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      _1199: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1199(f,arguments.length,x0) }),
      _1200: x0 => ({runApp: x0}),
      _1201: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1201(f,arguments.length,x0,x1) }),
      _1202: x0 => x0.length,
      _1203: () => globalThis.window.ImageDecoder,
      _1204: x0 => x0.tracks,
      _1206: x0 => x0.completed,
      _1208: x0 => x0.image,
      _1214: x0 => x0.displayWidth,
      _1215: x0 => x0.displayHeight,
      _1216: x0 => x0.duration,
      _1219: x0 => x0.ready,
      _1220: x0 => x0.selectedTrack,
      _1221: x0 => x0.repetitionCount,
      _1222: x0 => x0.frameCount,
      _1265: (x0,x1) => x0.postMessage(x1),
      _1266: x0 => x0.close(),
      _1267: (x0,x1) => x0.postMessage(x1),
      _1269: (x0,x1) => x0.addListener(x1),
      _1277: (x0,x1) => x0.getURL(x1),
      _1278: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1278(f,arguments.length,x0) }),
      _1279: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1279(f,arguments.length,x0,x1) }),
      _1280: f => finalizeWrapper(f, function(x0,x1,x2) { return dartInstance.exports._1280(f,arguments.length,x0,x1,x2) }),
      _1281: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1281(f,arguments.length,x0) }),
      _1282: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1282(f,arguments.length,x0) }),
      _1283: f => finalizeWrapper(f, function(x0,x1,x2) { return dartInstance.exports._1283(f,arguments.length,x0,x1,x2) }),
      _1284: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1284(f,arguments.length,x0) }),
      _1285: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1285(f,arguments.length,x0) }),
      _1286: x0 => new BarcodeDetector(x0),
      _1306: Date.now,
      _1308: s => new Date(s * 1000).getTimezoneOffset() * 60,
      _1309: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      _1310: () => {
        let stackString = new Error().stack.toString();
        let frames = stackString.split('\n');
        let drop = 2;
        if (frames[0] === 'Error') {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      _1311: () => typeof dartUseDateNowForTicks !== "undefined",
      _1312: () => 1000 * performance.now(),
      _1313: () => Date.now(),
      _1314: () => {
        // On browsers return `globalThis.location.href`
        if (globalThis.location != null) {
          return globalThis.location.href;
        }
        return null;
      },
      _1315: () => {
        return typeof process != "undefined" &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
      _1316: () => new WeakMap(),
      _1317: (map, o) => map.get(o),
      _1318: (map, o, v) => map.set(o, v),
      _1319: x0 => new WeakRef(x0),
      _1320: x0 => x0.deref(),
      _1327: () => globalThis.WeakRef,
      _1331: s => JSON.stringify(s),
      _1332: s => printToConsole(s),
      _1333: (o, p, r) => o.replaceAll(p, () => r),
      _1334: (o, p, r) => o.replace(p, () => r),
      _1335: Function.prototype.call.bind(String.prototype.toLowerCase),
      _1336: s => s.toUpperCase(),
      _1337: s => s.trim(),
      _1338: s => s.trimLeft(),
      _1339: s => s.trimRight(),
      _1340: (string, times) => string.repeat(times),
      _1341: Function.prototype.call.bind(String.prototype.indexOf),
      _1342: (s, p, i) => s.lastIndexOf(p, i),
      _1343: (string, token) => string.split(token),
      _1344: Object.is,
      _1345: o => o instanceof Array,
      _1346: (a, i) => a.push(i),
      _1347: (a, i) => a.splice(i, 1)[0],
      _1349: (a, l) => a.length = l,
      _1350: a => a.pop(),
      _1351: (a, i) => a.splice(i, 1),
      _1352: (a, s) => a.join(s),
      _1353: (a, s, e) => a.slice(s, e),
      _1355: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
      _1356: a => a.length,
      _1357: (a, l) => a.length = l,
      _1358: (a, i) => a[i],
      _1359: (a, i, v) => a[i] = v,
      _1361: o => {
        if (o instanceof ArrayBuffer) return 0;
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
          return 1;
        }
        return 2;
      },
      _1362: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      _1364: o => o instanceof Uint8Array,
      _1365: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      _1366: o => o instanceof Int8Array,
      _1367: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      _1368: o => o instanceof Uint8ClampedArray,
      _1369: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      _1370: o => o instanceof Uint16Array,
      _1371: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      _1372: o => o instanceof Int16Array,
      _1373: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      _1374: o => o instanceof Uint32Array,
      _1375: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      _1376: o => o instanceof Int32Array,
      _1377: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      _1379: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      _1380: o => o instanceof Float32Array,
      _1381: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      _1382: o => o instanceof Float64Array,
      _1383: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      _1384: (t, s) => t.set(s),
      _1385: l => new DataView(new ArrayBuffer(l)),
      _1386: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      _1388: o => o.buffer,
      _1389: o => o.byteOffset,
      _1390: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      _1391: (b, o) => new DataView(b, o),
      _1392: (b, o, l) => new DataView(b, o, l),
      _1393: Function.prototype.call.bind(DataView.prototype.getUint8),
      _1394: Function.prototype.call.bind(DataView.prototype.setUint8),
      _1395: Function.prototype.call.bind(DataView.prototype.getInt8),
      _1396: Function.prototype.call.bind(DataView.prototype.setInt8),
      _1397: Function.prototype.call.bind(DataView.prototype.getUint16),
      _1398: Function.prototype.call.bind(DataView.prototype.setUint16),
      _1399: Function.prototype.call.bind(DataView.prototype.getInt16),
      _1400: Function.prototype.call.bind(DataView.prototype.setInt16),
      _1401: Function.prototype.call.bind(DataView.prototype.getUint32),
      _1402: Function.prototype.call.bind(DataView.prototype.setUint32),
      _1403: Function.prototype.call.bind(DataView.prototype.getInt32),
      _1404: Function.prototype.call.bind(DataView.prototype.setInt32),
      _1407: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      _1408: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      _1409: Function.prototype.call.bind(DataView.prototype.getFloat32),
      _1410: Function.prototype.call.bind(DataView.prototype.setFloat32),
      _1411: Function.prototype.call.bind(DataView.prototype.getFloat64),
      _1412: Function.prototype.call.bind(DataView.prototype.setFloat64),
      _1413: x0 => x0.terminate(),
      _1414: () => ({}),
      _1415: (x0,x1) => new Worker(x0,x1),
      _1416: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1416(f,arguments.length,x0) }),
      _1417: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _1418: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1418(f,arguments.length,x0) }),
      _1419: (x0,x1) => x0.postMessage(x1),
      _1420: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      _1421: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1421(f,arguments.length,x0) }),
      _1422: x0 => { globalThis.workerListener_ = x0 },
      _1423: () => globalThis.workerListener_,
      _1424: x0 => { globalThis.errorListener_ = x0 },
      _1425: () => globalThis.errorListener_,
      _1426: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1426(f,arguments.length,x0) }),
      _1427: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1427(f,arguments.length,x0) }),
      _1428: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1428(f,arguments.length,x0) }),
      _1429: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1429(f,arguments.length,x0) }),
      _1430: x0 => { globalThis.serviceWorkerListener_ = x0 },
      _1431: () => globalThis.serviceWorkerListener_,
      _1432: x0 => { globalThis.serviceErrorListener_ = x0 },
      _1433: () => globalThis.serviceErrorListener_,
      _1434: f => finalizeWrapper(f, function() { return dartInstance.exports._1434(f,arguments.length) }),
      _1435: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1435(f,arguments.length,x0) }),
      _1436: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1436(f,arguments.length,x0) }),
      _1437: (x0,x1,x2) => x0.close(x1,x2),
      _1450: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      _1451: (handle) => clearTimeout(handle),
      _1452: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      _1453: (handle) => clearInterval(handle),
      _1454: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      _1455: () => Date.now(),
      _1460: o => Object.keys(o),
      _1479: () => new AbortController(),
      _1480: x0 => x0.abort(),
      _1481: (x0,x1,x2,x3,x4,x5) => ({method: x0,headers: x1,body: x2,credentials: x3,redirect: x4,signal: x5}),
      _1482: (x0,x1) => globalThis.fetch(x0,x1),
      _1483: (x0,x1) => x0.get(x1),
      _1484: f => finalizeWrapper(f, function(x0,x1,x2) { return dartInstance.exports._1484(f,arguments.length,x0,x1,x2) }),
      _1485: (x0,x1) => x0.forEach(x1),
      _1486: x0 => x0.getReader(),
      _1487: x0 => x0.read(),
      _1488: x0 => x0.cancel(),
      _1495: (x0,x1) => x0.put(x1),
      _1496: (x0,x1,x2) => x0.transaction(x1,x2),
      _1497: (x0,x1) => x0.objectStore(x1),
      _1498: (x0,x1) => x0.open(x1),
      _1499: (x0,x1) => x0.contains(x1),
      _1500: (x0,x1) => ({keyPath: x0,autoIncrement: x1}),
      _1501: (x0,x1,x2) => x0.createObjectStore(x1,x2),
      _1505: x0 => x0.close(),
      _1511: (x0,x1) => x0.index(x1),
      _1512: (x0,x1) => x0.get(x1),
      _1513: (x0,x1) => x0.delete(x1),
      _1514: x0 => globalThis.IDBKeyRange.only(x0),
      _1515: (x0,x1,x2) => x0.openCursor(x1,x2),
      _1516: (x0,x1,x2) => x0.openCursor(x1,x2),
      _1517: f => finalizeWrapper(f, function() { return dartInstance.exports._1517(f,arguments.length) }),
      _1519: x0 => x0.continue(),
      _1520: x0 => x0.delete(),
      _1521: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1521(f,arguments.length,x0) }),
      _1522: (x0,x1) => x0.add(x1),
      _1523: x0 => ({unique: x0}),
      _1524: (x0,x1,x2,x3) => x0.createIndex(x1,x2,x3),
      _1525: x0 => x0.id,
      _1527: x0 => x0.storage,
      _1528: (x0,x1) => { x0.storage = x1 },
      _1529: x0 => x0.storage_id,
      _1530: (x0,x1) => { x0.storage_id = x1 },
      _1531: x0 => x0.key,
      _1532: (x0,x1) => { x0.key = x1 },
      _1533: x0 => x0.key_a,
      _1534: (x0,x1) => { x0.key_a = x1 },
      _1535: x0 => x0.data,
      _1536: (x0,x1) => { x0.data = x1 },
      _1538: (x0,x1) => { x0.createdAt = x1 },
      _1540: (x0,x1,x2) => x0.open(x1,x2),
      _1542: (x0,x1) => x0.deleteObjectStore(x1),
      _1543: x0 => x0.arrayBuffer(),
      _1544: x0 => ({type: x0}),
      _1545: (x0,x1,x2) => new File(x0,x1,x2),
      _1546: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      _1547: x0 => x0.getPublicKey(),
      _1556: (x0,x1,x2,x3,x4) => ({data: x0,type: x1,additional: x2,platform: x3,target: x4}),
      _1557: x0 => x0.target,
      _1558: x0 => x0.type,
      _1559: (x0,x1) => { x0.client_id = x1 },
      _1560: x0 => x0.client_id,
      _1561: (x0,x1) => { x0.request_id = x1 },
      _1562: x0 => x0.request_id,
      _1563: x0 => x0.platform,
      _1564: x0 => x0.data,
      _1565: x0 => x0.additional,
      _1570: (x0,x1,x2,x3) => x0.sendMessage(x1,x2,x3),
      _1574: x0 => x0.id,
      _1576: x0 => x0.onMessage,
      _1578: x0 => x0.onConnect,
      _1585: x0 => x0.tab,
      _1590: x0 => x0.onDisconnect,
      _1591: x0 => x0.onMessage,
      _1609: x0 => x0.storage,
      _1610: x0 => x0.tabs,
      _1611: x0 => x0.runtime,
      _1613: x0 => x0.windows,
      _1614: x0 => x0.sidePanel,
      _1615: x0 => x0.sidePanel,
      _1617: x0 => x0.sidebarAction,
      _1618: x0 => x0.sidebarAction,
      _1619: x0 => x0.runtime,
      _1622: () => globalThis.chrome,
      _1623: () => globalThis.chrome,
      _1624: () => globalThis.browser,
      _1625: () => globalThis.browser,
      _1626: () => globalThis.opr,
      _1631: () => globalThis.window,
      _1633: x0 => x0.parent,
      _1634: x0 => x0.BarcodeDetector,
      _1635: x0 => x0.navigator,
      _1636: x0 => x0.navigator,
      _1638: x0 => x0.document,
      _1639: x0 => x0.location,
      _1640: (x0,x1) => x0.fetch(x1),
      _1642: x0 => x0.focus(),
      _1649: x0 => x0.href,
      _1651: x0 => x0.hostname,
      _1654: x0 => x0.search,
      _1656: (x0,x1) => x0.createElement(x1),
      _1657: x0 => x0.body,
      _1659: x0 => x0.hasFocus(),
      _1660: x0 => globalThis.URL.createObjectURL(x0),
      _1661: (x0,x1) => x0.appendChild(x1),
      _1662: x0 => x0.click(),
      _1663: (x0,x1) => x0.removeChild(x1),
      _1665: (x0,x1) => x0.writeText(x1),
      _1666: x0 => x0.readText(),
      _1668: x0 => x0.mediaDevices,
      _1669: x0 => x0.userAgent,
      _1670: x0 => x0.onLine,
      _1671: x0 => x0.credentials,
      _1672: (x0,x1,x2,x3,x4) => x0.share(x1,x2,x3,x4),
      _1673: x0 => x0.clipboard,
      _1675: (x0,x1) => x0.getUserMedia(x1),
      _1676: (x0,x1) => x0.detect(x1),
      _1680: x0 => x0.rawValue,
      _1691: (x0,x1) => new Blob(x0,x1),
      _1697: x0 => x0.ok,
      _1698: x0 => x0.status,
      _1699: x0 => x0.text(),
      _1705: (x0,x1) => { x0.type = x1 },
      _1716: x0 => x0.target,
      _1724: x0 => x0.data,
      _1725: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _1726: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      _1728: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1728(f,arguments.length,x0) }),
      _1753: (x0,x1) => ({type: x0,alg: x1}),
      _1754: (x0,x1) => ({id: x0,name: x1}),
      _1755: (x0,x1,x2) => ({id: x0,displayName: x1,name: x2}),
      _1756: x0 => x0.id,
      _1757: x0 => x0.type,
      _1758: () => globalThis.PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable(),
      _1761: x0 => x0.response,
      _1763: x0 => x0.clientDataJSON,
      _1764: x0 => x0.authenticatorData,
      _1765: x0 => x0.signature,
      _1769: x0 => x0.getPublicKeyAlgorithm(),
      _1771: (x0,x1) => x0.create(x1),
      _1772: (x0,x1) => x0.get(x1),
      _1773: x0 => ({authenticatorAttachment: x0}),
      _1774: (x0,x1,x2,x3,x4) => ({authenticatorSelection: x0,challenge: x1,pubKeyCredParams: x2,rp: x3,user: x4}),
      _1775: x0 => ({publicKey: x0}),
      _1776: (x0,x1) => ({id: x0,type: x1}),
      _1777: (x0,x1,x2) => ({challenge: x0,allowCredentials: x1,userVerification: x2}),
      _1778: (x0,x1) => ({publicKey: x0,mediation: x1}),
      _1782: (x0,x1) => new WebSocket(x0,x1),
      _1783: x0 => x0.readyState,
      _1785: (x0,x1) => x0.send(x1),
      _1787: (x0,x1) => { x0.onclose = x1 },
      _1788: (x0,x1) => { x0.onmessage = x1 },
      _1789: (x0,x1) => { x0.onopen = x1 },
      _1790: x0 => x0.code,
      _1791: x0 => x0.reason,
      _1793: x0 => x0.data,
      _1795: (x0,x1) => x0.get(x1),
      _1796: (x0,x1) => x0.query(x1),
      _1798: (x0,x1,x2) => x0.create(x1,x2),
      _1799: (x0,x1,x2,x3) => x0.update(x1,x2,x3),
      _1800: (x0,x1,x2,x3) => x0.sendMessage(x1,x2,x3),
      _1801: x0 => x0.onActivated,
      _1802: x0 => x0.onUpdated,
      _1803: x0 => x0.onRemoved,
      _1804: (x0,x1,x2,x3,x4,x5,x6) => ({active: x0,autoDiscardable: x1,highlighted: x2,muted: x3,openerTabId: x4,pinned: x5,url: x6}),
      _1805: (x0,x1,x2,x3,x4,x5) => ({active: x0,index: x1,openerTabId: x2,pinned: x3,url: x4,windowId: x5}),
      _1806: (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11) => ({active: x0,audible: x1,autoDiscardable: x2,currentWindow: x3,discarded: x4,highlighted: x5,index: x6,lastFocusedWindow: x7,muted: x8,pinned: x9,windowId: x10,url: x11}),
      _1808: x0 => x0.active,
      _1816: x0 => x0.favIconUrl,
      _1822: x0 => x0.id,
      _1830: x0 => x0.title,
      _1832: x0 => x0.url,
      _1834: x0 => x0.windowId,
      _1851: x0 => x0.tabId,
      _1852: x0 => x0.windowId,
      _1863: x0 => x0.status,
      _1886: (x0,x1) => x0.create(x1),
      _1887: (x0,x1) => x0.getCurrent(x1),
      _1889: (x0,x1,x2) => x0.get(x1,x2),
      _1890: x0 => x0.onFocusChanged,
      _1892: (x0,x1) => x0.getAll(x1),
      _1893: (x0,x1,x2) => x0.update(x1,x2),
      _1894: (x0,x1,x2,x3,x4,x5,x6,x7,x8) => ({focused: x0,height: x1,incognito: x2,left: x3,tabId: x4,top: x5,url: x6,width: x7,type: x8}),
      _1895: (x0,x1,x2,x3,x4,x5,x6) => ({drawAttention: x0,focused: x1,height: x2,left: x3,state: x4,top: x5,width: x6}),
      _1896: (x0,x1) => ({populate: x0,windowTypes: x1}),
      _1910: x0 => x0.focused,
      _1911: x0 => x0.height,
      _1912: x0 => x0.id,
      _1914: x0 => x0.left,
      _1917: x0 => x0.tabs,
      _1918: x0 => x0.top,
      _1921: x0 => x0.width,
      _1923: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1923(f,arguments.length,x0) }),
      _1924: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1924(f,arguments.length,x0) }),
      _1925: f => finalizeWrapper(f, function() { return dartInstance.exports._1925(f,arguments.length) }),
      _1926: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1926(f,arguments.length,x0) }),
      _1927: f => finalizeWrapper(f, function() { return dartInstance.exports._1927(f,arguments.length) }),
      _1928: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1928(f,arguments.length,x0) }),
      _1929: () => globalThis.indexedDB,
      _1934: x0 => x0.version,
      _1936: x0 => x0.objectStoreNames,
      _1971: x0 => x0.result,
      _1972: (x0,x1) => { x0.onerror = x1 },
      _1973: (x0,x1) => { x0.onsuccess = x1 },
      _1984: (x0,x1) => { x0.onblocked = x1 },
      _1985: (x0,x1) => { x0.onupgradeneeded = x1 },
      _1998: x0 => x0.value,
      _2004: x0 => x0.session,
      _2013: (x0,x1) => x0.get(x1),
      _2017: (x0,x1) => x0.remove(x1),
      _2021: (x0,x1) => x0.set(x1),
      _2036: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      _2037: (x0,x1) => x0.exec(x1),
      _2038: (x0,x1) => x0.test(x1),
      _2039: x0 => x0.pop(),
      _2041: o => o === undefined,
      _2043: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      _2045: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      _2046: o => o instanceof RegExp,
      _2047: (l, r) => l === r,
      _2048: o => o,
      _2049: o => o,
      _2050: o => o,
      _2051: b => !!b,
      _2052: o => o.length,
      _2054: (o, i) => o[i],
      _2055: f => f.dartFunction,
      _2056: () => ({}),
      _2057: () => [],
      _2059: () => globalThis,
      _2060: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      _2062: (o, p) => o[p],
      _2063: (o, p, v) => o[p] = v,
      _2064: (o, m, a) => o[m].apply(o, a),
      _2066: o => String(o),
      _2067: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      _2068: o => {
        if (o === undefined) return 1;
        var type = typeof o;
        if (type === 'boolean') return 2;
        if (type === 'number') return 3;
        if (type === 'string') return 4;
        if (o instanceof Array) return 5;
        if (ArrayBuffer.isView(o)) {
          if (o instanceof Int8Array) return 6;
          if (o instanceof Uint8Array) return 7;
          if (o instanceof Uint8ClampedArray) return 8;
          if (o instanceof Int16Array) return 9;
          if (o instanceof Uint16Array) return 10;
          if (o instanceof Int32Array) return 11;
          if (o instanceof Uint32Array) return 12;
          if (o instanceof Float32Array) return 13;
          if (o instanceof Float64Array) return 14;
          if (o instanceof DataView) return 15;
        }
        if (o instanceof ArrayBuffer) return 16;
        // Feature check for `SharedArrayBuffer` before doing a type-check.
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
            return 17;
        }
        return 18;
      },
      _2069: o => [o],
      _2070: (o0, o1) => [o0, o1],
      _2071: (o0, o1, o2) => [o0, o1, o2],
      _2072: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      _2073: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2074: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _2075: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI16ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2076: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI16ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _2077: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2078: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _2079: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2080: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _2081: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2082: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _2083: x0 => new ArrayBuffer(x0),
      _2084: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      _2086: x0 => x0.index,
      _2088: x0 => x0.flags,
      _2089: x0 => x0.multiline,
      _2090: x0 => x0.ignoreCase,
      _2091: x0 => x0.unicode,
      _2092: x0 => x0.dotAll,
      _2093: (x0,x1) => { x0.lastIndex = x1 },
      _2094: (o, p) => p in o,
      _2095: (o, p) => o[p],
      _2098: x0 => x0.random(),
      _2099: (x0,x1) => x0.getRandomValues(x1),
      _2100: () => globalThis.crypto,
      _2101: () => globalThis.Math,
      _2102: Function.prototype.call.bind(Number.prototype.toString),
      _2103: Function.prototype.call.bind(BigInt.prototype.toString),
      _2104: Function.prototype.call.bind(Number.prototype.toString),
      _2105: (d, digits) => d.toFixed(digits),
      _6548: x0 => x0.signal,
      _8388: x0 => x0.value,
      _8390: x0 => x0.done,
      _9092: x0 => x0.url,
      _9094: x0 => x0.status,
      _9096: x0 => x0.statusText,
      _9097: x0 => x0.headers,
      _9098: x0 => x0.body,
      _12726: x0 => x0.name,
      _13472: x0 => x0.open,
      _13473: x0 => x0.open(),
      _13474: x0 => x0.close(),
      _13476: x0 => x0.open,
      _13477: (x0,x1) => x0.open(x1),
      _13481: (x0,x1) => ({tabId: x0,windowId: x1}),
      _13542: x0 => x0.id,
      _13543: (x0,x1) => { x0.id = x1 },
      _13548: (x0,x1) => { x0.autoplay = x1 },
      _13553: (x0,x1) => { x0.href = x1 },
      _13554: (x0,x1) => { x0.target = x1 },
      _13555: (x0,x1) => { x0.download = x1 },
      _13558: (x0,x1) => { x0.srcObject = x1 },
      _13572: x0 => x0.stop(),
      _13574: x0 => x0.getTracks(),

    };

    const baseImports = {
      dart2wasm: dart2wasm,
      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
      S: new Proxy({}, { get(_, prop) { return prop; } }),

    };

    const jsStringPolyfill = {
      "charCodeAt": (s, i) => s.charCodeAt(i),
      "compare": (s1, s2) => {
        if (s1 < s2) return -1;
        if (s1 > s2) return 1;
        return 0;
      },
      "concat": (s1, s2) => s1 + s2,
      "equals": (s1, s2) => s1 === s2,
      "fromCharCode": (i) => String.fromCharCode(i),
      "length": (s) => s.length,
      "substring": (s, a, b) => s.substring(a, b),
      "fromCharCodeArray": (a, start, end) => {
        if (end <= start) return '';

        const read = dartInstance.exports.$wasmI16ArrayGet;
        let result = '';
        let index = start;
        const chunkLength = Math.min(end - index, 500);
        let array = new Array(chunkLength);
        while (index < end) {
          const newChunkLength = Math.min(end - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(a, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      },
      "intoCharCodeArray": (s, a, start) => {
        if (s === '') return 0;

        const write = dartInstance.exports.$wasmI16ArraySet;
        for (var i = 0; i < s.length; ++i) {
          write(a, start++, s.charCodeAt(i));
        }
        return s.length;
      },
      "test": (s) => typeof s == "string",
    };


    

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      
      "wasm:js-string": jsStringPolyfill,
    });

    return new InstantiatedApp(this, dartInstance);
  }
}

class InstantiatedApp {
  constructor(compiledApp, instantiatedModule) {
    this.compiledApp = compiledApp;
    this.instantiatedModule = instantiatedModule;
  }

  // Call the main function with the given arguments.
  invokeMain(...args) {
    this.instantiatedModule.exports.$invokeMain(args);
  }
}
