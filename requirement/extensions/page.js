(function dartProgram(){function copyProperties(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
b[q]=a[q]}}function mixinPropertiesHard(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
if(!b.hasOwnProperty(q)){b[q]=a[q]}}}function mixinPropertiesEasy(a,b){Object.assign(b,a)}var z=function(){var s=function(){}
s.prototype={p:{}}
var r=new s()
if(!(Object.getPrototypeOf(r)&&Object.getPrototypeOf(r).p===s.prototype.p))return false
try{if(typeof navigator!="undefined"&&typeof navigator.userAgent=="string"&&navigator.userAgent.indexOf("Chrome/")>=0)return true
if(typeof version=="function"&&version.length==0){var q=version()
if(/^\d+\.\d+\.\d+\.\d+$/.test(q))return true}}catch(p){}return false}()
function inherit(a,b){a.prototype.constructor=a
a.prototype["$i"+a.name]=a
if(b!=null){if(z){Object.setPrototypeOf(a.prototype,b.prototype)
return}var s=Object.create(b.prototype)
copyProperties(a.prototype,s)
a.prototype=s}}function inheritMany(a,b){for(var s=0;s<b.length;s++){inherit(b[s],a)}}function mixinEasy(a,b){mixinPropertiesEasy(b.prototype,a.prototype)
a.prototype.constructor=a}function mixinHard(a,b){mixinPropertiesHard(b.prototype,a.prototype)
a.prototype.constructor=a}function lazy(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){a[b]=d()}a[c]=function(){return this[b]}
return a[b]}}function lazyFinal(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){var r=d()
if(a[b]!==s){A.i8(b)}a[b]=r}var q=a[b]
a[c]=function(){return q}
return q}}function makeConstList(a,b){if(b!=null)A.b(a,b)
a.$flags=7
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var s=0;s<a.length;++s){convertToFastObject(a[s])}}var y=0
function instanceTearOffGetter(a,b){var s=null
return a?function(c){if(s===null)s=A.i1(b)
return new s(c,this)}:function(){if(s===null)s=A.i1(b)
return new s(this,null)}}function staticTearOffGetter(a){var s=null
return function(){if(s===null)s=A.i1(a).prototype
return s}}var x=0
function tearOffParameters(a,b,c,d,e,f,g,h,i,j){if(typeof h=="number"){h+=x}return{co:a,iS:b,iI:c,rC:d,dV:e,cs:f,fs:g,fT:h,aI:i||0,nDA:j}}function installStaticTearOff(a,b,c,d,e,f,g,h){var s=tearOffParameters(a,true,false,c,d,e,f,g,h,false)
var r=staticTearOffGetter(s)
a[b]=r}function installInstanceTearOff(a,b,c,d,e,f,g,h,i,j){c=!!c
var s=tearOffParameters(a,false,c,d,e,f,g,h,i,!!j)
var r=instanceTearOffGetter(c,s)
a[b]=r}function setOrUpdateInterceptorsByTag(a){var s=v.interceptorsByTag
if(!s){v.interceptorsByTag=a
return}copyProperties(a,s)}function setOrUpdateLeafTags(a){var s=v.leafTags
if(!s){v.leafTags=a
return}copyProperties(a,s)}function updateTypes(a){var s=v.types
var r=s.length
s.push.apply(s,a)
return r}function updateHolder(a,b){copyProperties(b,a)
return a}var hunkHelpers=function(){var s=function(a,b,c,d,e){return function(f,g,h,i){return installInstanceTearOff(f,g,a,b,c,d,[h],i,e,false)}},r=function(a,b,c,d){return function(e,f,g,h){return installStaticTearOff(e,f,a,b,c,[g],h,d)}}
return{inherit:inherit,inheritMany:inheritMany,mixin:mixinEasy,mixinHard:mixinHard,installStaticTearOff:installStaticTearOff,installInstanceTearOff:installInstanceTearOff,_instance_0u:s(0,0,null,["$0"],0),_instance_1u:s(0,1,null,["$1"],0),_instance_2u:s(0,2,null,["$2"],0),_instance_0i:s(1,0,null,["$0"],0),_instance_1i:s(1,1,null,["$1"],0),_instance_2i:s(1,2,null,["$2"],0),_static_0:r(0,null,["$0"],0),_static_1:r(1,null,["$1"],0),_static_2:r(2,null,["$2"],0),makeConstList:makeConstList,lazy:lazy,lazyFinal:lazyFinal,updateHolder:updateHolder,convertToFastObject:convertToFastObject,updateTypes:updateTypes,setOrUpdateInterceptorsByTag:setOrUpdateInterceptorsByTag,setOrUpdateLeafTags:setOrUpdateLeafTags}}()
function initializeDeferredHunk(a){x=v.types.length
a(hunkHelpers,v,w,$)}var J={
i7(a,b,c,d){return{i:a,p:b,e:c,x:d}},
hd(a){var s,r,q,p,o,n=a[v.dispatchPropertyName]
if(n==null)if($.i4==null){A.mB()
n=a[v.dispatchPropertyName]}if(n!=null){s=n.p
if(!1===s)return n.i
if(!0===s)return a
r=Object.getPrototypeOf(a)
if(s===r)return n.i
if(n.e===r)throw A.f(A.hK("Return interceptor for "+A.t(s(a,n))))}q=a.constructor
if(q==null)p=null
else{o=$.fR
if(o==null)o=$.fR=v.getIsolateTag("_$dart_js")
p=q[o]}if(p!=null)return p
p=A.mF(a)
if(p!=null)return p
if(typeof a=="function")return B.av
s=Object.getPrototypeOf(a)
if(s==null)return B.a3
if(s===Object.prototype)return B.a3
if(typeof q=="function"){o=$.fR
if(o==null)o=$.fR=v.getIsolateTag("_$dart_js")
Object.defineProperty(q,o,{value:B.T,enumerable:false,writable:true,configurable:true})
return B.T}return B.T},
iu(a,b){if(a<0||a>4294967295)throw A.f(A.a5(a,0,4294967295,"length",null))
return J.kG(new Array(a),b)},
iv(a,b){if(a<0)throw A.f(A.a7("Length must be a non-negative integer: "+a,null))
return A.b(new Array(a),b.h("q<0>"))},
kG(a,b){var s=A.b(a,b.h("q<0>"))
s.$flags=1
return s},
b8(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.bR.prototype
return J.d3.prototype}if(typeof a=="string")return J.be.prototype
if(a==null)return J.bS.prototype
if(typeof a=="boolean")return J.bP.prototype
if(Array.isArray(a))return J.q.prototype
if(typeof a!="object"){if(typeof a=="function")return J.H.prototype
if(typeof a=="symbol")return J.bg.prototype
if(typeof a=="bigint")return J.bf.prototype
return a}if(a instanceof A.h)return a
return J.hd(a)},
aI(a){if(typeof a=="string")return J.be.prototype
if(a==null)return a
if(Array.isArray(a))return J.q.prototype
if(typeof a!="object"){if(typeof a=="function")return J.H.prototype
if(typeof a=="symbol")return J.bg.prototype
if(typeof a=="bigint")return J.bf.prototype
return a}if(a instanceof A.h)return a
return J.hd(a)},
aW(a){if(a==null)return a
if(Array.isArray(a))return J.q.prototype
if(typeof a!="object"){if(typeof a=="function")return J.H.prototype
if(typeof a=="symbol")return J.bg.prototype
if(typeof a=="bigint")return J.bf.prototype
return a}if(a instanceof A.h)return a
return J.hd(a)},
jD(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.H.prototype
if(typeof a=="symbol")return J.bg.prototype
if(typeof a=="bigint")return J.bf.prototype
return a}if(a instanceof A.h)return a
return J.hd(a)},
bb(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.b8(a).a_(a,b)},
k8(a,b){if(typeof b==="number")if(Array.isArray(a)||typeof a=="string"||A.mE(a,a[v.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.aI(a).k(a,b)},
k9(a,b,c){return J.aW(a).l(a,b,c)},
dG(a,b){return J.aW(a).n(a,b)},
ka(a){return J.jD(a).cl(a)},
kb(a,b,c){return J.jD(a).cm(a,b,c)},
id(a,b){return J.aI(a).T(a,b)},
hq(a,b){return J.aW(a).I(a,b)},
aw(a){return J.b8(a).gB(a)},
aY(a){return J.aW(a).gD(a)},
as(a){return J.aI(a).gm(a)},
kc(a){return J.b8(a).gG(a)},
dH(a,b,c){return J.aW(a).ad(a,b,c)},
kd(a,b){return J.aI(a).sm(a,b)},
ke(a,b){return J.aW(a).cJ(a,b)},
kf(a,b){return J.aW(a).cv(a,b)},
a6(a){return J.b8(a).j(a)},
d1:function d1(){},
bP:function bP(){},
bS:function bS(){},
I:function I(){},
aQ:function aQ(){},
di:function di(){},
cj:function cj(){},
H:function H(){},
bf:function bf(){},
bg:function bg(){},
q:function q(a){this.$ti=a},
d2:function d2(){},
eA:function eA(a){this.$ti=a},
bC:function bC(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
bT:function bT(){},
bR:function bR(){},
d3:function d3(){},
be:function be(){}},A={hA:function hA(){},
kN(a){return new A.bh("Field '"+a+"' has been assigned during initialization.")},
iG(a){return new A.bh("Field '"+a+"' has not been initialized.")},
kO(a){return new A.bh("Field '"+a+"' has already been initialized.")},
aT(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
hI(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
cL(a,b,c){return a},
i5(a){var s,r
for(s=$.ab.length,r=0;r<s;++r)if(a===$.ab[r])return!0
return!1},
hH(a,b,c,d){A.dk(b,"start")
if(c!=null){A.dk(c,"end")
if(b>c)A.a0(A.a5(b,0,c,"start",null))}return new A.ce(a,b,c,d.h("ce<0>"))},
iH(a,b,c,d){if(t.V.b(a))return new A.bK(a,b,c.h("@<0>").u(d).h("bK<1,2>"))
return new A.aB(a,b,c.h("@<0>").u(d).h("aB<1,2>"))},
ir(){return new A.bn("No element")},
bq:function bq(){},
bG:function bG(a,b){this.a=a
this.$ti=b},
cr:function cr(){},
ax:function ax(a,b){this.a=a
this.$ti=b},
bh:function bh(a){this.a=a},
f0:function f0(){},
n:function n(){},
M:function M(){},
ce:function ce(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
b1:function b1(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
aB:function aB(a,b,c){this.a=a
this.b=b
this.$ti=c},
bK:function bK(a,b,c){this.a=a
this.b=b
this.$ti=c},
bY:function bY(a,b,c){var _=this
_.a=null
_.b=a
_.c=b
_.$ti=c},
Y:function Y(a,b,c){this.a=a
this.b=b
this.$ti=c},
cm:function cm(a,b,c){this.a=a
this.b=b
this.$ti=c},
cn:function cn(a,b,c){this.a=a
this.b=b
this.$ti=c},
aZ:function aZ(a){this.$ti=a},
bL:function bL(a){this.$ti=a},
G:function G(){},
c8:function c8(a,b){this.a=a
this.$ti=b},
cH:function cH(){},
jK(a){var s=v.mangledGlobalNames[a]
if(s!=null)return s
return"minified:"+a},
mE(a,b){var s
if(b!=null){s=b.x
if(s!=null)return s}return t.aU.b(a)},
t(a){var s
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
s=J.a6(a)
return s},
c6(a){var s,r=$.iL
if(r==null)r=$.iL=Symbol("identityHashCode")
s=a[r]
if(s==null){s=Math.random()*0x3fffffff|0
a[r]=s}return s},
dj(a){var s,r,q,p
if(a instanceof A.h)return A.a_(A.aK(a),null)
s=J.b8(a)
if(s===B.aq||s===B.aw||t.ak.b(a)){r=B.V(a)
if(r!=="Object"&&r!=="")return r
q=a.constructor
if(typeof q=="function"){p=q.name
if(typeof p=="string"&&p!=="Object"&&p!=="")return p}}return A.a_(A.aK(a),null)},
l2(a){var s,r,q
if(a==null||typeof a=="number"||A.h5(a))return J.a6(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.aM)return a.j(0)
if(a instanceof A.cz)return a.hp(!0)
s=$.k7()
for(r=0;r<1;++r){q=s[r].hg(a)
if(q!=null)return q}return"Instance of '"+A.dj(a)+"'"},
iK(a){var s,r,q,p,o=a.length
if(o<=500)return String.fromCharCode.apply(null,a)
for(s="",r=0;r<o;r=q){q=r+500
p=q<o?q:o
s+=String.fromCharCode.apply(null,a.slice(r,p))}return s},
l3(a){var s,r,q,p=A.b([],t.t)
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.av)(a),++r){q=a[r]
if(!A.h6(q))throw A.f(A.cK(q))
if(q<=65535)B.a.n(p,q)
else if(q<=1114111){B.a.n(p,55296+(B.b.a6(q-65536,10)&1023))
B.a.n(p,56320+(q&1023))}else throw A.f(A.cK(q))}return A.iK(p)},
iM(a){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(!A.h6(q))throw A.f(A.cK(q))
if(q<0)throw A.f(A.cK(q))
if(q>65535)return A.l3(a)}return A.iK(a)},
l4(a,b,c){var s,r,q,p
if(c<=500&&b===0&&c===a.length)return String.fromCharCode.apply(null,a)
for(s=b,r="";s<c;s=q){q=s+500
p=q<c?q:c
r+=String.fromCharCode.apply(null,a.subarray(s,p))}return r},
bl(a){var s
if(0<=a){if(a<=65535)return String.fromCharCode(a)
if(a<=1114111){s=a-65536
return String.fromCharCode((B.b.a6(s,10)|55296)>>>0,s&1023|56320)}}throw A.f(A.a5(a,0,1114111,null,null))},
bk(a){if(a.date===void 0)a.date=new Date(a.a)
return a.date},
l1(a){var s=A.bk(a).getUTCFullYear()+0
return s},
l_(a){var s=A.bk(a).getUTCMonth()+1
return s},
kW(a){var s=A.bk(a).getUTCDate()+0
return s},
kX(a){var s=A.bk(a).getUTCHours()+0
return s},
kZ(a){var s=A.bk(a).getUTCMinutes()+0
return s},
l0(a){var s=A.bk(a).getUTCSeconds()+0
return s},
kY(a){var s=A.bk(a).getUTCMilliseconds()+0
return s},
kV(a){var s=a.$thrownJsError
if(s==null)return null
return A.aJ(s)},
iN(a,b){var s
if(a.$thrownJsError==null){s=new Error()
A.K(a,s)
a.$thrownJsError=s
s.stack=b.j(0)}},
a(a,b){if(a==null)J.as(a)
throw A.f(A.hb(a,b))},
hb(a,b){var s,r="index"
if(!A.h6(b))return new A.ag(!0,b,r,null)
s=J.as(a)
if(b<0||b>=s)return A.hw(b,s,a,r)
return new A.bm(null,null,!0,b,r,"Value not in range")},
mv(a,b,c){if(a>c)return A.a5(a,0,c,"start",null)
if(b!=null)if(b<a||b>c)return A.a5(b,a,c,"end",null)
return new A.ag(!0,b,"end",null)},
cK(a){return new A.ag(!0,a,null,null)},
f(a){return A.K(a,new Error())},
K(a,b){var s
if(a==null)a=new A.aD()
b.dartException=a
s=A.mL
if("defineProperty" in Object){Object.defineProperty(b,"message",{get:s})
b.name=""}else b.toString=s
return b},
mL(){return J.a6(this.dartException)},
a0(a,b){throw A.K(a,b==null?new Error():b)},
y(a,b,c){var s
if(b==null)b=0
if(c==null)c=0
s=Error()
A.a0(A.lR(a,b,c),s)},
lR(a,b,c){var s,r,q,p,o,n,m,l,k
if(typeof b=="string")s=b
else{r="[]=;add;removeWhere;retainWhere;removeRange;setRange;setInt8;setInt16;setInt32;setUint8;setUint16;setUint32;setFloat32;setFloat64".split(";")
q=r.length
p=b
if(p>q){c=p/q|0
p%=q}s=r[p]}o=typeof c=="string"?c:"modify;remove from;add to".split(";")[c]
n=t.j.b(a)?"list":"ByteData"
m=a.$flags|0
l="a "
if((m&4)!==0)k="constant "
else if((m&2)!==0){k="unmodifiable "
l="an "}else k=(m&1)!==0?"fixed-length ":""
return new A.ck("'"+s+"': Cannot "+o+" "+l+k+n)},
av(a){throw A.f(A.a1(a))},
aE(a){var s,r,q,p,o,n
a=A.jJ(a.replace(String({}),"$receiver$"))
s=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(s==null)s=A.b([],t.s)
r=s.indexOf("\\$arguments\\$")
q=s.indexOf("\\$argumentsExpr\\$")
p=s.indexOf("\\$expr\\$")
o=s.indexOf("\\$method\\$")
n=s.indexOf("\\$receiver\\$")
return new A.fd(a.replace(new RegExp("\\\\\\$arguments\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$argumentsExpr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$expr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$method\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$receiver\\\\\\$","g"),"((?:x|[^x])*)"),r,q,p,o,n)},
fe(a){return function($expr$){var $argumentsExpr$="$arguments$"
try{$expr$.$method$($argumentsExpr$)}catch(s){return s.message}}(a)},
iV(a){return function($expr$){try{$expr$.$method$}catch(s){return s.message}}(a)},
hB(a,b){var s=b==null,r=s?null:b.method
return new A.d7(a,r,s?null:b.receiver)},
ar(a){var s
if(a==null)return new A.eO(a)
if(a instanceof A.bN){s=a.a
return A.aX(a,s==null?A.j(s):s)}if(typeof a!=="object")return a
if("dartException" in a)return A.aX(a,a.dartException)
return A.mm(a)},
aX(a,b){if(t.C.b(b))if(b.$thrownJsError==null)b.$thrownJsError=a
return b},
mm(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(!("message" in a))return a
s=a.message
if("number" in a&&typeof a.number=="number"){r=a.number
q=r&65535
if((B.b.a6(r,16)&8191)===10)switch(q){case 438:return A.aX(a,A.hB(A.t(s)+" (Error "+q+")",null))
case 445:case 5007:A.t(s)
return A.aX(a,new A.c4())}}if(a instanceof TypeError){p=$.jR()
o=$.jS()
n=$.jT()
m=$.jU()
l=$.jX()
k=$.jY()
j=$.jW()
$.jV()
i=$.k_()
h=$.jZ()
g=p.V(s)
if(g!=null)return A.aX(a,A.hB(A.k(s),g))
else{g=o.V(s)
if(g!=null){g.method="call"
return A.aX(a,A.hB(A.k(s),g))}else if(n.V(s)!=null||m.V(s)!=null||l.V(s)!=null||k.V(s)!=null||j.V(s)!=null||m.V(s)!=null||i.V(s)!=null||h.V(s)!=null){A.k(s)
return A.aX(a,new A.c4())}}return A.aX(a,new A.dq(typeof s=="string"?s:""))}if(a instanceof RangeError){if(typeof s=="string"&&s.indexOf("call stack")!==-1)return new A.cc()
s=function(b){try{return String(b)}catch(f){}return null}(a)
return A.aX(a,new A.ag(!1,null,null,typeof s=="string"?s.replace(/^RangeError:\s*/,""):s))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof s=="string"&&s==="too much recursion")return new A.cc()
return a},
aJ(a){var s
if(a instanceof A.bN)return a.b
if(a==null)return new A.cA(a)
s=a.$cachedTrace
if(s!=null)return s
s=new A.cA(a)
if(typeof a==="object")a.$cachedTrace=s
return s},
dF(a){if(a==null)return J.aw(a)
if(typeof a=="object")return A.c6(a)
return J.aw(a)},
mr(a){if(typeof a=="number")return B.at.gB(a)
if(a instanceof A.dB)return A.c6(a)
if(a instanceof A.cz)return a.gB(a)
return A.dF(a)},
jC(a,b){var s,r,q,p=a.length
for(s=0;s<p;s=q){r=s+1
q=r+1
b.l(0,a[s],a[r])}return b},
m_(a,b,c,d,e,f){t.Z.a(a)
switch(A.af(b)){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw A.f(new A.fD("Unsupported number of arguments for wrapped closure"))},
cM(a,b){var s=a.$identity
if(!!s)return s
s=A.ms(a,b)
a.$identity=s
return s},
ms(a,b){var s
switch(b){case 0:s=a.$0
break
case 1:s=a.$1
break
case 2:s=a.$2
break
case 3:s=a.$3
break
case 4:s=a.$4
break
default:s=null}if(s!=null)return s.bind(a)
return function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,A.m_)},
kt(a2){var s,r,q,p,o,n,m,l,k,j,i=a2.co,h=a2.iS,g=a2.iI,f=a2.nDA,e=a2.aI,d=a2.fs,c=a2.cs,b=d[0],a=c[0],a0=i[b],a1=a2.fT
a1.toString
s=h?Object.create(new A.dm().constructor.prototype):Object.create(new A.bd(null,null).constructor.prototype)
s.$initialize=s.constructor
r=h?function static_tear_off(){this.$initialize()}:function tear_off(a3,a4){this.$initialize(a3,a4)}
s.constructor=r
r.prototype=s
s.$_name=b
s.$_target=a0
q=!h
if(q)p=A.io(b,a0,g,f)
else{s.$static_name=b
p=a0}s.$S=A.kp(a1,h,g)
s[a]=p
for(o=p,n=1;n<d.length;++n){m=d[n]
if(typeof m=="string"){l=i[m]
k=m
m=l}else k=""
j=c[n]
if(j!=null){if(q)m=A.io(k,m,g,f)
s[j]=m}if(n===e)o=m}s.$C=o
s.$R=a2.rC
s.$D=a2.dV
return r},
kp(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.f("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.kl)}throw A.f("Error in functionType of tearoff")},
kq(a,b,c,d){var s=A.il
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,s)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,s)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,s)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,s)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,s)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,s)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,s)}},
io(a,b,c,d){if(c)return A.ks(a,b,d)
return A.kq(b.length,d,a,b)},
kr(a,b,c,d){var s=A.il,r=A.km
switch(b?-1:a){case 0:throw A.f(new A.dl("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,r,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,r,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,r,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,r,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,r,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,r,s)
default:return function(e,f,g){return function(){var q=[g(this)]
Array.prototype.push.apply(q,arguments)
return e.apply(f(this),q)}}(d,r,s)}},
ks(a,b,c){var s,r
if($.ij==null)$.ij=A.ii("interceptor")
if($.ik==null)$.ik=A.ii("receiver")
s=b.length
r=A.kr(s,c,a,b)
return r},
i1(a){return A.kt(a)},
kl(a,b){return A.cF(v.typeUniverse,A.aK(a.a),b)},
il(a){return a.a},
km(a){return a.b},
ii(a){var s,r,q,p=new A.bd("receiver","interceptor"),o=Object.getOwnPropertyNames(p)
o.$flags=1
s=o
for(o=s.length,r=0;r<o;++r){q=s[r]
if(p[q]===a)return q}throw A.f(A.a7("Field name "+a+" not found.",null))},
my(a){return v.getIsolateTag(a)},
mt(a){var s,r=A.b([],t.s)
if(a==null)return r
if(Array.isArray(a)){for(s=0;s<a.length;++s)r.push(String(a[s]))
return r}r.push(String(a))
return r},
nk(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
mF(a){var s,r,q,p,o,n=A.k($.jE.$1(a)),m=$.hc[n]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.hh[n]
if(s!=null)return s
r=v.interceptorsByTag[n]
if(r==null){q=A.A($.jz.$2(a,n))
if(q!=null){m=$.hc[q]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.hh[q]
if(s!=null)return s
r=v.interceptorsByTag[q]
n=q}}if(r==null)return null
s=r.prototype
p=n[0]
if(p==="!"){m=A.hl(s)
$.hc[n]=m
Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}if(p==="~"){$.hh[n]=s
return s}if(p==="-"){o=A.hl(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}if(p==="+")return A.jG(a,s)
if(p==="*")throw A.f(A.hK(n))
if(v.leafTags[n]===true){o=A.hl(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}else return A.jG(a,s)},
jG(a,b){var s=Object.getPrototypeOf(a)
Object.defineProperty(s,v.dispatchPropertyName,{value:J.i7(b,s,null,null),enumerable:false,writable:true,configurable:true})
return b},
hl(a){return J.i7(a,!1,null,!!a.$ia9)},
mH(a,b,c){var s=b.prototype
if(v.leafTags[a]===true)return A.hl(s)
else return J.i7(s,c,null,null)},
mB(){if(!0===$.i4)return
$.i4=!0
A.mC()},
mC(){var s,r,q,p,o,n,m,l
$.hc=Object.create(null)
$.hh=Object.create(null)
A.mA()
s=v.interceptorsByTag
r=Object.getOwnPropertyNames(s)
if(typeof window!="undefined"){window
q=function(){}
for(p=0;p<r.length;++p){o=r[p]
n=$.jI.$1(o)
if(n!=null){m=A.mH(o,s[o],n)
if(m!=null){Object.defineProperty(n,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
q.prototype=n}}}}for(p=0;p<r.length;++p){o=r[p]
if(/^[A-Za-z_]/.test(o)){l=s[o]
s["!"+o]=l
s["~"+o]=l
s["-"+o]=l
s["+"+o]=l
s["*"+o]=l}}},
mA(){var s,r,q,p,o,n,m=B.ah()
m=A.bw(B.ai,A.bw(B.aj,A.bw(B.W,A.bw(B.W,A.bw(B.ak,A.bw(B.al,A.bw(B.am(B.V),m)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){s=dartNativeDispatchHooksTransformer
if(typeof s=="function")s=[s]
if(Array.isArray(s))for(r=0;r<s.length;++r){q=s[r]
if(typeof q=="function")m=q(m)||m}}p=m.getTag
o=m.getUnknownTag
n=m.prototypeForTag
$.jE=new A.he(p)
$.jz=new A.hf(o)
$.jI=new A.hg(n)},
bw(a,b){return a(b)||b},
mu(a,b){var s=b.length,r=v.rttc[""+s+";"+a]
if(r==null)return null
if(s===0)return r
if(s===r.length)return r.apply(null,b)
return r(b)},
kL(a,b,c,d,e,f){var s=b?"m":"",r=c?"":"i",q=d?"u":"",p=e?"s":"",o=function(g,h){try{return new RegExp(g,h)}catch(n){return n}}(a,s+r+q+p+f)
if(o instanceof RegExp)return o
throw A.f(A.hv("Illegal RegExp pattern ("+String(o)+")",a,null))},
mw(a){if(a.indexOf("$",0)>=0)return a.replace(/\$/g,"$$$$")
return a},
jJ(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
by(a,b,c){var s=A.mI(a,b,c)
return s},
mI(a,b,c){var s,r,q
if(b===""){if(a==="")return c
s=a.length
for(r=c,q=0;q<s;++q)r=r+a[q]+c
return r.charCodeAt(0)==0?r:r}if(a.indexOf(b,0)<0)return a
if(a.length<500||c.indexOf("$",0)>=0)return a.split(b).join(c)
return a.replace(new RegExp(A.jJ(b),"g"),A.mw(c))},
bI:function bI(){},
bO:function bO(a,b){this.a=a
this.$ti=b},
ca:function ca(){},
fd:function fd(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
c4:function c4(){},
d7:function d7(a,b,c){this.a=a
this.b=b
this.c=c},
dq:function dq(a){this.a=a},
eO:function eO(a){this.a=a},
bN:function bN(a,b){this.a=a
this.b=b},
cA:function cA(a){this.a=a
this.b=null},
aM:function aM(){},
cR:function cR(){},
cS:function cS(){},
dn:function dn(){},
dm:function dm(){},
bd:function bd(a,b){this.a=a
this.b=b},
dl:function dl(a){this.a=a},
ay:function ay(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
eJ:function eJ(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=null},
b0:function b0(a,b){this.a=a
this.$ti=b},
bW:function bW(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
az:function az(a,b){this.a=a
this.$ti=b},
bV:function bV(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
bU:function bU(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
he:function he(a){this.a=a},
hf:function hf(a){this.a=a},
hg:function hg(a){this.a=a},
cz:function cz(){},
d6:function d6(a,b){var _=this
_.a=a
_.b=b
_.e=_.d=_.c=null},
mK(a){throw A.K(A.iG(a),new Error())},
mJ(a){throw A.K(A.kO(a),new Error())},
i8(a){throw A.K(A.kN(a),new Error())},
fB(a){var s=new A.fA(a)
return s.b=s},
fA:function fA(a){this.a=a
this.b=null},
lP(a){return a},
h4(a,b,c){},
kS(a,b,c){var s
A.h4(a,b,c)
s=new DataView(a,b)
return s},
iI(a){return new Uint8Array(a)},
kT(a,b,c){var s
A.h4(a,b,c)
s=new Uint8Array(a,b,c)
return s},
aH(a,b,c){if(a>>>0!==a||a>=c)throw A.f(A.hb(b,a))},
lQ(a,b,c){var s
if(!(a>>>0!==a))s=b>>>0!==b||a>b||b>c
else s=!0
if(s)throw A.f(A.mv(a,b,c))
return b},
b2:function b2(){},
c2:function c2(){},
dC:function dC(a){this.a=a},
c_:function c_(){},
bi:function bi(){},
c0:function c0(){},
c1:function c1(){},
d9:function d9(){},
da:function da(){},
db:function db(){},
dc:function dc(){},
dd:function dd(){},
de:function de(){},
df:function df(){},
c3:function c3(){},
b3:function b3(){},
cv:function cv(){},
cw:function cw(){},
cx:function cx(){},
cy:function cy(){},
hF(a,b){var s=b.c
return s==null?b.c=A.cD(a,"Q",[b.x]):s},
iP(a){var s=a.w
if(s===6||s===7)return A.iP(a.x)
return s===11||s===12},
l7(a){return a.as},
au(a){return A.fX(v.typeUniverse,a,!1)},
b6(a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=a2.w
switch(a0){case 5:case 1:case 2:case 3:case 4:return a2
case 6:s=a2.x
r=A.b6(a1,s,a3,a4)
if(r===s)return a2
return A.je(a1,r,!0)
case 7:s=a2.x
r=A.b6(a1,s,a3,a4)
if(r===s)return a2
return A.jd(a1,r,!0)
case 8:q=a2.y
p=A.bv(a1,q,a3,a4)
if(p===q)return a2
return A.cD(a1,a2.x,p)
case 9:o=a2.x
n=A.b6(a1,o,a3,a4)
m=a2.y
l=A.bv(a1,m,a3,a4)
if(n===o&&l===m)return a2
return A.hU(a1,n,l)
case 10:k=a2.x
j=a2.y
i=A.bv(a1,j,a3,a4)
if(i===j)return a2
return A.jf(a1,k,i)
case 11:h=a2.x
g=A.b6(a1,h,a3,a4)
f=a2.y
e=A.mj(a1,f,a3,a4)
if(g===h&&e===f)return a2
return A.jc(a1,g,e)
case 12:d=a2.y
a4+=d.length
c=A.bv(a1,d,a3,a4)
o=a2.x
n=A.b6(a1,o,a3,a4)
if(c===d&&n===o)return a2
return A.hV(a1,n,c,!0)
case 13:b=a2.x
if(b<a4)return a2
a=a3[b-a4]
if(a==null)return a2
return a
default:throw A.f(A.cP("Attempted to substitute unexpected RTI kind "+a0))}},
bv(a,b,c,d){var s,r,q,p,o=b.length,n=A.h1(o)
for(s=!1,r=0;r<o;++r){q=b[r]
p=A.b6(a,q,c,d)
if(p!==q)s=!0
n[r]=p}return s?n:b},
mk(a,b,c,d){var s,r,q,p,o,n,m=b.length,l=A.h1(m)
for(s=!1,r=0;r<m;r+=3){q=b[r]
p=b[r+1]
o=b[r+2]
n=A.b6(a,o,c,d)
if(n!==o)s=!0
l.splice(r,3,q,p,n)}return s?l:b},
mj(a,b,c,d){var s,r=b.a,q=A.bv(a,r,c,d),p=b.b,o=A.bv(a,p,c,d),n=b.c,m=A.mk(a,n,c,d)
if(q===r&&o===p&&m===n)return b
s=new A.dx()
s.a=q
s.b=o
s.c=m
return s},
b(a,b){a[v.arrayRti]=b
return a},
jB(a){var s=a.$S
if(s!=null){if(typeof s=="number")return A.mz(s)
return a.$S()}return null},
mD(a,b){var s
if(A.iP(b))if(a instanceof A.aM){s=A.jB(a)
if(s!=null)return s}return A.aK(a)},
aK(a){if(a instanceof A.h)return A.S(a)
if(Array.isArray(a))return A.R(a)
return A.hY(J.b8(a))},
R(a){var s=a[v.arrayRti],r=t.b
if(s==null)return r
if(s.constructor!==r.constructor)return r
return s},
S(a){var s=a.$ti
return s!=null?s:A.hY(a)},
hY(a){var s=a.constructor,r=s.$ccache
if(r!=null)return r
return A.lY(a,s)},
lY(a,b){var s=a instanceof A.aM?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,r=A.lA(v.typeUniverse,s.name)
b.$ccache=r
return r},
mz(a){var s,r=v.types,q=r[a]
if(typeof q=="string"){s=A.fX(v.typeUniverse,q,!1)
r[a]=s
return s}return q},
i3(a){return A.b7(A.S(a))},
i0(a){var s
if(a instanceof A.cz)return A.mx(a.$r,a.ho())
s=a instanceof A.aM?A.jB(a):null
if(s!=null)return s
if(t.dm.b(a))return J.kc(a).a
if(Array.isArray(a))return A.R(a)
return A.aK(a)},
b7(a){var s=a.r
return s==null?a.r=new A.dB(a):s},
mx(a,b){var s,r,q=b,p=q.length
if(p===0)return t.bQ
if(0>=p)return A.a(q,0)
s=A.cF(v.typeUniverse,A.i0(q[0]),"@<0>")
for(r=1;r<p;++r){if(!(r<q.length))return A.a(q,r)
s=A.jg(v.typeUniverse,s,A.i0(q[r]))}return A.cF(v.typeUniverse,s,a)},
aq(a){return A.b7(A.fX(v.typeUniverse,a,!1))},
lX(a){var s=this
s.b=A.mh(s)
return s.b(a)},
mh(a){var s,r,q,p,o
if(a===t.K)return A.m5
if(A.b9(a))return A.m9
s=a.w
if(s===6)return A.lV
if(s===1)return A.js
if(s===7)return A.m0
r=A.mg(a)
if(r!=null)return r
if(s===8){q=a.x
if(a.y.every(A.b9)){a.f="$i"+q
if(q==="o")return A.m3
if(a===t.m)return A.m2
return A.m8}}else if(s===10){p=A.mu(a.x,a.y)
o=p==null?A.js:p
return o==null?A.j(o):o}return A.lT},
mg(a){if(a.w===8){if(a===t.S)return A.h6
if(a===t.i||a===t.o)return A.m4
if(a===t.N)return A.m7
if(a===t.y)return A.h5}return null},
lW(a){var s=this,r=A.lS
if(A.b9(s))r=A.lI
else if(s===t.K)r=A.j
else if(A.bx(s)){r=A.lU
if(s===t.h6)r=A.lG
else if(s===t.dk)r=A.A
else if(s===t.fQ)r=A.ak
else if(s===t.cg)r=A.jm
else if(s===t.cD)r=A.lF
else if(s===t.B)r=A.F}else if(s===t.S)r=A.af
else if(s===t.N)r=A.k
else if(s===t.y)r=A.jk
else if(s===t.o)r=A.lH
else if(s===t.i)r=A.jl
else if(s===t.m)r=A.d
s.a=r
return s.a(a)},
lT(a){var s=this
if(a==null)return A.bx(s)
return A.jF(v.typeUniverse,A.mD(a,s),s)},
lV(a){if(a==null)return!0
return this.x.b(a)},
m8(a){var s,r=this
if(a==null)return A.bx(r)
s=r.f
if(a instanceof A.h)return!!a[s]
return!!J.b8(a)[s]},
m3(a){var s,r=this
if(a==null)return A.bx(r)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
s=r.f
if(a instanceof A.h)return!!a[s]
return!!J.b8(a)[s]},
m2(a){var s=this
if(a==null)return!1
if(typeof a=="object"){if(a instanceof A.h)return!!a[s.f]
return!0}if(typeof a=="function")return!0
return!1},
jr(a){if(typeof a=="object"){if(a instanceof A.h)return t.m.b(a)
return!0}if(typeof a=="function")return!0
return!1},
lS(a){var s=this
if(a==null){if(A.bx(s))return a}else if(s.b(a))return a
throw A.K(A.jn(a,s),new Error())},
lU(a){var s=this
if(a==null||s.b(a))return a
throw A.K(A.jn(a,s),new Error())},
jn(a,b){return new A.bt("TypeError: "+A.j5(a,A.a_(b,null)))},
mq(a,b,c,d){if(A.jF(v.typeUniverse,a,b))return a
throw A.K(A.ls("The type argument '"+A.a_(a,null)+"' is not a subtype of the type variable bound '"+A.a_(b,null)+"' of type variable '"+c+"' in '"+d+"'."),new Error())},
j5(a,b){return A.e2(a)+": type '"+A.a_(A.i0(a),null)+"' is not a subtype of type '"+b+"'"},
ls(a){return new A.bt("TypeError: "+a)},
ae(a,b){return new A.bt("TypeError: "+A.j5(a,b))},
m0(a){var s=this
return s.x.b(a)||A.hF(v.typeUniverse,s).b(a)},
m5(a){return a!=null},
j(a){if(a!=null)return a
throw A.K(A.ae(a,"Object"),new Error())},
m9(a){return!0},
lI(a){return a},
js(a){return!1},
h5(a){return!0===a||!1===a},
jk(a){if(!0===a)return!0
if(!1===a)return!1
throw A.K(A.ae(a,"bool"),new Error())},
ak(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.K(A.ae(a,"bool?"),new Error())},
jl(a){if(typeof a=="number")return a
throw A.K(A.ae(a,"double"),new Error())},
lF(a){if(typeof a=="number")return a
if(a==null)return a
throw A.K(A.ae(a,"double?"),new Error())},
h6(a){return typeof a=="number"&&Math.floor(a)===a},
af(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.K(A.ae(a,"int"),new Error())},
lG(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.K(A.ae(a,"int?"),new Error())},
m4(a){return typeof a=="number"},
lH(a){if(typeof a=="number")return a
throw A.K(A.ae(a,"num"),new Error())},
jm(a){if(typeof a=="number")return a
if(a==null)return a
throw A.K(A.ae(a,"num?"),new Error())},
m7(a){return typeof a=="string"},
k(a){if(typeof a=="string")return a
throw A.K(A.ae(a,"String"),new Error())},
A(a){if(typeof a=="string")return a
if(a==null)return a
throw A.K(A.ae(a,"String?"),new Error())},
d(a){if(A.jr(a))return a
throw A.K(A.ae(a,"JSObject"),new Error())},
F(a){if(a==null)return a
if(A.jr(a))return a
throw A.K(A.ae(a,"JSObject?"),new Error())},
jx(a,b){var s,r,q
for(s="",r="",q=0;q<a.length;++q,r=", ")s+=r+A.a_(a[q],b)
return s},
mc(a,b){var s,r,q,p,o,n,m=a.x,l=a.y
if(""===m)return"("+A.jx(l,b)+")"
s=l.length
r=m.split(",")
q=r.length-s
for(p="(",o="",n=0;n<s;++n,o=", "){p+=o
if(q===0)p+="{"
p+=A.a_(l[n],b)
if(q>=0)p+=" "+r[q];++q}return p+"})"},
jo(a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=", ",a2=null
if(a5!=null){s=a5.length
if(a4==null)a4=A.b([],t.s)
else a2=a4.length
r=a4.length
for(q=s;q>0;--q)B.a.n(a4,"T"+(r+q))
for(p=t.X,o="<",n="",q=0;q<s;++q,n=a1){m=a4.length
l=m-1-q
if(!(l>=0))return A.a(a4,l)
o=o+n+a4[l]
k=a5[q]
j=k.w
if(!(j===2||j===3||j===4||j===5||k===p))o+=" extends "+A.a_(k,a4)}o+=">"}else o=""
p=a3.x
i=a3.y
h=i.a
g=h.length
f=i.b
e=f.length
d=i.c
c=d.length
b=A.a_(p,a4)
for(a="",a0="",q=0;q<g;++q,a0=a1)a+=a0+A.a_(h[q],a4)
if(e>0){a+=a0+"["
for(a0="",q=0;q<e;++q,a0=a1)a+=a0+A.a_(f[q],a4)
a+="]"}if(c>0){a+=a0+"{"
for(a0="",q=0;q<c;q+=3,a0=a1){a+=a0
if(d[q+1])a+="required "
a+=A.a_(d[q+2],a4)+" "+d[q]}a+="}"}if(a2!=null){a4.toString
a4.length=a2}return o+"("+a+") => "+b},
a_(a,b){var s,r,q,p,o,n,m,l=a.w
if(l===5)return"erased"
if(l===2)return"dynamic"
if(l===3)return"void"
if(l===1)return"Never"
if(l===4)return"any"
if(l===6){s=a.x
r=A.a_(s,b)
q=s.w
return(q===11||q===12?"("+r+")":r)+"?"}if(l===7)return"FutureOr<"+A.a_(a.x,b)+">"
if(l===8){p=A.ml(a.x)
o=a.y
return o.length>0?p+("<"+A.jx(o,b)+">"):p}if(l===10)return A.mc(a,b)
if(l===11)return A.jo(a,b,null)
if(l===12)return A.jo(a.x,b,a.y)
if(l===13){n=a.x
m=b.length
n=m-1-n
if(!(n>=0&&n<m))return A.a(b,n)
return b[n]}return"?"},
ml(a){var s=v.mangledGlobalNames[a]
if(s!=null)return s
return"minified:"+a},
lB(a,b){var s=a.tR[b]
for(;typeof s=="string";)s=a.tR[s]
return s},
lA(a,b){var s,r,q,p,o,n=a.eT,m=n[b]
if(m==null)return A.fX(a,b,!1)
else if(typeof m=="number"){s=m
r=A.cE(a,5,"#")
q=A.h1(s)
for(p=0;p<s;++p)q[p]=r
o=A.cD(a,b,q)
n[b]=o
return o}else return m},
lz(a,b){return A.ji(a.tR,b)},
ly(a,b){return A.ji(a.eT,b)},
fX(a,b,c){var s,r=a.eC,q=r.get(b)
if(q!=null)return q
s=A.ja(A.j8(a,null,b,!1))
r.set(b,s)
return s},
cF(a,b,c){var s,r,q=b.z
if(q==null)q=b.z=new Map()
s=q.get(c)
if(s!=null)return s
r=A.ja(A.j8(a,b,c,!0))
q.set(c,r)
return r},
jg(a,b,c){var s,r,q,p=b.Q
if(p==null)p=b.Q=new Map()
s=c.as
r=p.get(s)
if(r!=null)return r
q=A.hU(a,b,c.w===9?c.y:[c])
p.set(s,q)
return q},
aU(a,b){b.a=A.lW
b.b=A.lX
return b},
cE(a,b,c){var s,r,q=a.eC.get(c)
if(q!=null)return q
s=new A.aj(null,null)
s.w=b
s.as=c
r=A.aU(a,s)
a.eC.set(c,r)
return r},
je(a,b,c){var s,r=b.as+"?",q=a.eC.get(r)
if(q!=null)return q
s=A.lw(a,b,r,c)
a.eC.set(r,s)
return s},
lw(a,b,c,d){var s,r,q
if(d){s=b.w
r=!0
if(!A.b9(b))if(!(b===t.P||b===t.T))if(s!==6)r=s===7&&A.bx(b.x)
if(r)return b
else if(s===1)return t.P}q=new A.aj(null,null)
q.w=6
q.x=b
q.as=c
return A.aU(a,q)},
jd(a,b,c){var s,r=b.as+"/",q=a.eC.get(r)
if(q!=null)return q
s=A.lu(a,b,r,c)
a.eC.set(r,s)
return s},
lu(a,b,c,d){var s,r
if(d){s=b.w
if(A.b9(b)||b===t.K)return b
else if(s===1)return A.cD(a,"Q",[b])
else if(b===t.P||b===t.T)return t.eH}r=new A.aj(null,null)
r.w=7
r.x=b
r.as=c
return A.aU(a,r)},
lx(a,b){var s,r,q=""+b+"^",p=a.eC.get(q)
if(p!=null)return p
s=new A.aj(null,null)
s.w=13
s.x=b
s.as=q
r=A.aU(a,s)
a.eC.set(q,r)
return r},
cC(a){var s,r,q,p=a.length
for(s="",r="",q=0;q<p;++q,r=",")s+=r+a[q].as
return s},
lt(a){var s,r,q,p,o,n=a.length
for(s="",r="",q=0;q<n;q+=3,r=","){p=a[q]
o=a[q+1]?"!":":"
s+=r+p+o+a[q+2].as}return s},
cD(a,b,c){var s,r,q,p=b
if(c.length>0)p+="<"+A.cC(c)+">"
s=a.eC.get(p)
if(s!=null)return s
r=new A.aj(null,null)
r.w=8
r.x=b
r.y=c
if(c.length>0)r.c=c[0]
r.as=p
q=A.aU(a,r)
a.eC.set(p,q)
return q},
hU(a,b,c){var s,r,q,p,o,n
if(b.w===9){s=b.x
r=b.y.concat(c)}else{r=c
s=b}q=s.as+(";<"+A.cC(r)+">")
p=a.eC.get(q)
if(p!=null)return p
o=new A.aj(null,null)
o.w=9
o.x=s
o.y=r
o.as=q
n=A.aU(a,o)
a.eC.set(q,n)
return n},
jf(a,b,c){var s,r,q="+"+(b+"("+A.cC(c)+")"),p=a.eC.get(q)
if(p!=null)return p
s=new A.aj(null,null)
s.w=10
s.x=b
s.y=c
s.as=q
r=A.aU(a,s)
a.eC.set(q,r)
return r},
jc(a,b,c){var s,r,q,p,o,n=b.as,m=c.a,l=m.length,k=c.b,j=k.length,i=c.c,h=i.length,g="("+A.cC(m)
if(j>0){s=l>0?",":""
g+=s+"["+A.cC(k)+"]"}if(h>0){s=l>0?",":""
g+=s+"{"+A.lt(i)+"}"}r=n+(g+")")
q=a.eC.get(r)
if(q!=null)return q
p=new A.aj(null,null)
p.w=11
p.x=b
p.y=c
p.as=r
o=A.aU(a,p)
a.eC.set(r,o)
return o},
hV(a,b,c,d){var s,r=b.as+("<"+A.cC(c)+">"),q=a.eC.get(r)
if(q!=null)return q
s=A.lv(a,b,c,r,d)
a.eC.set(r,s)
return s},
lv(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(e){s=c.length
r=A.h1(s)
for(q=0,p=0;p<s;++p){o=c[p]
if(o.w===1){r[p]=o;++q}}if(q>0){n=A.b6(a,b,r,0)
m=A.bv(a,c,r,0)
return A.hV(a,n,m,c!==m)}}l=new A.aj(null,null)
l.w=12
l.x=b
l.y=c
l.as=d
return A.aU(a,l)},
j8(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
ja(a){var s,r,q,p,o,n,m,l=a.r,k=a.s
for(s=l.length,r=0;r<s;){q=l.charCodeAt(r)
if(q>=48&&q<=57)r=A.lm(r+1,q,l,k)
else if((((q|32)>>>0)-97&65535)<26||q===95||q===36||q===124)r=A.j9(a,r,l,k,!1)
else if(q===46)r=A.j9(a,r,l,k,!0)
else{++r
switch(q){case 44:break
case 58:k.push(!1)
break
case 33:k.push(!0)
break
case 59:k.push(A.b5(a.u,a.e,k.pop()))
break
case 94:k.push(A.lx(a.u,k.pop()))
break
case 35:k.push(A.cE(a.u,5,"#"))
break
case 64:k.push(A.cE(a.u,2,"@"))
break
case 126:k.push(A.cE(a.u,3,"~"))
break
case 60:k.push(a.p)
a.p=k.length
break
case 62:A.lo(a,k)
break
case 38:A.ln(a,k)
break
case 63:p=a.u
k.push(A.je(p,A.b5(p,a.e,k.pop()),a.n))
break
case 47:p=a.u
k.push(A.jd(p,A.b5(p,a.e,k.pop()),a.n))
break
case 40:k.push(-3)
k.push(a.p)
a.p=k.length
break
case 41:A.ll(a,k)
break
case 91:k.push(a.p)
a.p=k.length
break
case 93:o=k.splice(a.p)
A.jb(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-1)
break
case 123:k.push(a.p)
a.p=k.length
break
case 125:o=k.splice(a.p)
A.lq(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-2)
break
case 43:n=l.indexOf("(",r)
k.push(l.substring(r,n))
k.push(-4)
k.push(a.p)
a.p=k.length
r=n+1
break
default:throw"Bad character "+q}}}m=k.pop()
return A.b5(a.u,a.e,m)},
lm(a,b,c,d){var s,r,q=b-48
for(s=c.length;a<s;++a){r=c.charCodeAt(a)
if(!(r>=48&&r<=57))break
q=q*10+(r-48)}d.push(q)
return a},
j9(a,b,c,d,e){var s,r,q,p,o,n,m=b+1
for(s=c.length;m<s;++m){r=c.charCodeAt(m)
if(r===46){if(e)break
e=!0}else{if(!((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124))q=r>=48&&r<=57
else q=!0
if(!q)break}}p=c.substring(b,m)
if(e){s=a.u
o=a.e
if(o.w===9)o=o.x
n=A.lB(s,o.x)[p]
if(n==null)A.a0('No "'+p+'" in "'+A.l7(o)+'"')
d.push(A.cF(s,o,n))}else d.push(p)
return m},
lo(a,b){var s,r=a.u,q=A.j7(a,b),p=b.pop()
if(typeof p=="string")b.push(A.cD(r,p,q))
else{s=A.b5(r,a.e,p)
switch(s.w){case 11:b.push(A.hV(r,s,q,a.n))
break
default:b.push(A.hU(r,s,q))
break}}},
ll(a,b){var s,r,q,p=a.u,o=b.pop(),n=null,m=null
if(typeof o=="number")switch(o){case-1:n=b.pop()
break
case-2:m=b.pop()
break
default:b.push(o)
break}else b.push(o)
s=A.j7(a,b)
o=b.pop()
switch(o){case-3:o=b.pop()
if(n==null)n=p.sEA
if(m==null)m=p.sEA
r=A.b5(p,a.e,o)
q=new A.dx()
q.a=s
q.b=n
q.c=m
b.push(A.jc(p,r,q))
return
case-4:b.push(A.jf(p,b.pop(),s))
return
default:throw A.f(A.cP("Unexpected state under `()`: "+A.t(o)))}},
ln(a,b){var s=b.pop()
if(0===s){b.push(A.cE(a.u,1,"0&"))
return}if(1===s){b.push(A.cE(a.u,4,"1&"))
return}throw A.f(A.cP("Unexpected extended operation "+A.t(s)))},
j7(a,b){var s=b.splice(a.p)
A.jb(a.u,a.e,s)
a.p=b.pop()
return s},
b5(a,b,c){if(typeof c=="string")return A.cD(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.lp(a,b,c)}else return c},
jb(a,b,c){var s,r=c.length
for(s=0;s<r;++s)c[s]=A.b5(a,b,c[s])},
lq(a,b,c){var s,r=c.length
for(s=2;s<r;s+=3)c[s]=A.b5(a,b,c[s])},
lp(a,b,c){var s,r,q=b.w
if(q===9){if(c===0)return b.x
s=b.y
r=s.length
if(c<=r)return s[c-1]
c-=r
b=b.x
q=b.w}else if(c===0)return b
if(q!==8)throw A.f(A.cP("Indexed base must be an interface type"))
s=b.y
if(c<=s.length)return s[c-1]
throw A.f(A.cP("Bad index "+c+" for "+b.j(0)))},
jF(a,b,c){var s,r=b.d
if(r==null)r=b.d=new Map()
s=r.get(c)
if(s==null){s=A.O(a,b,null,c,null)
r.set(c,s)}return s},
O(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i
if(b===d)return!0
if(A.b9(d))return!0
s=b.w
if(s===4)return!0
if(A.b9(b))return!1
if(b.w===1)return!0
r=s===13
if(r)if(A.O(a,c[b.x],c,d,e))return!0
q=d.w
p=t.P
if(b===p||b===t.T){if(q===7)return A.O(a,b,c,d.x,e)
return d===p||d===t.T||q===6}if(d===t.K){if(s===7)return A.O(a,b.x,c,d,e)
return s!==6}if(s===7){if(!A.O(a,b.x,c,d,e))return!1
return A.O(a,A.hF(a,b),c,d,e)}if(s===6)return A.O(a,p,c,d,e)&&A.O(a,b.x,c,d,e)
if(q===7){if(A.O(a,b,c,d.x,e))return!0
return A.O(a,b,c,A.hF(a,d),e)}if(q===6)return A.O(a,b,c,p,e)||A.O(a,b,c,d.x,e)
if(r)return!1
p=s!==11
if((!p||s===12)&&d===t.Z)return!0
o=s===10
if(o&&d===t.gT)return!0
if(q===12){if(b===t.g)return!0
if(s!==12)return!1
n=b.y
m=d.y
l=n.length
if(l!==m.length)return!1
c=c==null?n:n.concat(c)
e=e==null?m:m.concat(e)
for(k=0;k<l;++k){j=n[k]
i=m[k]
if(!A.O(a,j,c,i,e)||!A.O(a,i,e,j,c))return!1}return A.jq(a,b.x,c,d.x,e)}if(q===11){if(b===t.g)return!0
if(p)return!1
return A.jq(a,b,c,d,e)}if(s===8){if(q!==8)return!1
return A.m1(a,b,c,d,e)}if(o&&q===10)return A.m6(a,b,c,d,e)
return!1},
jq(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
if(!A.O(a3,a4.x,a5,a6.x,a7))return!1
s=a4.y
r=a6.y
q=s.a
p=r.a
o=q.length
n=p.length
if(o>n)return!1
m=n-o
l=s.b
k=r.b
j=l.length
i=k.length
if(o+j<n+i)return!1
for(h=0;h<o;++h){g=q[h]
if(!A.O(a3,p[h],a7,g,a5))return!1}for(h=0;h<m;++h){g=l[h]
if(!A.O(a3,p[o+h],a7,g,a5))return!1}for(h=0;h<i;++h){g=l[m+h]
if(!A.O(a3,k[h],a7,g,a5))return!1}f=s.c
e=r.c
d=f.length
c=e.length
for(b=0,a=0;a<c;a+=3){a0=e[a]
for(;!0;){if(b>=d)return!1
a1=f[b]
b+=3
if(a0<a1)return!1
a2=f[b-2]
if(a1<a0){if(a2)return!1
continue}g=e[a+1]
if(a2&&!g)return!1
g=f[b-1]
if(!A.O(a3,e[a+2],a7,g,a5))return!1
break}}for(;b<d;){if(f[b+1])return!1
b+=3}return!0},
m1(a,b,c,d,e){var s,r,q,p,o,n=b.x,m=d.x
for(;n!==m;){s=a.tR[n]
if(s==null)return!1
if(typeof s=="string"){n=s
continue}r=s[m]
if(r==null)return!1
q=r.length
p=q>0?new Array(q):v.typeUniverse.sEA
for(o=0;o<q;++o)p[o]=A.cF(a,b,r[o])
return A.jj(a,p,null,c,d.y,e)}return A.jj(a,b.y,null,c,d.y,e)},
jj(a,b,c,d,e,f){var s,r=b.length
for(s=0;s<r;++s)if(!A.O(a,b[s],d,e[s],f))return!1
return!0},
m6(a,b,c,d,e){var s,r=b.y,q=d.y,p=r.length
if(p!==q.length)return!1
if(b.x!==d.x)return!1
for(s=0;s<p;++s)if(!A.O(a,r[s],c,q[s],e))return!1
return!0},
bx(a){var s=a.w,r=!0
if(!(a===t.P||a===t.T))if(!A.b9(a))if(s!==6)r=s===7&&A.bx(a.x)
return r},
b9(a){var s=a.w
return s===2||s===3||s===4||s===5||a===t.X},
ji(a,b){var s,r,q=Object.keys(b),p=q.length
for(s=0;s<p;++s){r=q[s]
a[r]=b[r]}},
h1(a){return a>0?new Array(a):v.typeUniverse.sEA},
aj:function aj(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.d=_.c=null
_.w=0
_.as=_.Q=_.z=_.y=_.x=null},
dx:function dx(){this.c=this.b=this.a=null},
dB:function dB(a){this.a=a},
dw:function dw(){},
bt:function bt(a){this.a=a},
ld(){var s,r,q
if(self.scheduleImmediate!=null)return A.mn()
if(self.MutationObserver!=null&&self.document!=null){s={}
r=self.document.createElement("div")
q=self.document.createElement("span")
s.a=null
new self.MutationObserver(A.cM(new A.fr(s),1)).observe(r,{childList:true})
return new A.fq(s,r,q)}else if(self.setImmediate!=null)return A.mo()
return A.mp()},
le(a){self.scheduleImmediate(A.cM(new A.fs(t.M.a(a)),0))},
lf(a){self.setImmediate(A.cM(new A.ft(t.M.a(a)),0))},
lg(a){A.hJ(B.U,t.M.a(a))},
hJ(a,b){return A.lr(0,b)},
lr(a,b){var s=new A.fT()
s.cN(a,b)
return s},
ao(a){return new A.co(new A.u($.x,a.h("u<0>")),a.h("co<0>"))},
an(a,b){a.$2(0,null)
b.b=!0
return b.a},
aV(a,b){A.lJ(a,b)},
am(a,b){b.a9(a)},
al(a,b){b.bl(A.ar(a),A.aJ(a))},
lJ(a,b){var s,r,q=new A.h2(b),p=new A.h3(b)
if(a instanceof A.u)a.ca(q,p,t.z)
else{s=t.z
if(a instanceof A.u)a.aA(q,p,s)
else{r=new A.u($.x,t._)
r.a=8
r.c=a
r.ca(q,p,s)}}},
ap(a){var s=function(b,c){return function(d,e){while(true){try{b(d,e)
break}catch(r){e=r
d=c}}}}(a,1)
return $.x.ct(new A.h8(s),t.H,t.S,t.z)},
dP(a){var s
if(t.C.b(a)){s=a.gab()
if(s!=null)return s}return B.q},
kB(a,b){var s,r,q,p,o,n,m,l=null
try{l=a.$0()}catch(q){s=A.ar(q)
r=A.aJ(q)
p=new A.u($.x,b.h("u<0>"))
o=s
n=r
m=A.jp(o,n)
o=new A.a8(o,n==null?A.dP(o):n)
p.aG(o)
return p}return b.h("Q<0>").b(l)?l:A.hQ(l,b)},
kA(a,b){var s
if(!b.b(null))throw A.f(A.dM(null,"computation","The type parameter is not nullable"))
s=new A.u($.x,b.h("u<0>"))
A.lb(a,new A.ea(null,s,b))
return s},
jp(a,b){if($.x===B.i)return null
return null},
lZ(a,b){if($.x!==B.i)A.jp(a,b)
if(b==null)if(t.C.b(a)){b=a.gab()
if(b==null){A.iN(a,B.q)
b=B.q}}else b=B.q
else if(t.C.b(a))A.iN(a,b)
return new A.a8(a,b)},
hQ(a,b){var s=new A.u($.x,b.h("u<0>"))
b.a(a)
s.a=8
s.c=a
return s},
fH(a,b,c){var s,r,q,p,o={},n=o.a=a
for(s=t._;r=n.a,(r&4)!==0;n=a){a=s.a(n.c)
o.a=a}if(n===b){s=A.l8()
b.aG(new A.a8(new A.ag(!0,n,null,"Cannot complete a future with itself"),s))
return}q=b.a&1
s=n.a=r|q
if((s&24)===0){p=t.F.a(b.c)
b.a=b.a&1|4
b.c=n
n.c0(p)
return}if(!c)if(b.c==null)n=(s&16)===0||q!==0
else n=!1
else n=!0
if(n){p=b.an()
b.aH(o.a)
A.b4(b,p)
return}b.a^=2
A.dE(null,null,b.b,t.M.a(new A.fI(o,b)))},
b4(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d={},c=d.a=a
for(s=t.n,r=t.F;!0;){q={}
p=c.a
o=(p&16)===0
n=!o
if(b==null){if(n&&(p&1)===0){m=s.a(c.c)
A.i_(m.a,m.b)}return}q.a=b
l=b.a
for(c=b;l!=null;c=l,l=k){c.a=null
A.b4(d.a,c)
q.a=l
k=l.a}p=d.a
j=p.c
q.b=n
q.c=j
if(o){i=c.c
i=(i&1)!==0||(i&15)===8}else i=!0
if(i){h=c.b.b
if(n){p=p.b===h
p=!(p||p)}else p=!1
if(p){s.a(j)
A.i_(j.a,j.b)
return}g=$.x
if(g!==h)$.x=h
else g=null
c=c.c
if((c&15)===8)new A.fM(q,d,n).$0()
else if(o){if((c&1)!==0)new A.fL(q,j).$0()}else if((c&2)!==0)new A.fK(d,q).$0()
if(g!=null)$.x=g
c=q.c
if(c instanceof A.u){p=q.a.$ti
p=p.h("Q<2>").b(c)||!p.y[1].b(c)}else p=!1
if(p){f=q.a.b
if((c.a&24)!==0){e=r.a(f.c)
f.c=null
b=f.aN(e)
f.a=c.a&30|f.a&1
f.c=c.c
d.a=c
continue}else A.fH(c,f,!0)
return}}f=q.a.b
e=r.a(f.c)
f.c=null
b=f.aN(e)
c=q.b
p=q.c
if(!c){f.$ti.c.a(p)
f.a=8
f.c=p}else{s.a(p)
f.a=f.a&1|16
f.c=p}d.a=f
c=f}},
jv(a,b){var s
if(t.Q.b(a))return b.ct(a,t.z,t.K,t.l)
s=t.v
if(s.b(a))return s.a(a)
throw A.f(A.dM(a,"onError",u.c))},
mb(){var s,r
for(s=$.bu;s!=null;s=$.bu){$.cJ=null
r=s.b
$.bu=r
if(r==null)$.cI=null
s.a.$0()}},
mi(){$.hZ=!0
try{A.mb()}finally{$.cJ=null
$.hZ=!1
if($.bu!=null)$.ib().$1(A.jA())}},
jy(a){var s=new A.dt(a),r=$.cI
if(r==null){$.bu=$.cI=s
if(!$.hZ)$.ib().$1(A.jA())}else $.cI=r.b=s},
mf(a){var s,r,q,p=$.bu
if(p==null){A.jy(a)
$.cJ=$.cI
return}s=new A.dt(a)
r=$.cJ
if(r==null){s.b=p
$.bu=$.cJ=s}else{q=r.b
s.b=q
$.cJ=r.b=s
if(q==null)$.cI=s}},
mT(a,b){A.cL(a,"stream",t.K)
return new A.dz(b.h("dz<0>"))},
lb(a,b){var s=$.x
if(s===B.i)return A.hJ(a,t.M.a(b))
return A.hJ(a,t.M.a(s.cn(b)))},
i_(a,b){A.mf(new A.h7(a,b))},
jw(a,b,c,d,e){var s,r=$.x
if(r===c)return d.$0()
$.x=c
s=r
try{r=d.$0()
return r}finally{$.x=s}},
me(a,b,c,d,e,f,g){var s,r=$.x
if(r===c)return d.$1(e)
$.x=c
s=r
try{r=d.$1(e)
return r}finally{$.x=s}},
md(a,b,c,d,e,f,g,h,i){var s,r=$.x
if(r===c)return d.$2(e,f)
$.x=c
s=r
try{r=d.$2(e,f)
return r}finally{$.x=s}},
dE(a,b,c,d){t.M.a(d)
if(B.i!==c){d=c.cn(d)
d=d}A.jy(d)},
fr:function fr(a){this.a=a},
fq:function fq(a,b,c){this.a=a
this.b=b
this.c=c},
fs:function fs(a){this.a=a},
ft:function ft(a){this.a=a},
fT:function fT(){},
fU:function fU(a,b){this.a=a
this.b=b},
co:function co(a,b){this.a=a
this.b=!1
this.$ti=b},
h2:function h2(a){this.a=a},
h3:function h3(a){this.a=a},
h8:function h8(a){this.a=a},
a8:function a8(a,b){this.a=a
this.b=b},
ea:function ea(a,b,c){this.a=a
this.b=b
this.c=c},
br:function br(){},
aF:function aF(a,b){this.a=a
this.$ti=b},
cB:function cB(a,b){this.a=a
this.$ti=b},
aG:function aG(a,b,c,d,e){var _=this
_.a=null
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
u:function u(a,b){var _=this
_.a=0
_.b=a
_.c=null
_.$ti=b},
fE:function fE(a,b){this.a=a
this.b=b},
fJ:function fJ(a,b){this.a=a
this.b=b},
fI:function fI(a,b){this.a=a
this.b=b},
fG:function fG(a,b){this.a=a
this.b=b},
fF:function fF(a,b){this.a=a
this.b=b},
fM:function fM(a,b,c){this.a=a
this.b=b
this.c=c},
fN:function fN(a,b){this.a=a
this.b=b},
fO:function fO(a){this.a=a},
fL:function fL(a,b){this.a=a
this.b=b},
fK:function fK(a,b){this.a=a
this.b=b},
dt:function dt(a){this.a=a
this.b=null},
dz:function dz(a){this.$ti=a},
cG:function cG(){},
h7:function h7(a,b){this.a=a
this.b=b},
dy:function dy(){},
fS:function fS(a,b){this.a=a
this.b=b},
j6(a,b){var s=a[b]
return s===a?null:s},
hS(a,b,c){if(c==null)a[b]=a
else a[b]=c},
hR(){var s=Object.create(null)
A.hS(s,"<non-identifier-key>",s)
delete s["<non-identifier-key>"]
return s},
E(a,b,c){return b.h("@<0>").u(c).h("hC<1,2>").a(A.jC(a,new A.ay(b.h("@<0>").u(c).h("ay<1,2>"))))},
eK(a,b){return new A.ay(a.h("@<0>").u(b).h("ay<1,2>"))},
hE(a){var s,r
if(A.i5(a))return"{...}"
s=new A.bo("")
try{r={}
B.a.n($.ab,a)
s.a+="{"
r.a=!0
a.ar(0,new A.eL(r,s))
s.a+="}"}finally{if(0>=$.ab.length)return A.a($.ab,-1)
$.ab.pop()}r=s.a
return r.charCodeAt(0)==0?r:r},
cs:function cs(){},
bs:function bs(a){var _=this
_.a=0
_.e=_.d=_.c=_.b=null
_.$ti=a},
ct:function ct(a,b){this.a=a
this.$ti=b},
cu:function cu(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
w:function w(){},
aR:function aR(){},
eL:function eL(a,b){this.a=a
this.b=b},
lD(a,b,c){var s,r,q,p,o=c-b
if(o<=4096)s=$.k5()
else s=new Uint8Array(o)
for(r=0;r<o;++r){q=b+r
if(!(q<a.length))return A.a(a,q)
p=a[q]
if((p&255)!==p)p=255
s[r]=p}return s},
lC(a,b,c,d){var s=a?$.k4():$.k3()
if(s==null)return null
if(0===c&&d===b.length)return A.jh(s,b)
return A.jh(s,b.subarray(c,d))},
jh(a,b){var s,r
try{s=a.decode(b)
return s}catch(r){}return null},
lE(a){switch(a){case 65:return"Missing extension byte"
case 67:return"Unexpected extension byte"
case 69:return"Invalid UTF-8 byte"
case 71:return"Overlong encoding"
case 73:return"Out of unicode range"
case 75:return"Encoded surrogate"
case 77:return"Unfinished UTF-8 octet sequence"
default:return""}},
h_:function h_(){},
fZ:function fZ(){},
cN:function cN(){},
fW:function fW(){},
dO:function dO(){},
fV:function fV(){},
dN:function dN(a){this.a=a},
bH:function bH(){},
cV:function cV(){},
cZ:function cZ(){},
fl:function fl(){},
h0:function h0(a){this.b=0
this.c=a},
dr:function dr(a){this.a=a},
fY:function fY(a){this.a=a
this.b=16
this.c=0},
U(a,b){var s,r=b.length
while(!0){if(a>0){s=a-1
if(!(s<r))return A.a(b,s)
s=b[s]===0}else s=!1
if(!s)break;--a}return a},
hO(a,b,c,d){var s,r,q,p=new Uint16Array(d),o=c-b
for(s=a.length,r=0;r<o;++r){q=b+r
if(!(q>=0&&q<s))return A.a(a,q)
q=a[q]
if(!(r<d))return A.a(p,r)
p[r]=q}return p},
cp(a){var s
if(a===0)return $.V()
if(a===1)return $.aL()
if(a===2)return $.k2()
if(Math.abs(a)<4294967296)return A.du(B.b.aS(a))
s=A.lh(a)
return s},
du(a){var s,r,q,p,o=a<0
if(o){if(a===-9223372036854776e3){s=new Uint16Array(4)
s[3]=32768
r=A.U(4,s)
return new A.J(r!==0,s,r)}a=-a}if(a<65536){s=new Uint16Array(1)
s[0]=a
r=A.U(1,s)
return new A.J(r===0?!1:o,s,r)}if(a<=4294967295){s=new Uint16Array(2)
s[0]=a&65535
s[1]=B.b.a6(a,16)
r=A.U(2,s)
return new A.J(r===0?!1:o,s,r)}r=B.b.N(B.b.gap(a)-1,16)+1
s=new Uint16Array(r)
for(q=0;a!==0;q=p){p=q+1
if(!(q<r))return A.a(s,q)
s[q]=a&65535
a=B.b.N(a,65536)}r=A.U(r,s)
return new A.J(r===0?!1:o,s,r)},
lh(a){var s,r,q,p,o,n,m,l
if(isNaN(a)||a==1/0||a==-1/0)throw A.f(A.a7("Value must be finite: "+a,null))
s=a<0
if(s)a=-a
a=Math.floor(a)
if(a===0)return $.V()
r=$.k1()
for(q=r.$flags|0,p=0;p<8;++p){q&2&&A.y(r)
if(!(p<8))return A.a(r,p)
r[p]=0}q=J.ka(B.aG.gco(r))
q.$flags&2&&A.y(q,13)
q.setFloat64(0,a,!0)
o=(r[7]<<4>>>0)+(r[6]>>>4)-1075
n=new Uint16Array(4)
n[0]=(r[1]<<8>>>0)+r[0]
n[1]=(r[3]<<8>>>0)+r[2]
n[2]=(r[5]<<8>>>0)+r[4]
n[3]=r[6]&15|16
m=new A.J(!1,n,4)
if(o<0)l=m.aX(0,-o)
else l=o>0?m.a2(0,o):m
if(s)return l.a1(0)
return l},
hP(a,b,c,d){var s,r,q,p,o
if(b===0)return 0
if(c===0&&d===a)return b
for(s=b-1,r=a.length,q=d.$flags|0;s>=0;--s){p=s+c
if(!(s<r))return A.a(a,s)
o=a[s]
q&2&&A.y(d)
if(!(p>=0&&p<d.length))return A.a(d,p)
d[p]=o}for(s=c-1;s>=0;--s){q&2&&A.y(d)
if(!(s<d.length))return A.a(d,s)
d[s]=0}return b+c},
j3(a,b,c,d){var s,r,q,p,o,n,m,l=B.b.N(c,16),k=B.b.a0(c,16),j=16-k,i=B.b.a2(1,j)-1
for(s=b-1,r=a.length,q=d.$flags|0,p=0;s>=0;--s){if(!(s<r))return A.a(a,s)
o=a[s]
n=s+l+1
m=B.b.bf(o,j)
q&2&&A.y(d)
if(!(n>=0&&n<d.length))return A.a(d,n)
d[n]=(m|p)>>>0
p=B.b.a2(o&i,k)}q&2&&A.y(d)
if(!(l>=0&&l<d.length))return A.a(d,l)
d[l]=p},
iZ(a,b,c,d){var s,r,q,p=B.b.N(c,16)
if(B.b.a0(c,16)===0)return A.hP(a,b,p,d)
s=b+p+1
A.j3(a,b,c,d)
for(r=d.$flags|0,q=p;--q,q>=0;){r&2&&A.y(d)
if(!(q<d.length))return A.a(d,q)
d[q]=0}r=s-1
if(!(r>=0&&r<d.length))return A.a(d,r)
if(d[r]===0)s=r
return s},
lk(a,b,c,d){var s,r,q,p,o,n,m=B.b.N(c,16),l=B.b.a0(c,16),k=16-l,j=B.b.a2(1,l)-1,i=a.length
if(!(m>=0&&m<i))return A.a(a,m)
s=B.b.bf(a[m],l)
r=b-m-1
for(q=d.$flags|0,p=0;p<r;++p){o=p+m+1
if(!(o<i))return A.a(a,o)
n=a[o]
o=B.b.a2(n&j,k)
q&2&&A.y(d)
if(!(p<d.length))return A.a(d,p)
d[p]=(o|s)>>>0
s=B.b.bf(n,l)}q&2&&A.y(d)
if(!(r>=0&&r<d.length))return A.a(d,r)
d[r]=s},
fx(a,b,c,d){var s,r,q,p,o=b-d
if(o===0)for(s=b-1,r=a.length,q=c.length;s>=0;--s){if(!(s<r))return A.a(a,s)
p=a[s]
if(!(s<q))return A.a(c,s)
o=p-c[s]
if(o!==0)return o}return o},
li(a,b,c,d,e){var s,r,q,p,o,n
for(s=a.length,r=c.length,q=e.$flags|0,p=0,o=0;o<d;++o){if(!(o<s))return A.a(a,o)
n=a[o]
if(!(o<r))return A.a(c,o)
p+=n+c[o]
q&2&&A.y(e)
if(!(o<e.length))return A.a(e,o)
e[o]=p&65535
p=p>>>16}for(o=d;o<b;++o){if(!(o>=0&&o<s))return A.a(a,o)
p+=a[o]
q&2&&A.y(e)
if(!(o<e.length))return A.a(e,o)
e[o]=p&65535
p=p>>>16}q&2&&A.y(e)
if(!(b>=0&&b<e.length))return A.a(e,b)
e[b]=p},
dv(a,b,c,d,e){var s,r,q,p,o,n
for(s=a.length,r=c.length,q=e.$flags|0,p=0,o=0;o<d;++o){if(!(o<s))return A.a(a,o)
n=a[o]
if(!(o<r))return A.a(c,o)
p+=n-c[o]
q&2&&A.y(e)
if(!(o<e.length))return A.a(e,o)
e[o]=p&65535
p=0-(B.b.a6(p,16)&1)}for(o=d;o<b;++o){if(!(o>=0&&o<s))return A.a(a,o)
p+=a[o]
q&2&&A.y(e)
if(!(o<e.length))return A.a(e,o)
e[o]=p&65535
p=0-(B.b.a6(p,16)&1)}},
j4(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k
if(a===0)return
for(s=b.length,r=d.length,q=d.$flags|0,p=0;--f,f>=0;e=l,c=o){o=c+1
if(!(c<s))return A.a(b,c)
n=b[c]
if(!(e>=0&&e<r))return A.a(d,e)
m=a*n+d[e]+p
l=e+1
q&2&&A.y(d)
d[e]=m&65535
p=B.b.N(m,65536)}for(;p!==0;e=l){if(!(e>=0&&e<r))return A.a(d,e)
k=d[e]+p
l=e+1
q&2&&A.y(d)
d[e]=k&65535
p=B.b.N(k,65536)}},
lj(a,b,c){var s,r,q,p=b.length
if(!(c>=0&&c<p))return A.a(b,c)
s=b[c]
if(s===a)return 65535
r=c-1
if(!(r>=0&&r<p))return A.a(b,r)
q=B.b.cL((s<<16|b[r])>>>0,a)
if(q>65535)return 65535
return q},
kx(a,b){a=A.K(a,new Error())
if(a==null)a=A.j(a)
a.stack=b.j(0)
throw a},
ai(a,b,c,d){var s,r=c?J.iv(a,d):J.iu(a,d)
if(a!==0&&b!=null)for(s=0;s<r.length;++s)r[s]=b
return r},
bX(a,b,c){var s,r=A.b([],c.h("q<0>"))
for(s=J.aY(a);s.q();)B.a.n(r,c.a(s.gt()))
if(b)return r
r.$flags=1
return r},
ad(a,b){var s,r
if(Array.isArray(a))return A.b(a.slice(0),b.h("q<0>"))
s=A.b([],b.h("q<0>"))
for(r=J.aY(a);r.q();)B.a.n(s,r.gt())
return s},
kR(a,b,c){var s,r=J.iv(a,c)
for(s=0;s<a;++s)B.a.l(r,s,b.$1(s))
return r},
hD(a,b){var s=A.bX(a,!1,b)
s.$flags=3
return s},
iT(a,b,c){var s,r,q,p
A.dk(b,"start")
s=c-b
if(s<0)throw A.f(A.a5(c,b,null,"end",null))
if(s===0)return""
if(Array.isArray(a)){r=a
q=r.length
return A.iM(b>0||c<q?r.slice(b,c):r)}if(t.bm.b(a))return A.la(a,b,c)
a=J.kf(a,c)
if(b>0)a=J.ke(a,b)
p=A.ad(a,t.S)
return A.iM(p)},
la(a,b,c){var s=a.length
if(b>=s)return""
return A.l4(a,b,c==null||c>s?s:c)},
l6(a){return new A.d6(a,A.kL(a,!1,!0,!1,!1,""))},
iQ(a,b,c){var s=J.aY(b)
if(!s.q())return a
if(c.length===0){do a+=A.t(s.gt())
while(s.q())}else{a+=A.t(s.gt())
for(;s.q();)a=a+c+A.t(s.gt())}return a},
l8(){return A.aJ(new Error())},
kv(a){var s=Math.abs(a),r=a<0?"-":""
if(s>=1000)return""+a
if(s>=100)return r+"0"+s
if(s>=10)return r+"00"+s
return r+"000"+s},
ip(a){if(a>=100)return""+a
if(a>=10)return"0"+a
return"00"+a},
cX(a){if(a>=10)return""+a
return"0"+a},
e2(a){if(typeof a=="number"||A.h5(a)||a==null)return J.a6(a)
if(typeof a=="string")return JSON.stringify(a)
return A.l2(a)},
ky(a,b){A.cL(a,"error",t.K)
A.cL(b,"stackTrace",t.l)
A.kx(a,b)},
cP(a){return new A.cO(a)},
a7(a,b){return new A.ag(!1,null,b,a)},
dM(a,b,c){return new A.ag(!0,a,b,c)},
a5(a,b,c,d,e){return new A.bm(b,c,!0,a,d,"Invalid value")},
c7(a,b,c){if(0>a||a>c)throw A.f(A.a5(a,0,c,"start",null))
if(b!=null){if(a>b||b>c)throw A.f(A.a5(b,a,c,"end",null))
return b}return c},
dk(a,b){if(a<0)throw A.f(A.a5(a,0,null,b,null))
return a},
hw(a,b,c,d){return new A.d_(b,!0,a,d,"Index out of range")},
bp(a){return new A.ck(a)},
hK(a){return new A.dp(a)},
hG(a){return new A.bn(a)},
a1(a){return new A.cU(a)},
hv(a,b,c){return new A.e6(a,b,c)},
kC(a,b,c){var s,r
if(A.i5(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}s=A.b([],t.s)
B.a.n($.ab,a)
try{A.ma(a,s)}finally{if(0>=$.ab.length)return A.a($.ab,-1)
$.ab.pop()}r=A.iQ(b,t.R.a(s),", ")+c
return r.charCodeAt(0)==0?r:r},
is(a,b,c){var s,r
if(A.i5(a))return b+"..."+c
s=new A.bo(b)
B.a.n($.ab,a)
try{r=s
r.a=A.iQ(r.a,a,", ")}finally{if(0>=$.ab.length)return A.a($.ab,-1)
$.ab.pop()}s.a+=c
r=s.a
return r.charCodeAt(0)==0?r:r},
ma(a,b){var s,r,q,p,o,n,m,l=a.gD(a),k=0,j=0
while(!0){if(!(k<80||j<3))break
if(!l.q())return
s=A.t(l.gt())
B.a.n(b,s)
k+=s.length+2;++j}if(!l.q()){if(j<=5)return
if(0>=b.length)return A.a(b,-1)
r=b.pop()
if(0>=b.length)return A.a(b,-1)
q=b.pop()}else{p=l.gt();++j
if(!l.q()){if(j<=4){B.a.n(b,A.t(p))
return}r=A.t(p)
if(0>=b.length)return A.a(b,-1)
q=b.pop()
k+=r.length+2}else{o=l.gt();++j
for(;l.q();p=o,o=n){n=l.gt();++j
if(j>100){while(!0){if(!(k>75&&j>3))break
if(0>=b.length)return A.a(b,-1)
k-=b.pop().length+2;--j}B.a.n(b,"...")
return}}q=A.t(p)
r=A.t(o)
k+=r.length+q.length+4}}if(j>b.length+2){k+=5
m="..."}else m=null
while(!0){if(!(k>80&&b.length>3))break
if(0>=b.length)return A.a(b,-1)
k-=b.pop().length+2
if(m==null){k+=5
m="..."}}if(m!=null)B.a.n(b,m)
B.a.n(b,q)
B.a.n(b,r)},
kU(a,b,c,d){var s
if(B.p===c){s=B.b.gB(a)
b=J.aw(b)
return A.hI(A.aT(A.aT($.hp(),s),b))}if(B.p===d){s=B.b.gB(a)
b=J.aw(b)
c=J.aw(c)
return A.hI(A.aT(A.aT(A.aT($.hp(),s),b),c))}s=B.b.gB(a)
b=J.aw(b)
c=J.aw(c)
d=J.aw(d)
d=A.hI(A.aT(A.aT(A.aT(A.aT($.hp(),s),b),c),d))
return d},
J:function J(a,b,c){this.a=a
this.b=b
this.c=c},
fy:function fy(){},
fz:function fz(){},
cW:function cW(a,b,c){this.a=a
this.b=b
this.c=c},
cY:function cY(){},
fC:function fC(){},
D:function D(){},
cO:function cO(a){this.a=a},
aD:function aD(){},
ag:function ag(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
bm:function bm(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.a=c
_.b=d
_.c=e
_.d=f},
d_:function d_(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
ck:function ck(a){this.a=a},
dp:function dp(a){this.a=a},
bn:function bn(a){this.a=a},
cU:function cU(a){this.a=a},
dg:function dg(){},
cc:function cc(){},
fD:function fD(a){this.a=a},
e6:function e6(a,b,c){this.a=a
this.b=b
this.c=c},
d0:function d0(){},
l:function l(){},
X:function X(a,b,c){this.a=a
this.b=b
this.$ti=c},
P:function P(){},
h:function h(){},
dA:function dA(){},
bo:function bo(a){this.a=a},
kQ(a,b){return a},
kJ(a){return a},
it(a,b){var s,r,q,p,o
if(b.length===0)return!1
s=b.split(".")
r=v.G
for(q=s.length,p=0;p<q;++p,r=o){o=r[s[p]]
A.F(o)
if(o==null)return!1}return a instanceof t.g.a(r)},
kz(a){return A.d(new v.G.Promise(A.r(new A.e9(a))))},
e9:function e9(a){this.a=a},
e7:function e7(a){this.a=a},
e8:function e8(a){this.a=a},
p(a){var s
if(typeof a=="function")throw A.f(A.a7("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(){return b(c)}}(A.lK,a)
s[$.bz()]=a
return s},
c(a){var s
if(typeof a=="function")throw A.f(A.a7("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d){return b(c,d,arguments.length)}}(A.lL,a)
s[$.bz()]=a
return s},
r(a){var s
if(typeof a=="function")throw A.f(A.a7("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d,e){return b(c,d,e,arguments.length)}}(A.lM,a)
s[$.bz()]=a
return s},
hW(a){var s
if(typeof a=="function")throw A.f(A.a7("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d,e,f){return b(c,d,e,f,arguments.length)}}(A.lN,a)
s[$.bz()]=a
return s},
hX(a){var s
if(typeof a=="function")throw A.f(A.a7("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d,e,f,g){return b(c,d,e,f,g,arguments.length)}}(A.lO,a)
s[$.bz()]=a
return s},
lK(a){return t.Z.a(a).$0()},
lL(a,b,c){t.Z.a(a)
if(A.af(c)>=1)return a.$1(b)
return a.$0()},
lM(a,b,c,d){t.Z.a(a)
A.af(d)
if(d>=2)return a.$2(b,c)
if(d===1)return a.$1(b)
return a.$0()},
lN(a,b,c,d,e){t.Z.a(a)
A.af(e)
if(e>=3)return a.$3(b,c,d)
if(e===2)return a.$2(b,c)
if(e===1)return a.$1(b)
return a.$0()},
lO(a,b,c,d,e,f){t.Z.a(a)
A.af(f)
if(f>=4)return a.$4(b,c,d,e)
if(f===3)return a.$3(b,c,d)
if(f===2)return a.$2(b,c)
if(f===1)return a.$1(b)
return a.$0()},
ju(a){return a==null||A.h5(a)||typeof a=="number"||typeof a=="string"||t.w.b(a)||t.gc.b(a)||t.go.b(a)||t.d.b(a)||t.h7.b(a)||t.k.b(a)||t.bv.b(a)||t.W.b(a)||t.q.b(a)||t.E.b(a)||t.Y.b(a)},
hi(a){if(A.ju(a))return a
return new A.hj(new A.bs(t.J)).$1(a)},
h9(a,b,c){var s,r
if(b==null)return c.a(new a())
if(b instanceof Array)switch(b.length){case 0:return c.a(new a())
case 1:return c.a(new a(b[0]))
case 2:return c.a(new a(b[0],b[1]))
case 3:return c.a(new a(b[0],b[1],b[2]))
case 4:return c.a(new a(b[0],b[1],b[2],b[3]))}s=[null]
B.a.a8(s,b)
r=a.bind.apply(a,s)
String(r)
return c.a(new r())},
jH(a,b){var s=new A.u($.x,b.h("u<0>")),r=new A.aF(s,b.h("aF<0>"))
a.then(A.cM(new A.hm(r,b),1),A.cM(new A.hn(r),1))
return s},
jt(a){return a==null||typeof a==="boolean"||typeof a==="number"||typeof a==="string"||a instanceof Int8Array||a instanceof Uint8Array||a instanceof Uint8ClampedArray||a instanceof Int16Array||a instanceof Uint16Array||a instanceof Int32Array||a instanceof Uint32Array||a instanceof Float32Array||a instanceof Float64Array||a instanceof ArrayBuffer||a instanceof DataView},
i2(a){if(A.jt(a))return a
return new A.ha(new A.bs(t.J)).$1(a)},
hj:function hj(a){this.a=a},
hm:function hm(a,b){this.a=a
this.b=b},
hn:function hn(a){this.a=a},
ha:function ha(a){this.a=a},
eN:function eN(a){this.a=a},
fQ:function fQ(a){this.a=a},
e0:function e0(){},
ih(a,b){var s,r,q,p,o,n,m,l,k=B.a2.k(0,b)
k.toString
s=A.kj(a)
for(r=k.length,q="";s.aP(0,$.V())>0;s=o){p=A.cp(58)
if(p.c===0)A.a0(B.y)
o=s.bE(p)
p=A.cp(58)
if(p.c===0)A.a0(B.y)
n=s.c1(p)
if(n.a)n=p.a?n.aC(0,p):n.aU(0,p)
p=n.aS(0)
if(!(p>=0&&p<r))return A.a(k,p)
q=k[p]+q}for(p=a.length,m=0,l=0;l<p;++l)if(a[l]===0)++m
else break
if(0>=r)return A.a(k,0)
return B.f.W(k[0],p-(p-m))+q},
ig(a,b){var s,r,q,p,o,n,m,l,k=B.a2.k(0,b)
k.toString
s=$.V()
for(r=a.length,q=r-1,p=0;p<r;++p){o=q-p
if(!(o>=0))return A.a(a,o)
n=B.f.h2(k,a[o])
if(n===-1)throw A.f(B.aE)
s=s.aU(0,A.cp(n).W(0,A.cp(58).hc(p)))}m=A.kk(s,A.ki(s))
for(q=k.length,l=0,p=0;p<r;++p){o=a[p]
if(0>=q)return A.a(k,0)
if(o===k[0])++l
else break}k=t.S
r=A.ad(A.ai(l,0,!1,k),t.z)
B.a.a8(r,m)
return A.bX(r,!0,k)},
bD:function bD(a){this.b=a},
dR:function dR(a,b){this.a=a
this.b=b},
iX(a){var s,r,q,p,o,n,m,l,k,j,i,h=A.by(a,"=",""),g=A.b([],t.t)
for(s=h.length,r=0;q=r+4,q<=s;r=q){p=$.ho()
if(!(r<s))return A.a(h,r)
o=J.aI(p)
n=o.k(p,h.charCodeAt(r))
m=r+1
if(!(m<s))return A.a(h,m)
m=o.k(p,h.charCodeAt(m))
l=r+2
if(!(l<s))return A.a(h,l)
l=o.k(p,h.charCodeAt(l))
k=r+3
if(!(k<s))return A.a(h,k)
j=n<<18|m<<12|l<<6|o.k(p,h.charCodeAt(k))
B.a.n(g,j>>>16&255)
B.a.n(g,j>>>8&255)
B.a.n(g,j&255)}i=s-r
if(i===2){p=$.ho()
if(!(r<s))return A.a(h,r)
o=J.aI(p)
n=o.k(p,h.charCodeAt(r))
m=r+1
if(!(m<s))return A.a(h,m)
B.a.n(g,(n<<18|o.k(p,h.charCodeAt(m))<<12)>>>16&255)}else if(i===3){p=$.ho()
if(!(r<s))return A.a(h,r)
o=J.aI(p)
n=o.k(p,h.charCodeAt(r))
m=r+1
if(!(m<s))return A.a(h,m)
m=o.k(p,h.charCodeAt(m))
l=r+2
if(!(l<s))return A.a(h,l)
j=n<<18|m<<12|o.k(p,h.charCodeAt(l))<<6
B.a.n(g,j>>>16&255)
B.a.n(g,j>>>8&255)}return g},
kh(a,b,c){var s,r,q
a=a
r=B.b.a0(J.as(a),4)
if(r!==0)throw A.f(A.kg("Invalid length, must be multiple of four"))
r=a
r=A.by(r,"-","+")
a=A.by(r,"_","/")
s=new A.fu(A.b([],t.t))
try{J.dG(s,a)
r=s
q=r.b
if(q.length!==0)B.a.a8(r.a,A.iX(B.f.ha(q,4,"=")))
r=A.kP(r.a,t.S)
return r}finally{r=s
B.a.cp(r.a)
r.b=""}},
fu:function fu(a){this.a=a
this.b=""},
fv:function fv(){},
iY(a){var s,r,q,p,o,n,m,l,k,j=u.n
for(s=a.length,r=0,q="";p=r+3,p<=s;r=p){if(!(r<s))return A.a(a,r)
o=a[r]
n=r+1
if(!(n<s))return A.a(a,n)
n=a[n]
m=r+2
if(!(m<s))return A.a(a,m)
l=o<<16|n<<8|a[m]
q=q+j[l>>>18&63]+j[l>>>12&63]+j[l>>>6&63]+j[l&63]}k=s-r
if(k===1){if(!(r<s))return A.a(a,r)
l=a[r]<<16
s=q+j[l>>>18&63]+j[l>>>12&63]+"=="}else if(k===2){if(!(r<s))return A.a(a,r)
o=a[r]
n=r+1
if(!(n<s))return A.a(a,n)
l=o<<16|a[n]<<8
q=q+j[l>>>18&63]+j[l>>>12&63]+j[l>>>6&63]+"="
s=q}else s=q
return s.charCodeAt(0)==0?s:s},
ie(a,b,c){var s,r,q,p,o=new A.fw(new A.bo(""),A.b([],t.t))
try{A.hu(a)
J.dG(o,a)
r=o
q=r.b
if(q.length!==0){p=r.a
q=A.iY(q)
p.a+=q}r=r.a.a
s=r.charCodeAt(0)==0?r:r
if(c){r=s
r=A.by(r,"+","-")
s=A.by(r,"/","_")}r=s
return r}finally{r=o
r.a.a=""
B.a.cp(r.b)}},
fw:function fw(a,b){this.a=a
this.b=b},
kg(a){return new A.dQ(a,null)},
dQ:function dQ(a,b){this.a=a
this.b=b},
dZ:function dZ(a,b){this.a=a
this.b=b},
eY(a){var s,r=t.S,q=A.ai(8,0,!1,r),p=A.ai(64,0,!1,r),o=A.ai(128,0,!1,r),n=new A.eX(q,p,o,A.hD(B.ax,r))
n.cu()
n.aT(a)
s=A.ai(32,0,!1,r)
n.fZ(s)
A.jL(o)
A.jL(p)
n.cu()
return s},
eX:function eX(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.e=_.d=0
_.f=!1
_.r=d},
hr(a,b){return new A.bc(a,b)},
dS:function dS(){},
dT:function dT(){},
dU:function dU(){},
bc:function bc(a,b){this.a=a
this.b=b},
eM:function eM(a,b){this.a=a
this.b=b},
fP:function fP(){},
d8:function d8(a){this.b=a},
eZ:function eZ(a){this.a=a},
f_:function f_(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
e1:function e1(){},
l9(a){if(B.f.bv(a.toLowerCase(),"0x"))return B.f.aY(a,2)
return a},
iS(a){var s,r,q,p,o,n,m,l=!0,k=B.x,j=B.S,i=!0
try{switch(j){case B.S:r=B.ao.aq(a)
return r
case B.w:case B.a5:r=A.kh(a,l,i)
return r
case B.a6:r=A.ig(a,k)
return r
case B.a7:q=A.ig(a,k)
p=B.a.X(q,0,q.length-4)
o=B.a.bw(q,q.length-4)
n=B.a.X(A.eY(A.eY(p)),0,4)
if(!A.kn(o,n))A.a0(new A.dR("Invalid checksum (expected "+A.ht(n)+", got "+A.ht(o)+")",null))
return p
case B.a8:r=A.im(a)
return r
case B.a4:r=B.af.aq(a)
return r}}catch(m){s=A.ar(m)
throw A.f(A.hr("Failed to convert string as "+j.b+" bytes.",A.E(["error",J.a6(s)],t.N,t.z)))}},
iR(a,b){var s,r,q,p,o,n,m=!1,l=!1,k=B.x
a=a
r=a
A.hu(r)
a=r
try{switch(b){case B.S:r=t.L.a(a)
q=A.ak(m)
r=new A.fY((q===!0?B.aU:B.aT).a).dh(r,0,null,!0)
return r
case B.w:r=A.ie(a,l,!1)
return r
case B.a5:r=A.ie(a,l,!0)
return r
case B.a6:r=A.ih(a,k)
return r
case B.a7:r=a
A.hu(r)
q=t.S
p=A.hD(r,q)
o=B.a.X(A.eY(A.eY(p)),0,4)
r=A.ad(p,t.z)
B.a.a8(r,o)
r=A.ih(A.bX(r,!0,q),k)
return r
case B.a8:r=A.ht(a)
return r
case B.a4:r=B.ae.fW(a,m)
return r}}catch(n){s=A.ar(n)
r=A.hr("Failed to convert bytes as "+b.b,A.E(["error",J.a6(s)],t.N,t.z))
throw A.f(r)}},
aC:function aC(a){this.b=a},
lc(){var s,r,q,p=A.kR(16,new A.ff($.jN()),t.S)
B.a.l(p,6,p[6]&15|64)
B.a.l(p,8,p[8]&63|128)
s=A.R(p)
r=s.h("Y<1,m>")
q=A.ad(new A.Y(p,s.h("m(1)").a(new A.fg()),r),r.h("M.E"))
return B.a.U(B.a.X(q,0,4),"")+"-"+B.a.U(B.a.X(q,4,6),"")+"-"+B.a.U(B.a.X(q,6,8),"")+"-"+B.a.U(B.a.X(q,8,10),"")+"-"+B.a.U(B.a.bw(q,10),"")},
ff:function ff(a){this.a=a},
fg:function fg(){},
ds:function ds(a){this.b=a},
cl:function cl(a,b){this.a=a
this.d=b},
dD:function dD(){},
kF(a){var s,r,q,p,o,n
try{s=null
q=a.rawTransaction
r=q==null?null:J.a6(q)
if(r!=null){q=$.jP()
if(q.b.test(r)){q=A.im(r)
s=A.j(v.G.Uint8Array.from(A.hi(q)))}else s=A.j(a.rawTransaction.bcsToBytes())
q=s
p=a.feePayerAddress
p=p==null?null:J.a6(p)
o=t.r.a(a.secondarySignerAddresses)
if(o==null)o=null
else{o=t.ew.b(o)?o:new A.ax(o,A.R(o).h("ax<1,h>"))
o=J.dH(o,new A.ej(),t.N)
o=A.ad(o,o.$ti.h("M.E"))}o={rawTransaction:q,feePayerAddress:p,secondarySignerAddresses:o}
return o}}catch(n){}throw A.f(new A.cl("Invalid method parameters: Invalid Aptos transaction. The transaction must be a valid Aptos transaction and include a method like bcsToBytes.",B.aW))},
kD(a){return new A.ei(a)},
kE(a){return new A.eh(a)},
hx(a){a.bcsToBytes=A.p(new A.ee(a))
a.serialize=A.c(new A.ef(a))
a.bcsToHex=A.p(new A.eg(a))
a.toStringWithoutPrefix=A.p(A.kE(a))
a.toString=A.p(A.kD(a))},
hy(a){return B.a.aa(B.aC,new A.ek(a),new A.el())},
hz(a,b){var s={}
s.status="Approved"
s.args=a
return s},
ej:function ej(){},
ei:function ei(a){this.a=a},
eh:function eh(a){this.a=a},
ee:function ee(a){this.a=a},
ef:function ef(a){this.a=a},
eg:function eg(a){this.a=a},
aN:function aN(a,b){this.c=a
this.b=b},
ek:function ek(a){this.a=a},
el:function el(){},
aS:function aS(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
dh:function dh(a,b){this.a=a
this.b=b},
kw(a){var s=v.G,r=A.d(new s.CustomEvent("eip6963:announceProvider",{bubbles:!0,cancelable:!1,detail:A.j(s.Object.freeze({info:$.jM(),provider:a}))}))
A.d(s.window).addEventListener("eip6963:requestProvider",A.c(new A.e_(r)))
A.d(s.window).dispatchEvent(r)},
e_:function e_(a){this.a=a},
Z(a,b){return A.d(new v.G.Promise(A.r(new A.fp(a))))},
a4(a,b,c){var s=A.b([],t.s)
return A.h9(v.G.Proxy,[a,new A.eW(new A.aS(b,a,s,c.h("aS<0>"))).$0()],t.m)},
iO(a){var s=A.R(a),r=s.h("Y<1,m>")
s=A.ad(new A.Y(a,s.h("m(1)").a(new A.eR()),r),r.h("M.E"))
return s},
fp:function fp(a){this.a=a},
fm:function fm(a){this.a=a},
fn:function fn(a){this.a=a},
fo:function fo(a,b){this.a=a
this.b=b},
eS:function eS(a){this.a=a},
eT:function eT(a){this.a=a},
eU:function eU(a){this.a=a},
eV:function eV(a){this.a=a},
eW:function eW(a){this.a=a},
eR:function eR(){},
i6(a){return A.mG(a)},
mG(a){var s=0,r=A.ao(t.H),q,p,o
var $async$i6=A.ap(function(b,c){if(b===1)return A.al(c,r)
while(true)switch(s){case 0:p={}
o=new A.d4(new A.eZ(A.eK(t.fs,t.x)),new A.aF(new A.u($.x,t.D),t.h))
o.e0()
q=v.G
q.onChain={}
p.a=!1
A.d(q.window).addEventListener("WALLET_ACTIVATION",A.c(new A.hk(p,o)))
return A.am(null,r)}})
return A.an($async$i6,r)},
hk:function hk(a,b){this.a=a
this.b=b},
kM(a){return B.a.aa(B.ay,new A.eC(a),new A.eD())},
kI(a){return B.a.aa(B.aB,new A.et(a),new A.eu())},
kH(a){return B.a.aa(B.a1,new A.er(a),new A.es())},
bQ(a){return A.l5(B.a1,new A.eq(a),t.A)},
iA(a){return B.a.aa(B.aD,new A.eH(a),new A.eI())},
iw(a){return B.a.aa(B.az,new A.eo(a),new A.ep())},
iJ(a,b){var s=a==null?null:a.b
return{data:b,requestId:"event",client:s}},
bj(a){return{type:"event",event:a.b,data:null,providerType:"walletStandard"}},
aO:function aO(a){this.b=a},
eC:function eC(a){this.a=a},
eD:function eD(){},
W:function W(a){this.b=a},
et:function et(a){this.a=a},
eu:function eu(){},
ac:function ac(a){this.b=a},
er:function er(a){this.a=a},
es:function es(){},
eq:function eq(a){this.a=a},
aP:function aP(a){this.b=a},
eH:function eH(a){this.a=a},
eI:function eI(){},
L:function L(a,b){this.c=a
this.b=b},
eo:function eo(a){this.a=a},
ep:function ep(){},
c5:function c5(a){this.b=a},
hT(a){var s
if(a!=null&&typeof a==="string"){s=A.k(a).length
if(s===64||s===66)throw A.f({message:"Please use static method `TronWeb.TRX.sign` for signing with own private key"})}},
em:function em(){},
en:function en(a){this.a=a},
d4:function d4(a,b){var _=this
_.b=_.a=$
_.c=a
_.d=b
_.e=null
_.f=$},
d5:function d5(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
ey:function ey(a,b){this.a=a
this.b=b},
ev:function ev(a,b){this.a=a
this.b=b},
ew:function ew(a){this.a=a},
ex:function ex(a){this.a=a},
N:function N(){},
eP:function eP(a,b){this.a=a
this.b=b},
bA:function bA(a,b){this.c=$
this.a=a
this.b=b},
dI:function dI(a){this.a=a},
bB:function bB(a,b,c){this.c=a
this.a=b
this.b=c},
dK:function dK(){},
dL:function dL(){},
dJ:function dJ(){},
bF:function bF(a,b){this.a=a
this.b=b},
bE:function bE(a,b){this.a=a
this.b=b},
bJ:function bJ(a,b){var _=this
_.d=_.c=null
_.a=a
_.b=b},
dX:function dX(a,b){this.a=a
this.b=b},
dY:function dY(a,b,c){this.a=a
this.b=b
this.c=c},
dV:function dV(a,b){this.a=a
this.b=b},
dW:function dW(a,b,c){this.a=a
this.b=b
this.c=c},
bM:function bM(a,b,c){var _=this
_.c=null
_.d=a
_.a=b
_.b=c},
e3:function e3(a){this.a=a},
bZ:function bZ(a,b){this.a=a
this.b=b},
c9:function c9(a,b){this.a=a
this.b=b},
cb:function cb(a,b){this.a=a
this.b=b},
cd:function cd(a,b){this.a=a
this.b=b},
cf:function cf(a,b,c){var _=this
_.c=a
_.e=_.d=null
_.a=b
_.b=c},
f3:function f3(a){this.a=a},
f4:function f4(a){this.a=a},
f5:function f5(a){this.a=a},
f6:function f6(a){this.a=a},
f7:function f7(a){this.a=a},
f1:function f1(){},
f2:function f2(a){this.a=a},
cg:function cg(a,b){this.a=a
this.b=b},
ch:function ch(a,b){this.a=a
this.b=b},
ci:function ci(a,b,c,d){var _=this
_.d=_.c=null
_.e=a
_.f=b
_.a=c
_.b=d},
f8:function f8(a){this.a=a},
f9:function f9(a){this.a=a},
fa:function fa(a){this.a=a},
fb:function fb(a){this.a=a},
fc:function fc(a){this.a=a},
iB(a){var s={}
s.connect=a
s.version="1.0.0"
return s},
a2(a){var s={}
s.on=a
s.version="1.0.0"
return s},
ah(a){var s={}
s.disconnect=a
s.version="1.0.0"
return s},
iE(a){var s={}
s.signPersonalMessage=a
s.version="1.0.0"
return s},
iF(a){var s={}
s.signTransaction=a
s.version="1.0.0"
return s},
iC(a){var s={}
s.getAccountAddresses=a
s.version="1.0.0"
return s},
iD(a){var s={}
s.sendTransaction=a
s.version="1.0.0"
return s},
eE(a){var s,r,q=t.c.a(a.types)
q=t.a.b(q)?q:new A.ax(q,A.R(q).h("ax<1,m>"))
q=J.dH(q,new A.eF(),t.N)
s=q.$ti
r=s.h("Y<M.E,W>")
q=A.ad(new A.Y(q,s.h("W(M.E)").a(new A.eG()),r),r.h("M.E"))
return q},
iz(a){var s=t.c.a(a.accounts)
s=t.cl.b(s)?s:new A.ax(s,A.R(s).h("ax<1,i>"))
s=J.dH(s,new A.eB(),t.N)
s=A.ad(s,s.$ti.h("M.E"))
return s},
eF:function eF(){},
eG:function eG(){},
eB:function eB(){},
kP(a,b){return A.bX(a,!0,b)},
i9(a,b,c){B.a.l(b,c,a>>>24&255)
B.a.l(b,c+1,a>>>16&255)
B.a.l(b,c+2,a>>>8&255)
B.a.l(b,c+3,a&255)},
jL(a){var s,r
for(s=a.length,r=0;r<s;++r)B.a.l(a,r,0)},
ht(a){var s=B.X.fY(a,!0)
return s},
im(a){var s,r,q,p=!1
try{s=A.l9(a)
if(J.as(s)===0){r=A.b([],t.t)
return r}if(p&&(J.as(s)&1)===1)s="0"+A.t(s)
r=B.X.fV(s)
return r}catch(q){throw A.f(B.a9)}},
ko(a,b){var s,r,q
for(s=J.aW(a),r=0;r<a.length;++r){q=s.I(a,r)
if(q<0||q>255)throw A.f(A.hr(b+" at index "+r+" "+q,null))}},
hu(a){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(q<0||q>255)throw A.f(A.a7("Invalid bytes at index "+r+": "+q,null))}},
kn(a,b){var s,r,q=a.length,p=b.length
if(q!==p)return!1
if(a===b)return!0
for(s=0;s<q;++s){r=a[s]
if(!(s<p))return A.a(b,s)
if(r!==b[s])return!1}return!0},
ku(a,b,c){var s,r,q
if(a===b)return!0
for(s=0;s<3;++s){r=a[s]
q=b[s]
if(r==null?q!=null:r!==q)return!1}return!0},
iq(a){var s,r,q,p
for(s=J.aY(a),r=t.R,q=12;s.q();){p=s.gt()
q=r.b(p)?(q^A.iq(p))>>>0:(q^J.aw(p))>>>0}return q},
ki(a){var s=a.gap(0)
return B.b.N((a.a?s+1:s)+7,8)},
kk(a,b){var s,r,q,p=a.aP(0,$.V())
if(p===0)return A.ai(b,0,!1,t.S)
s=A.cp(255)
p=t.S
r=A.ai(b,0,!1,p)
for(q=0;q<b;++q){B.a.l(r,b-q-1,a.cz(0,s).aS(0))
a=a.aX(0,8)}return A.bX(r,!0,p)},
kj(a){var s,r,q,p=$.V()
for(s=0;r=a.length,s<r;++s){q=r-s-1
if(!(q>=0))return A.a(a,q)
p=p.aU(0,A.cp(a[q]).a2(0,8*s))}r=p.aP(0,$.V())
if(r===0)return p
return p},
l5(a,b,c){var s,r,q=null
try{s=B.a.h_(a,b)
return s}catch(r){if(A.ar(r) instanceof A.bn){s=q
s=s==null?null:s.$0()
return s}else throw r}},
ix(a){var s={}
s.connect=a
s.version="1.0.0"
return s},
iy(a){var s={}
s.showBalanceChanges=A.ak(a.showBalanceChanges)
s.showEffects=A.ak(a.showEffects)
s.showEvents=A.ak(a.showEvents)
s.showInput=A.ak(a.showInput)
s.showObjectChanges=A.ak(a.showObjectChanges)
s.showRawEffects=A.ak(a.showRawEffects)
s.showRawInput=A.ak(a.showRawInput)
return s},
ez(a){return A.kK(a)},
kK(a){var s=0,r=A.ao(t.K),q,p=2,o=[],n,m,l,k,j,i,h
var $async$ez=A.ap(function(b,c){if(b===1){o.push(c)
s=p}while(true)switch(s){case 0:p=4
s=a.transaction!=null?7:8
break
case 7:n=null
k=a.transaction
s=k!=null&&typeof k==="string"?9:11
break
case 9:n=A.k(a.transaction)
s=10
break
case 11:s=12
return A.aV(A.jH(A.d(a.transaction.toJSON()),t.N),$async$ez)
case 12:m=c
n=A.iR(A.iS(m),B.w)
case 10:j={}
j.chain=A.A(a.chain)
k=a.account
if(k==null)k=a.address
j.account=k
j.transaction=n
j.requestType=A.A(a.requestType)
k=a.options
k=k==null?null:A.iy(k)
j.options=k
q=j
s=1
break
case 8:if(a.transactionBlock!=null){l=null
k=a.transactionBlock
if(k!=null&&typeof k==="string")l=A.k(a.transactionBlock)
else{k=a.transactionBlock
if(k==null)k=null
else k=typeof A.j(k.blockData)==="string"
if(k===!0)l=A.k(A.j(a.transactionBlock.blockData))
else l=A.iR(A.iS(A.k(A.d(v.G.JSON).stringify(A.j(a.transactionBlock.blockData)))),B.w)}j={}
j.chain=A.A(a.chain)
k=a.account
if(k==null)k=a.address
j.account=k
j.transaction=l
j.requestType=A.A(a.requestType)
k=a.options
k=k==null?null:A.iy(k)
j.options=k
q=j
s=1
break}p=2
s=6
break
case 4:p=3
h=o.pop()
s=6
break
case 3:s=2
break
case 6:throw A.f($.jQ())
case 1:return A.am(q,r)
case 2:return A.al(o.at(-1),r)}})
return A.an($async$ez,r)},
iU(a){var s={}
s.signTransaction=a
s.version="1.0.0"
return s},
B(a){var s,r
if(a==null)return A.b([],t.f)
s=[]
r=A.it(a,"Array")
if(r){t.c.a(a)
s=a}else s.push(a)
return A.bX(s,!0,t.X)},
a3(a){if(a==null)return null
if(typeof a==="string")return a
return null},
aa(a){if(a==null)return null
return a}},B={}
var w=[A,J,B]
var $={}
A.hA.prototype={}
J.d1.prototype={
a_(a,b){return a===b},
gB(a){return A.c6(a)},
j(a){return"Instance of '"+A.dj(a)+"'"},
gG(a){return A.b7(A.hY(this))}}
J.bP.prototype={
j(a){return String(a)},
aB(a,b){return b||a},
gB(a){return a?519018:218159},
gG(a){return A.b7(t.y)},
$iz:1,
$iC:1}
J.bS.prototype={
a_(a,b){return null==b},
j(a){return"null"},
gB(a){return 0},
$iz:1}
J.I.prototype={$ii:1}
J.aQ.prototype={
gB(a){return 0},
j(a){return String(a)}}
J.di.prototype={}
J.cj.prototype={}
J.H.prototype={
j(a){var s=a[$.bz()]
if(s==null)return this.cK(a)
return"JavaScript function for "+J.a6(s)},
$ib_:1}
J.bf.prototype={
gB(a){return 0},
j(a){return String(a)}}
J.bg.prototype={
gB(a){return 0},
j(a){return String(a)}}
J.q.prototype={
n(a,b){A.R(a).c.a(b)
a.$flags&1&&A.y(a,29)
a.push(b)},
ae(a,b){var s
a.$flags&1&&A.y(a,"remove",1)
for(s=0;s<a.length;++s)if(J.bb(a[s],b)){a.splice(s,1)
return!0}return!1},
a8(a,b){var s
A.R(a).h("l<1>").a(b)
a.$flags&1&&A.y(a,"addAll",2)
if(Array.isArray(b)){this.cR(a,b)
return}for(s=J.aY(b);s.q();)a.push(s.gt())},
cR(a,b){var s,r
t.b.a(b)
s=b.length
if(s===0)return
if(a===b)throw A.f(A.a1(a))
for(r=0;r<s;++r)a.push(b[r])},
cp(a){a.$flags&1&&A.y(a,"clear","clear")
a.length=0},
ad(a,b,c){var s=A.R(a)
return new A.Y(a,s.u(c).h("1(2)").a(b),s.h("@<1>").u(c).h("Y<1,2>"))},
U(a,b){var s,r=A.ai(a.length,"",!1,t.N)
for(s=0;s<a.length;++s)this.l(r,s,A.t(a[s]))
return r.join(b)},
bn(a){return this.U(a,"")},
cv(a,b){return A.hH(a,0,A.cL(b,"count",t.S),A.R(a).c)},
aa(a,b,c){var s,r,q,p=A.R(a)
p.h("C(1)").a(b)
p.h("1()?").a(c)
s=a.length
for(r=0;r<s;++r){q=a[r]
if(b.$1(q))return q
if(a.length!==s)throw A.f(A.a1(a))}if(c!=null)return c.$0()
throw A.f(A.ir())},
h_(a,b){return this.aa(a,b,null)},
I(a,b){if(!(b>=0&&b<a.length))return A.a(a,b)
return a[b]},
X(a,b,c){if(b<0||b>a.length)throw A.f(A.a5(b,0,a.length,"start",null))
if(c==null)c=a.length
else if(c<b||c>a.length)throw A.f(A.a5(c,b,a.length,"end",null))
if(b===c)return A.b([],A.R(a))
return A.b(a.slice(b,c),A.R(a))},
bw(a,b){return this.X(a,b,null)},
fR(a,b){var s,r
A.R(a).h("C(1)").a(b)
s=a.length
for(r=0;r<s;++r){if(b.$1(a[r]))return!0
if(a.length!==s)throw A.f(A.a1(a))}return!1},
T(a,b){var s
for(s=0;s<a.length;++s)if(J.bb(a[s],b))return!0
return!1},
j(a){return A.is(a,"[","]")},
gD(a){return new J.bC(a,a.length,A.R(a).h("bC<1>"))},
gB(a){return A.c6(a)},
gm(a){return a.length},
sm(a,b){a.$flags&1&&A.y(a,"set length","change the length of")
if(b<0)throw A.f(A.a5(b,0,null,"newLength",null))
if(b>a.length)A.R(a).c.a(null)
a.length=b},
k(a,b){if(!(b>=0&&b<a.length))throw A.f(A.hb(a,b))
return a[b]},
l(a,b,c){A.R(a).c.a(c)
a.$flags&2&&A.y(a)
if(!(b>=0&&b<a.length))throw A.f(A.hb(a,b))
a[b]=c},
$in:1,
$il:1,
$io:1}
J.d2.prototype={
hg(a){var s,r,q
if(!Array.isArray(a))return null
s=a.$flags|0
if((s&4)!==0)r="const, "
else if((s&2)!==0)r="unmodifiable, "
else r=(s&1)!==0?"fixed, ":""
q="Instance of '"+A.dj(a)+"'"
if(r==="")return q
return q+" ("+r+"length: "+a.length+")"}}
J.eA.prototype={}
J.bC.prototype={
gt(){var s=this.d
return s==null?this.$ti.c.a(s):s},
q(){var s,r=this,q=r.a,p=q.length
if(r.b!==p){q=A.av(q)
throw A.f(q)}s=r.c
if(s>=p){r.d=null
return!1}r.d=q[s]
r.c=s+1
return!0},
$iT:1}
J.bT.prototype={
aS(a){var s
if(a>=-2147483648&&a<=2147483647)return a|0
if(isFinite(a)){s=a<0?Math.ceil(a):Math.floor(a)
return s+0}throw A.f(A.bp(""+a+".toInt()"))},
hf(a,b){var s,r,q,p,o
if(b<2||b>36)throw A.f(A.a5(b,2,36,"radix",null))
s=a.toString(b)
r=s.length
q=r-1
if(!(q>=0))return A.a(s,q)
if(s.charCodeAt(q)!==41)return s
p=/^([\da-z]+)(?:\.([\da-z]+))?\(e\+(\d+)\)$/.exec(s)
if(p==null)A.a0(A.bp("Unexpected toString result: "+s))
r=p.length
if(1>=r)return A.a(p,1)
s=p[1]
if(3>=r)return A.a(p,3)
o=+p[3]
r=p[2]
if(r!=null){s+=r
o-=r.length}return s+B.f.W("0",o)},
j(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gB(a){var s,r,q,p,o=a|0
if(a===o)return o&536870911
s=Math.abs(a)
r=Math.log(s)/0.6931471805599453|0
q=Math.pow(2,r)
p=s<1?s/q:q/s
return((p*9007199254740992|0)+(p*3542243181176521|0))*599197+r*1259&536870911},
a0(a,b){var s=a%b
if(s===0)return 0
if(s>0)return s
return s+b},
cL(a,b){if((a|0)===a)if(b>=1)return a/b|0
return this.c9(a,b)},
N(a,b){return(a|0)===a?a/b|0:this.c9(a,b)},
c9(a,b){var s=a/b
if(s>=-2147483648&&s<=2147483647)return s|0
if(s>0){if(s!==1/0)return Math.floor(s)}else if(s>-1/0)return Math.ceil(s)
throw A.f(A.bp("Result of truncating division is "+A.t(s)+": "+A.t(a)+" ~/ "+b))},
a2(a,b){if(b<0)throw A.f(A.cK(b))
return b>31?0:a<<b>>>0},
a6(a,b){var s
if(a>0)s=this.c3(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
bf(a,b){if(0>b)throw A.f(A.cK(b))
return this.c3(a,b)},
c3(a,b){return b>31?0:a>>>b},
gG(a){return A.b7(t.o)},
$iv:1,
$iba:1}
J.bR.prototype={
gap(a){var s,r=a<0?-a-1:a,q=r
for(s=32;q>=4294967296;){q=this.N(q,4294967296)
s+=32}return s-Math.clz32(q)},
gG(a){return A.b7(t.S)},
$iz:1,
$ie:1}
J.d3.prototype={
gG(a){return A.b7(t.i)},
$iz:1}
J.be.prototype={
bv(a,b){var s=b.length
if(s>a.length)return!1
return b===a.substring(0,s)},
aD(a,b,c){return a.substring(b,A.c7(b,c,a.length))},
aY(a,b){return this.aD(a,b,null)},
W(a,b){var s,r
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw A.f(B.an)
for(s=a,r="";!0;){if((b&1)===1)r=s+r
b=b>>>1
if(b===0)break
s+=s}return r},
cs(a,b,c){var s=b-a.length
if(s<=0)return a
return this.W(c,s)+a},
ha(a,b,c){var s=b-a.length
if(s<=0)return a
return a+this.W(c,s)},
h2(a,b){var s=a.indexOf(b,0)
return s},
j(a){return a},
gB(a){var s,r,q
for(s=a.length,r=0,q=0;q<s;++q){r=r+a.charCodeAt(q)&536870911
r=r+((r&524287)<<10)&536870911
r^=r>>6}r=r+((r&67108863)<<3)&536870911
r^=r>>11
return r+((r&16383)<<15)&536870911},
gG(a){return A.b7(t.N)},
gm(a){return a.length},
$iz:1,
$ieQ:1,
$im:1}
A.bq.prototype={
gD(a){return new A.bG(J.aY(this.gao()),A.S(this).h("bG<1,2>"))},
gm(a){return J.as(this.gao())},
I(a,b){return A.S(this).y[1].a(J.hq(this.gao(),b))},
T(a,b){return J.id(this.gao(),b)},
j(a){return J.a6(this.gao())}}
A.bG.prototype={
q(){return this.a.q()},
gt(){return this.$ti.y[1].a(this.a.gt())},
$iT:1}
A.cr.prototype={
k(a,b){return this.$ti.y[1].a(J.k8(this.a,b))},
l(a,b,c){var s=this.$ti
J.k9(this.a,b,s.c.a(s.y[1].a(c)))},
sm(a,b){J.kd(this.a,b)},
n(a,b){var s=this.$ti
J.dG(this.a,s.c.a(s.y[1].a(b)))},
$in:1,
$io:1}
A.ax.prototype={
gao(){return this.a}}
A.bh.prototype={
j(a){return"LateInitializationError: "+this.a}}
A.f0.prototype={}
A.n.prototype={}
A.M.prototype={
gD(a){var s=this
return new A.b1(s,s.gm(s),A.S(s).h("b1<M.E>"))},
T(a,b){var s,r=this,q=r.gm(r)
for(s=0;s<q;++s){if(J.bb(r.I(0,s),b))return!0
if(q!==r.gm(r))throw A.f(A.a1(r))}return!1},
U(a,b){var s,r,q,p=this,o=p.gm(p)
if(b.length!==0){if(o===0)return""
s=A.t(p.I(0,0))
if(o!==p.gm(p))throw A.f(A.a1(p))
for(r=s,q=1;q<o;++q){r=r+b+A.t(p.I(0,q))
if(o!==p.gm(p))throw A.f(A.a1(p))}return r.charCodeAt(0)==0?r:r}else{for(q=0,r="";q<o;++q){r+=A.t(p.I(0,q))
if(o!==p.gm(p))throw A.f(A.a1(p))}return r.charCodeAt(0)==0?r:r}},
bn(a){return this.U(0,"")},
ad(a,b,c){var s=A.S(this)
return new A.Y(this,s.u(c).h("1(M.E)").a(b),s.h("@<M.E>").u(c).h("Y<1,2>"))}}
A.ce.prototype={
gdr(){var s=J.as(this.a),r=this.c
if(r==null||r>s)return s
return r},
gf4(){var s=J.as(this.a),r=this.b
if(r>s)return s
return r},
gm(a){var s,r=J.as(this.a),q=this.b
if(q>=r)return 0
s=this.c
if(s==null||s>=r)return r-q
return s-q},
I(a,b){var s=this,r=s.gf4()+b
if(b<0||r>=s.gdr())throw A.f(A.hw(b,s.gm(0),s,"index"))
return J.hq(s.a,r)},
cJ(a,b){var s,r,q=this
A.dk(b,"count")
s=q.b+b
r=q.c
if(r!=null&&s>=r)return new A.aZ(q.$ti.h("aZ<1>"))
return A.hH(q.a,s,r,q.$ti.c)}}
A.b1.prototype={
gt(){var s=this.d
return s==null?this.$ti.c.a(s):s},
q(){var s,r=this,q=r.a,p=J.aI(q),o=p.gm(q)
if(r.b!==o)throw A.f(A.a1(q))
s=r.c
if(s>=o){r.d=null
return!1}r.d=p.I(q,s);++r.c
return!0},
$iT:1}
A.aB.prototype={
gD(a){var s=this.a
return new A.bY(s.gD(s),this.b,A.S(this).h("bY<1,2>"))},
gm(a){var s=this.a
return s.gm(s)},
I(a,b){var s=this.a
return this.b.$1(s.I(s,b))}}
A.bK.prototype={$in:1}
A.bY.prototype={
q(){var s=this,r=s.b
if(r.q()){s.a=s.c.$1(r.gt())
return!0}s.a=null
return!1},
gt(){var s=this.a
return s==null?this.$ti.y[1].a(s):s},
$iT:1}
A.Y.prototype={
gm(a){return J.as(this.a)},
I(a,b){return this.b.$1(J.hq(this.a,b))}}
A.cm.prototype={
gD(a){return new A.cn(J.aY(this.a),this.b,this.$ti.h("cn<1>"))},
ad(a,b,c){var s=this.$ti
return new A.aB(this,s.u(c).h("1(2)").a(b),s.h("@<1>").u(c).h("aB<1,2>"))}}
A.cn.prototype={
q(){var s,r
for(s=this.a,r=this.b;s.q();)if(r.$1(s.gt()))return!0
return!1},
gt(){return this.a.gt()},
$iT:1}
A.aZ.prototype={
gD(a){return B.ag},
gm(a){return 0},
I(a,b){throw A.f(A.a5(b,0,0,"index",null))},
T(a,b){return!1},
ad(a,b,c){this.$ti.u(c).h("1(2)").a(b)
return new A.aZ(c.h("aZ<0>"))}}
A.bL.prototype={
q(){return!1},
gt(){throw A.f(A.ir())},
$iT:1}
A.G.prototype={
sm(a,b){throw A.f(A.bp("Cannot change the length of a fixed-length list"))},
n(a,b){A.aK(a).h("G.E").a(b)
throw A.f(A.bp("Cannot add to a fixed-length list"))}}
A.c8.prototype={
gm(a){return J.as(this.a)},
I(a,b){var s=this.a,r=J.aI(s)
return r.I(s,r.gm(s)-1-b)}}
A.cH.prototype={}
A.bI.prototype={
j(a){return A.hE(this)},
$iaA:1}
A.bO.prototype={
aK(){var s=this,r=s.$map
if(r==null){r=new A.bU(s.$ti.h("bU<1,2>"))
A.jC(s.a,r)
s.$map=r}return r},
k(a,b){return this.aK().k(0,b)},
ar(a,b){this.$ti.h("~(1,2)").a(b)
this.aK().ar(0,b)},
gaw(){var s=this.aK()
return new A.b0(s,A.S(s).h("b0<1>"))},
gm(a){return this.aK().a}}
A.ca.prototype={}
A.fd.prototype={
V(a){var s,r,q=this,p=new RegExp(q.a).exec(a)
if(p==null)return null
s=Object.create(null)
r=q.b
if(r!==-1)s.arguments=p[r+1]
r=q.c
if(r!==-1)s.argumentsExpr=p[r+1]
r=q.d
if(r!==-1)s.expr=p[r+1]
r=q.e
if(r!==-1)s.method=p[r+1]
r=q.f
if(r!==-1)s.receiver=p[r+1]
return s}}
A.c4.prototype={
j(a){return"Null check operator used on a null value"}}
A.d7.prototype={
j(a){var s,r=this,q="NoSuchMethodError: method not found: '",p=r.b
if(p==null)return"NoSuchMethodError: "+r.a
s=r.c
if(s==null)return q+p+"' ("+r.a+")"
return q+p+"' on '"+s+"' ("+r.a+")"}}
A.dq.prototype={
j(a){var s=this.a
return s.length===0?"Error":"Error: "+s}}
A.eO.prototype={
j(a){return"Throw of null ('"+(this.a===null?"null":"undefined")+"' from JavaScript)"}}
A.bN.prototype={}
A.cA.prototype={
j(a){var s,r=this.b
if(r!=null)return r
r=this.a
s=r!==null&&typeof r==="object"?r.stack:null
return this.b=s==null?"":s},
$iat:1}
A.aM.prototype={
j(a){var s=this.constructor,r=s==null?null:s.name
return"Closure '"+A.jK(r==null?"unknown":r)+"'"},
$ib_:1,
ghn(){return this},
$C:"$1",
$R:1,
$D:null}
A.cR.prototype={$C:"$0",$R:0}
A.cS.prototype={$C:"$2",$R:2}
A.dn.prototype={}
A.dm.prototype={
j(a){var s=this.$static_name
if(s==null)return"Closure of unknown static method"
return"Closure '"+A.jK(s)+"'"}}
A.bd.prototype={
a_(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof A.bd))return!1
return this.$_target===b.$_target&&this.a===b.a},
gB(a){return(A.dF(this.a)^A.c6(this.$_target))>>>0},
j(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.dj(this.a)+"'")}}
A.dl.prototype={
j(a){return"RuntimeError: "+this.a}}
A.ay.prototype={
gm(a){return this.a},
gaw(){return new A.b0(this,A.S(this).h("b0<1>"))},
a3(a){var s=this.h4(a)
return s},
h4(a){var s=this.d
if(s==null)return!1
return this.av(s[this.au(a)],a)>=0},
k(a,b){var s,r,q,p,o=null
if(typeof b=="string"){s=this.b
if(s==null)return o
r=s[b]
q=r==null?o:r.b
return q}else if(typeof b=="number"&&(b&0x3fffffff)===b){p=this.c
if(p==null)return o
r=p[b]
q=r==null?o:r.b
return q}else return this.h5(b)},
h5(a){var s,r,q=this.d
if(q==null)return null
s=q[this.au(a)]
r=this.av(s,a)
if(r<0)return null
return s[r].b},
l(a,b,c){var s,r,q,p,o,n,m=this,l=A.S(m)
l.c.a(b)
l.y[1].a(c)
if(typeof b=="string"){s=m.b
m.bx(s==null?m.b=m.bb():s,b,c)}else if(typeof b=="number"&&(b&0x3fffffff)===b){r=m.c
m.bx(r==null?m.c=m.bb():r,b,c)}else{q=m.d
if(q==null)q=m.d=m.bb()
p=m.au(b)
o=q[p]
if(o==null)q[p]=[m.bc(b,c)]
else{n=m.av(o,b)
if(n>=0)o[n].b=c
else o.push(m.bc(b,c))}}},
ae(a,b){var s
if(typeof b=="string")return this.en(this.b,b)
else{s=this.h6(b)
return s}},
h6(a){var s,r,q,p,o=this,n=o.d
if(n==null)return null
s=o.au(a)
r=n[s]
q=o.av(r,a)
if(q<0)return null
p=r.splice(q,1)[0]
o.cb(p)
if(r.length===0)delete n[s]
return p.b},
ar(a,b){var s,r,q=this
A.S(q).h("~(1,2)").a(b)
s=q.e
r=q.r
for(;s!=null;){b.$2(s.a,s.b)
if(r!==q.r)throw A.f(A.a1(q))
s=s.c}},
bx(a,b,c){var s,r=A.S(this)
r.c.a(b)
r.y[1].a(c)
s=a[b]
if(s==null)a[b]=this.bc(b,c)
else s.b=c},
en(a,b){var s
if(a==null)return null
s=a[b]
if(s==null)return null
this.cb(s)
delete a[b]
return s.b},
bY(){this.r=this.r+1&1073741823},
bc(a,b){var s=this,r=A.S(s),q=new A.eJ(r.c.a(a),r.y[1].a(b))
if(s.e==null)s.e=s.f=q
else{r=s.f
r.toString
q.d=r
s.f=r.c=q}++s.a
s.bY()
return q},
cb(a){var s=this,r=a.d,q=a.c
if(r==null)s.e=q
else r.c=q
if(q==null)s.f=r
else q.d=r;--s.a
s.bY()},
au(a){return J.aw(a)&1073741823},
av(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.bb(a[r].a,b))return r
return-1},
j(a){return A.hE(this)},
bb(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s},
$ihC:1}
A.eJ.prototype={}
A.b0.prototype={
gm(a){return this.a.a},
gD(a){var s=this.a
return new A.bW(s,s.r,s.e,this.$ti.h("bW<1>"))},
T(a,b){return this.a.a3(b)}}
A.bW.prototype={
gt(){return this.d},
q(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.f(A.a1(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.a
r.c=s.c
return!0}},
$iT:1}
A.az.prototype={
gm(a){return this.a.a},
gD(a){var s=this.a
return new A.bV(s,s.r,s.e,this.$ti.h("bV<1,2>"))}}
A.bV.prototype={
gt(){var s=this.d
s.toString
return s},
q(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.f(A.a1(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=new A.X(s.a,s.b,r.$ti.h("X<1,2>"))
r.c=s.c
return!0}},
$iT:1}
A.bU.prototype={
au(a){return A.mr(a)&1073741823},
av(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.bb(a[r].a,b))return r
return-1}}
A.he.prototype={
$1(a){return this.a(a)},
$S:36}
A.hf.prototype={
$2(a,b){return this.a(a,b)},
$S:67}
A.hg.prototype={
$1(a){return this.a(A.k(a))},
$S:58}
A.cz.prototype={}
A.d6.prototype={
j(a){return"RegExp/"+this.a+"/"+this.b.flags},
$ieQ:1}
A.fA.prototype={
S(){var s=this.b
if(s===this)throw A.f(A.iG(this.a))
return s}}
A.b2.prototype={
gG(a){return B.aH},
cm(a,b,c){var s
A.h4(a,b,c)
s=new Uint8Array(a,b,c)
return s},
fS(a,b,c){var s
A.h4(a,b,c)
s=new DataView(a,b)
return s},
cl(a){return this.fS(a,0,null)},
$iz:1,
$ib2:1,
$icQ:1}
A.c2.prototype={
gco(a){if(((a.$flags|0)&2)!==0)return new A.dC(a.buffer)
else return a.buffer}}
A.dC.prototype={
cm(a,b,c){var s=A.kT(this.a,b,c)
s.$flags=3
return s},
cl(a){var s=A.kS(this.a,0,null)
s.$flags=3
return s},
$icQ:1}
A.c_.prototype={
gG(a){return B.aI},
$iz:1,
$ihs:1}
A.bi.prototype={
gm(a){return a.length},
$ia9:1}
A.c0.prototype={
k(a,b){A.aH(b,a,a.length)
return a[b]},
l(a,b,c){A.jl(c)
a.$flags&2&&A.y(a)
A.aH(b,a,a.length)
a[b]=c},
$in:1,
$il:1,
$io:1}
A.c1.prototype={
l(a,b,c){A.af(c)
a.$flags&2&&A.y(a)
A.aH(b,a,a.length)
a[b]=c},
$in:1,
$il:1,
$io:1}
A.d9.prototype={
gG(a){return B.aJ},
$iz:1,
$ie4:1}
A.da.prototype={
gG(a){return B.aK},
$iz:1,
$ie5:1}
A.db.prototype={
gG(a){return B.aL},
k(a,b){A.aH(b,a,a.length)
return a[b]},
$iz:1,
$ieb:1}
A.dc.prototype={
gG(a){return B.aM},
k(a,b){A.aH(b,a,a.length)
return a[b]},
$iz:1,
$iec:1}
A.dd.prototype={
gG(a){return B.aN},
k(a,b){A.aH(b,a,a.length)
return a[b]},
$iz:1,
$ied:1}
A.de.prototype={
gG(a){return B.aP},
k(a,b){A.aH(b,a,a.length)
return a[b]},
$iz:1,
$ifh:1}
A.df.prototype={
gG(a){return B.aQ},
k(a,b){A.aH(b,a,a.length)
return a[b]},
$iz:1,
$ifi:1}
A.c3.prototype={
gG(a){return B.aR},
gm(a){return a.length},
k(a,b){A.aH(b,a,a.length)
return a[b]},
$iz:1,
$ifj:1}
A.b3.prototype={
gG(a){return B.aS},
gm(a){return a.length},
k(a,b){A.aH(b,a,a.length)
return a[b]},
$iz:1,
$ib3:1,
$ifk:1}
A.cv.prototype={}
A.cw.prototype={}
A.cx.prototype={}
A.cy.prototype={}
A.aj.prototype={
h(a){return A.cF(v.typeUniverse,this,a)},
u(a){return A.jg(v.typeUniverse,this,a)}}
A.dx.prototype={}
A.dB.prototype={
j(a){return A.a_(this.a,null)}}
A.dw.prototype={
j(a){return this.a}}
A.bt.prototype={$iaD:1}
A.fr.prototype={
$1(a){var s=this.a,r=s.a
s.a=null
r.$0()},
$S:33}
A.fq.prototype={
$1(a){var s,r
this.a.a=t.M.a(a)
s=this.b
r=this.c
s.firstChild?s.removeChild(r):s.appendChild(r)},
$S:56}
A.fs.prototype={
$0(){this.a.$0()},
$S:32}
A.ft.prototype={
$0(){this.a.$0()},
$S:32}
A.fT.prototype={
cN(a,b){if(self.setTimeout!=null)self.setTimeout(A.cM(new A.fU(this,b),0),a)
else throw A.f(A.bp("`setTimeout()` not found."))}}
A.fU.prototype={
$0(){this.b.$0()},
$S:3}
A.co.prototype={
a9(a){var s,r=this,q=r.$ti
q.h("1/?").a(a)
if(a==null)a=q.c.a(a)
if(!r.b)r.a.b1(a)
else{s=r.a
if(q.h("Q<1>").b(a))s.bz(a)
else s.bB(a)}},
bl(a,b){var s=this.a
if(this.b)s.a5(new A.a8(a,b))
else s.aG(new A.a8(a,b))},
$icT:1}
A.h2.prototype={
$1(a){return this.a.$2(0,a)},
$S:13}
A.h3.prototype={
$2(a,b){this.a.$2(1,new A.bN(a,t.l.a(b)))},
$S:53}
A.h8.prototype={
$2(a,b){this.a(A.af(a),b)},
$S:52}
A.a8.prototype={
j(a){return A.t(this.a)},
$iD:1,
gab(){return this.b}}
A.ea.prototype={
$0(){this.c.a(null)
this.b.bA(null)},
$S:3}
A.br.prototype={
bl(a,b){if((this.a.a&30)!==0)throw A.f(A.hG("Future already completed"))
this.a5(A.lZ(a,b))},
cq(a){return this.bl(a,null)},
$icT:1}
A.aF.prototype={
a9(a){var s,r=this.$ti
r.h("1/?").a(a)
s=this.a
if((s.a&30)!==0)throw A.f(A.hG("Future already completed"))
s.b1(r.h("1/").a(a))},
aQ(){return this.a9(null)},
a5(a){this.a.aG(a)}}
A.cB.prototype={
a9(a){var s,r=this.$ti
r.h("1/?").a(a)
s=this.a
if((s.a&30)!==0)throw A.f(A.hG("Future already completed"))
s.bA(r.h("1/").a(a))},
aQ(){return this.a9(null)},
a5(a){this.a.a5(a)}}
A.aG.prototype={
h7(a){if((this.c&15)!==6)return!0
return this.b.b.bs(t.al.a(this.d),a.a,t.y,t.K)},
h0(a){var s,r=this,q=r.e,p=null,o=t.z,n=t.K,m=a.a,l=r.b.b
if(t.Q.b(q))p=l.hd(q,m,a.b,o,n,t.l)
else p=l.bs(t.v.a(q),m,o,n)
try{o=r.$ti.h("2/").a(p)
return o}catch(s){if(t.eK.b(A.ar(s))){if((r.c&1)!==0)throw A.f(A.a7("The error handler of Future.then must return a value of the returned future's type","onError"))
throw A.f(A.a7("The error handler of Future.catchError must return a value of the future's type","onError"))}else throw s}}}
A.u.prototype={
aA(a,b,c){var s,r,q,p=this.$ti
p.u(c).h("1/(2)").a(a)
s=$.x
if(s===B.i){if(b!=null&&!t.Q.b(b)&&!t.v.b(b))throw A.f(A.dM(b,"onError",u.c))}else{c.h("@<0/>").u(p.c).h("1(2)").a(a)
if(b!=null)b=A.jv(b,s)}r=new A.u(s,c.h("u<0>"))
q=b==null?1:3
this.aF(new A.aG(r,q,a,b,p.h("@<1>").u(c).h("aG<1,2>")))
return r},
af(a,b){return this.aA(a,null,b)},
ca(a,b,c){var s,r=this.$ti
r.u(c).h("1/(2)").a(a)
s=new A.u($.x,c.h("u<0>"))
this.aF(new A.aG(s,19,a,b,r.h("@<1>").u(c).h("aG<1,2>")))
return s},
ev(a){this.a=this.a&1|16
this.c=a},
aH(a){this.a=a.a&30|this.a&1
this.c=a.c},
aF(a){var s,r=this,q=r.a
if(q<=3){a.a=t.F.a(r.c)
r.c=a}else{if((q&4)!==0){s=t._.a(r.c)
if((s.a&24)===0){s.aF(a)
return}r.aH(s)}A.dE(null,null,r.b,t.M.a(new A.fE(r,a)))}},
c0(a){var s,r,q,p,o,n,m=this,l={}
l.a=a
if(a==null)return
s=m.a
if(s<=3){r=t.F.a(m.c)
m.c=a
if(r!=null){q=a.a
for(p=a;q!=null;p=q,q=o)o=q.a
p.a=r}}else{if((s&4)!==0){n=t._.a(m.c)
if((n.a&24)===0){n.c0(a)
return}m.aH(n)}l.a=m.aN(a)
A.dE(null,null,m.b,t.M.a(new A.fJ(l,m)))}},
an(){var s=t.F.a(this.c)
this.c=null
return this.aN(s)},
aN(a){var s,r,q
for(s=a,r=null;s!=null;r=s,s=q){q=s.a
s.a=r}return r},
bA(a){var s,r=this,q=r.$ti
q.h("1/").a(a)
if(q.h("Q<1>").b(a))A.fH(a,r,!0)
else{s=r.an()
q.c.a(a)
r.a=8
r.c=a
A.b4(r,s)}},
bB(a){var s,r=this
r.$ti.c.a(a)
s=r.an()
r.a=8
r.c=a
A.b4(r,s)},
da(a){var s,r,q=this
if((a.a&16)!==0){s=q.b===a.b
s=!(s||s)}else s=!1
if(s)return
r=q.an()
q.aH(a)
A.b4(q,r)},
a5(a){var s=this.an()
this.ev(a)
A.b4(this,s)},
b1(a){var s=this.$ti
s.h("1/").a(a)
if(s.h("Q<1>").b(a)){this.bz(a)
return}this.cW(a)},
cW(a){var s=this
s.$ti.c.a(a)
s.a^=2
A.dE(null,null,s.b,t.M.a(new A.fG(s,a)))},
bz(a){A.fH(this.$ti.h("Q<1>").a(a),this,!1)
return},
aG(a){this.a^=2
A.dE(null,null,this.b,t.M.a(new A.fF(this,a)))},
$iQ:1}
A.fE.prototype={
$0(){A.b4(this.a,this.b)},
$S:3}
A.fJ.prototype={
$0(){A.b4(this.b,this.a.a)},
$S:3}
A.fI.prototype={
$0(){A.fH(this.a.a,this.b,!0)},
$S:3}
A.fG.prototype={
$0(){this.a.bB(this.b)},
$S:3}
A.fF.prototype={
$0(){this.a.a5(this.b)},
$S:3}
A.fM.prototype={
$0(){var s,r,q,p,o,n,m,l,k=this,j=null
try{q=k.a.a
j=q.b.b.br(t.fO.a(q.d),t.z)}catch(p){s=A.ar(p)
r=A.aJ(p)
if(k.c&&t.n.a(k.b.a.c).a===s){q=k.a
q.c=t.n.a(k.b.a.c)}else{q=s
o=r
if(o==null)o=A.dP(q)
n=k.a
n.c=new A.a8(q,o)
q=n}q.b=!0
return}if(j instanceof A.u&&(j.a&24)!==0){if((j.a&16)!==0){q=k.a
q.c=t.n.a(j.c)
q.b=!0}return}if(j instanceof A.u){m=k.b.a
l=new A.u(m.b,m.$ti)
j.aA(new A.fN(l,m),new A.fO(l),t.H)
q=k.a
q.c=l
q.b=!1}},
$S:3}
A.fN.prototype={
$1(a){this.a.da(this.b)},
$S:33}
A.fO.prototype={
$2(a,b){A.j(a)
t.l.a(b)
this.a.a5(new A.a8(a,b))},
$S:31}
A.fL.prototype={
$0(){var s,r,q,p,o,n,m,l
try{q=this.a
p=q.a
o=p.$ti
n=o.c
m=n.a(this.b)
q.c=p.b.b.bs(o.h("2/(1)").a(p.d),m,o.h("2/"),n)}catch(l){s=A.ar(l)
r=A.aJ(l)
q=s
p=r
if(p==null)p=A.dP(q)
o=this.a
o.c=new A.a8(q,p)
o.b=!0}},
$S:3}
A.fK.prototype={
$0(){var s,r,q,p,o,n,m,l=this
try{s=t.n.a(l.a.a.c)
p=l.b
if(p.a.h7(s)&&p.a.e!=null){p.c=p.a.h0(s)
p.b=!1}}catch(o){r=A.ar(o)
q=A.aJ(o)
p=t.n.a(l.a.a.c)
if(p.a===r){n=l.b
n.c=p
p=n}else{p=r
n=q
if(n==null)n=A.dP(p)
m=l.b
m.c=new A.a8(p,n)
p=m}p.b=!0}},
$S:3}
A.dt.prototype={}
A.dz.prototype={}
A.cG.prototype={$iiW:1}
A.h7.prototype={
$0(){A.ky(this.a,this.b)},
$S:3}
A.dy.prototype={
he(a){var s,r,q
t.M.a(a)
try{if(B.i===$.x){a.$0()
return}A.jw(null,null,this,a,t.H)}catch(q){s=A.ar(q)
r=A.aJ(q)
A.i_(A.j(s),t.l.a(r))}},
cn(a){return new A.fS(this,t.M.a(a))},
br(a,b){b.h("0()").a(a)
if($.x===B.i)return a.$0()
return A.jw(null,null,this,a,b)},
bs(a,b,c,d){c.h("@<0>").u(d).h("1(2)").a(a)
d.a(b)
if($.x===B.i)return a.$1(b)
return A.me(null,null,this,a,b,c,d)},
hd(a,b,c,d,e,f){d.h("@<0>").u(e).u(f).h("1(2,3)").a(a)
e.a(b)
f.a(c)
if($.x===B.i)return a.$2(b,c)
return A.md(null,null,this,a,b,c,d,e,f)},
ct(a,b,c,d){return b.h("@<0>").u(c).u(d).h("1(2,3)").a(a)}}
A.fS.prototype={
$0(){return this.a.he(this.b)},
$S:3}
A.cs.prototype={
gm(a){return this.a},
gaw(){return new A.ct(this,this.$ti.h("ct<1>"))},
a3(a){var s,r
if(typeof a=="string"&&a!=="__proto__"){s=this.b
return s==null?!1:s[a]!=null}else if(typeof a=="number"&&(a&1073741823)===a){r=this.c
return r==null?!1:r[a]!=null}else return this.dg(a)},
dg(a){var s=this.d
if(s==null)return!1
return this.b6(this.bI(s,a),a)>=0},
k(a,b){var s,r,q
if(typeof b=="string"&&b!=="__proto__"){s=this.b
r=s==null?null:A.j6(s,b)
return r}else if(typeof b=="number"&&(b&1073741823)===b){q=this.c
r=q==null?null:A.j6(q,b)
return r}else return this.dv(b)},
dv(a){var s,r,q=this.d
if(q==null)return null
s=this.bI(q,a)
r=this.b6(s,a)
return r<0?null:s[r+1]},
l(a,b,c){var s,r,q,p,o,n,m=this,l=m.$ti
l.c.a(b)
l.y[1].a(c)
if(typeof b=="string"&&b!=="__proto__"){s=m.b
m.by(s==null?m.b=A.hR():s,b,c)}else if(typeof b=="number"&&(b&1073741823)===b){r=m.c
m.by(r==null?m.c=A.hR():r,b,c)}else{q=m.d
if(q==null)q=m.d=A.hR()
p=A.dF(b)&1073741823
o=q[p]
if(o==null){A.hS(q,p,[b,c]);++m.a
m.e=null}else{n=m.b6(o,b)
if(n>=0)o[n+1]=c
else{o.push(b,c);++m.a
m.e=null}}}},
ar(a,b){var s,r,q,p,o,n,m=this,l=m.$ti
l.h("~(1,2)").a(b)
s=m.bC()
for(r=s.length,q=l.c,l=l.y[1],p=0;p<r;++p){o=s[p]
q.a(o)
n=m.k(0,o)
b.$2(o,n==null?l.a(n):n)
if(s!==m.e)throw A.f(A.a1(m))}},
bC(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.e
if(h!=null)return h
h=A.ai(i.a,null,!1,t.z)
s=i.b
r=0
if(s!=null){q=Object.getOwnPropertyNames(s)
p=q.length
for(o=0;o<p;++o){h[r]=q[o];++r}}n=i.c
if(n!=null){q=Object.getOwnPropertyNames(n)
p=q.length
for(o=0;o<p;++o){h[r]=+q[o];++r}}m=i.d
if(m!=null){q=Object.getOwnPropertyNames(m)
p=q.length
for(o=0;o<p;++o){l=m[q[o]]
k=l.length
for(j=0;j<k;j+=2){h[r]=l[j];++r}}}return i.e=h},
by(a,b,c){var s=this.$ti
s.c.a(b)
s.y[1].a(c)
if(a[b]==null){++this.a
this.e=null}A.hS(a,b,c)},
bI(a,b){return a[A.dF(b)&1073741823]}}
A.bs.prototype={
b6(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=0;r<s;r+=2){q=a[r]
if(q==null?b==null:q===b)return r}return-1}}
A.ct.prototype={
gm(a){return this.a.a},
gD(a){var s=this.a
return new A.cu(s,s.bC(),this.$ti.h("cu<1>"))},
T(a,b){return this.a.a3(b)}}
A.cu.prototype={
gt(){var s=this.d
return s==null?this.$ti.c.a(s):s},
q(){var s=this,r=s.b,q=s.c,p=s.a
if(r!==p.e)throw A.f(A.a1(p))
else if(q>=r.length){s.d=null
return!1}else{s.d=r[q]
s.c=q+1
return!0}},
$iT:1}
A.w.prototype={
gD(a){return new A.b1(a,this.gm(a),A.aK(a).h("b1<w.E>"))},
I(a,b){return this.k(a,b)},
T(a,b){var s,r=this.gm(a)
for(s=0;s<r;++s){if(J.bb(this.k(a,s),b))return!0
if(r!==this.gm(a))throw A.f(A.a1(a))}return!1},
ad(a,b,c){var s=A.aK(a)
return new A.Y(a,s.u(c).h("1(w.E)").a(b),s.h("@<w.E>").u(c).h("Y<1,2>"))},
cv(a,b){return A.hH(a,0,A.cL(b,"count",t.S),A.aK(a).h("w.E"))},
n(a,b){var s
A.aK(a).h("w.E").a(b)
s=this.gm(a)
this.sm(a,s+1)
this.l(a,s,b)},
j(a){return A.is(a,"[","]")}}
A.aR.prototype={
ar(a,b){var s,r,q,p=A.S(this)
p.h("~(1,2)").a(b)
for(s=this.gaw(),s=s.gD(s),p=p.y[1];s.q();){r=s.gt()
q=this.k(0,r)
b.$2(r,q==null?p.a(q):q)}},
fQ(a){var s,r
for(s=J.aY(A.S(this).h("l<X<1,2>>").a(a));s.q();){r=s.gt()
this.l(0,r.a,r.b)}},
gm(a){var s=this.gaw()
return s.gm(s)},
j(a){return A.hE(this)},
$iaA:1}
A.eL.prototype={
$2(a,b){var s,r=this.a
if(!r.a)this.b.a+=", "
r.a=!1
r=this.b
s=A.t(a)
r.a=(r.a+=s)+": "
s=A.t(b)
r.a+=s},
$S:59}
A.h_.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:true})
return s}catch(r){}return null},
$S:27}
A.fZ.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:false})
return s}catch(r){}return null},
$S:27}
A.cN.prototype={
fW(a,b){var s
t.L.a(a)
s=B.ac.aq(a)
return s}}
A.fW.prototype={
aq(a){var s,r,q=a.length,p=A.c7(0,null,q),o=new Uint8Array(p)
for(s=0;s<p;++s){if(!(s<q))return A.a(a,s)
r=a.charCodeAt(s)
if((r&4294967168)!==0)throw A.f(A.dM(a,"string","Contains invalid characters."))
if(!(s<p))return A.a(o,s)
o[s]=r}return o}}
A.dO.prototype={}
A.fV.prototype={
aq(a){var s,r,q,p
t.L.a(a)
s=a.length
r=A.c7(0,null,s)
for(q=0;q<r;++q){if(!(q<s))return A.a(a,q)
p=a[q]
if((p&4294967168)>>>0!==0){if(!this.a)throw A.f(A.hv("Invalid value in input: "+p,null,null))
return this.di(a,0,r)}}return A.iT(a,0,r)},
di(a,b,c){var s,r,q
t.L.a(a)
for(s=b,r="";s<c;++s){if(!(s<a.length))return A.a(a,s)
q=a[s]
r+=A.bl((q&4294967168)>>>0!==0?65533:q)}return r.charCodeAt(0)==0?r:r}}
A.dN.prototype={}
A.bH.prototype={}
A.cV.prototype={}
A.cZ.prototype={}
A.fl.prototype={
aq(a){var s,r,q,p,o=a.length,n=A.c7(0,null,o)
if(n===0)return new Uint8Array(0)
s=n*3
r=new Uint8Array(s)
q=new A.h0(r)
if(q.du(a,0,n)!==n){p=n-1
if(!(p>=0&&p<o))return A.a(a,p)
q.bj()}return new Uint8Array(r.subarray(0,A.lQ(0,q.b,s)))}}
A.h0.prototype={
bj(){var s,r=this,q=r.c,p=r.b,o=r.b=p+1
q.$flags&2&&A.y(q)
s=q.length
if(!(p<s))return A.a(q,p)
q[p]=239
p=r.b=o+1
if(!(o<s))return A.a(q,o)
q[o]=191
r.b=p+1
if(!(p<s))return A.a(q,p)
q[p]=189},
fb(a,b){var s,r,q,p,o,n=this
if((b&64512)===56320){s=65536+((a&1023)<<10)|b&1023
r=n.c
q=n.b
p=n.b=q+1
r.$flags&2&&A.y(r)
o=r.length
if(!(q<o))return A.a(r,q)
r[q]=s>>>18|240
q=n.b=p+1
if(!(p<o))return A.a(r,p)
r[p]=s>>>12&63|128
p=n.b=q+1
if(!(q<o))return A.a(r,q)
r[q]=s>>>6&63|128
n.b=p+1
if(!(p<o))return A.a(r,p)
r[p]=s&63|128
return!0}else{n.bj()
return!1}},
du(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(b!==c){s=c-1
if(!(s>=0&&s<a.length))return A.a(a,s)
s=(a.charCodeAt(s)&64512)===55296}else s=!1
if(s)--c
for(s=k.c,r=s.$flags|0,q=s.length,p=a.length,o=b;o<c;++o){if(!(o<p))return A.a(a,o)
n=a.charCodeAt(o)
if(n<=127){m=k.b
if(m>=q)break
k.b=m+1
r&2&&A.y(s)
s[m]=n}else{m=n&64512
if(m===55296){if(k.b+4>q)break
m=o+1
if(!(m<p))return A.a(a,m)
if(k.fb(n,a.charCodeAt(m)))o=m}else if(m===56320){if(k.b+3>q)break
k.bj()}else if(n<=2047){m=k.b
l=m+1
if(l>=q)break
k.b=l
r&2&&A.y(s)
if(!(m<q))return A.a(s,m)
s[m]=n>>>6|192
k.b=l+1
s[l]=n&63|128}else{m=k.b
if(m+2>=q)break
l=k.b=m+1
r&2&&A.y(s)
if(!(m<q))return A.a(s,m)
s[m]=n>>>12|224
m=k.b=l+1
if(!(l<q))return A.a(s,l)
s[l]=n>>>6&63|128
k.b=m+1
if(!(m<q))return A.a(s,m)
s[m]=n&63|128}}}return o}}
A.dr.prototype={}
A.fY.prototype={
dh(a,b,c,d){var s,r,q,p,o,n,m,l=this
t.L.a(a)
s=A.c7(b,c,a.length)
if(b===s)return""
if(a instanceof Uint8Array){r=a
q=r
p=0}else{q=A.lD(a,b,s)
s-=b
p=b
b=0}if(s-b>=15){o=l.a
n=A.lC(o,q,b,s)
if(n!=null){if(!o)return n
if(n.indexOf("\ufffd")<0)return n}}n=l.b2(q,b,s,!0)
o=l.b
if((o&1)!==0){m=A.lE(o)
l.b=0
throw A.f(A.hv(m,a,p+l.c))}return n},
b2(a,b,c,d){var s,r,q=this
if(c-b>1000){s=B.b.N(b+c,2)
r=q.b2(a,b,s,!1)
if((q.b&1)!==0)return r
return r+q.b2(a,s,c,d)}return q.fX(a,b,c,d)},
fX(a,b,a0,a1){var s,r,q,p,o,n,m,l,k=this,j="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFFFFFFFFFFFFFFFFGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHHHHHHHHHHIHHHJEEBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBKCCCCCCCCCCCCDCLONNNMEEEEEEEEEEE",i=" \x000:XECCCCCN:lDb \x000:XECCCCCNvlDb \x000:XECCCCCN:lDb AAAAA\x00\x00\x00\x00\x00AAAAA00000AAAAA:::::AAAAAGG000AAAAA00KKKAAAAAG::::AAAAA:IIIIAAAAA000\x800AAAAA\x00\x00\x00\x00 AAAAA",h=65533,g=k.b,f=k.c,e=new A.bo(""),d=b+1,c=a.length
if(!(b>=0&&b<c))return A.a(a,b)
s=a[b]
$label0$0:for(r=k.a;!0;){for(;!0;d=o){if(!(s>=0&&s<256))return A.a(j,s)
q=j.charCodeAt(s)&31
f=g<=32?s&61694>>>q:(s&63|f<<6)>>>0
p=g+q
if(!(p>=0&&p<144))return A.a(i,p)
g=i.charCodeAt(p)
if(g===0){p=A.bl(f)
e.a+=p
if(d===a0)break $label0$0
break}else if((g&1)!==0){if(r)switch(g){case 69:case 67:p=A.bl(h)
e.a+=p
break
case 65:p=A.bl(h)
e.a+=p;--d
break
default:p=A.bl(h)
e.a=(e.a+=p)+p
break}else{k.b=g
k.c=d-1
return""}g=0}if(d===a0)break $label0$0
o=d+1
if(!(d>=0&&d<c))return A.a(a,d)
s=a[d]}o=d+1
if(!(d>=0&&d<c))return A.a(a,d)
s=a[d]
if(s<128){while(!0){if(!(o<a0)){n=a0
break}m=o+1
if(!(o>=0&&o<c))return A.a(a,o)
s=a[o]
if(s>=128){n=m-1
o=m
break}o=m}if(n-d<20)for(l=d;l<n;++l){if(!(l<c))return A.a(a,l)
p=A.bl(a[l])
e.a+=p}else{p=A.iT(a,d,n)
e.a+=p}if(n===a0)break $label0$0
d=o}else d=o}if(a1&&g>32)if(r){c=A.bl(h)
e.a+=c}else{k.b=77
k.c=a0
return""}k.b=g
k.c=f
c=e.a
return c.charCodeAt(0)==0?c:c}}
A.J.prototype={
a1(a){var s,r,q=this,p=q.c
if(p===0)return q
s=!q.a
r=q.b
p=A.U(p,r)
return new A.J(p===0?!1:s,r,p)},
dm(a){var s,r,q,p,o,n,m,l=this.c
if(l===0)return $.V()
s=l+a
r=this.b
q=new Uint16Array(s)
for(p=l-1,o=r.length;p>=0;--p){n=p+a
if(!(p<o))return A.a(r,p)
m=r[p]
if(!(n>=0&&n<s))return A.a(q,n)
q[n]=m}o=this.a
n=A.U(s,q)
return new A.J(n===0?!1:o,q,n)},
dn(a){var s,r,q,p,o,n,m,l,k=this,j=k.c
if(j===0)return $.V()
s=j-a
if(s<=0)return k.a?$.ic():$.V()
r=k.b
q=new Uint16Array(s)
for(p=r.length,o=a;o<j;++o){n=o-a
if(!(o>=0&&o<p))return A.a(r,o)
m=r[o]
if(!(n<s))return A.a(q,n)
q[n]=m}n=k.a
m=A.U(s,q)
l=new A.J(m===0?!1:n,q,m)
if(n)for(o=0;o<a;++o){if(!(o<p))return A.a(r,o)
if(r[o]!==0)return l.aC(0,$.aL())}return l},
a2(a,b){var s,r,q,p,o,n=this
if(b<0)throw A.f(A.a7("shift-amount must be posititve "+b,null))
s=n.c
if(s===0)return n
r=B.b.N(b,16)
if(B.b.a0(b,16)===0)return n.dm(r)
q=s+r+1
p=new Uint16Array(q)
A.j3(n.b,s,b,p)
s=n.a
o=A.U(q,p)
return new A.J(o===0?!1:s,p,o)},
aX(a,b){var s,r,q,p,o,n,m,l,k,j=this
if(b<0)throw A.f(A.a7("shift-amount must be posititve "+b,null))
s=j.c
if(s===0)return j
r=B.b.N(b,16)
q=B.b.a0(b,16)
if(q===0)return j.dn(r)
p=s-r
if(p<=0)return j.a?$.ic():$.V()
o=j.b
n=new Uint16Array(p)
A.lk(o,s,b,n)
s=j.a
m=A.U(p,n)
l=new A.J(m===0?!1:s,n,m)
if(s){s=o.length
if(!(r>=0&&r<s))return A.a(o,r)
if((o[r]&B.b.a2(1,q)-1)!==0)return l.aC(0,$.aL())
for(k=0;k<r;++k){if(!(k<s))return A.a(o,k)
if(o[k]!==0)return l.aC(0,$.aL())}}return l},
aP(a,b){var s,r=this.a
if(r===b.a){s=A.fx(this.b,this.c,b.b,b.c)
return r?0-s:s}return r?-1:1},
aE(a,b){var s,r,q,p=this,o=p.c,n=a.c
if(o<n)return a.aE(p,b)
if(o===0)return $.V()
if(n===0)return p.a===b?p:p.a1(0)
s=o+1
r=new Uint16Array(s)
A.li(p.b,o,a.b,n,r)
q=A.U(s,r)
return new A.J(q===0?!1:b,r,q)},
a4(a,b){var s,r,q,p=this,o=p.c
if(o===0)return $.V()
s=a.c
if(s===0)return p.a===b?p:p.a1(0)
r=new Uint16Array(o)
A.dv(p.b,o,a.b,s,r)
q=A.U(o,r)
return new A.J(q===0?!1:b,r,q)},
cP(a,b){var s,r,q,p,o,n,m,l,k=this.c,j=a.c
k=k<j?k:j
s=this.b
r=a.b
q=new Uint16Array(k)
for(p=s.length,o=r.length,n=0;n<k;++n){if(!(n<p))return A.a(s,n)
m=s[n]
if(!(n<o))return A.a(r,n)
l=r[n]
if(!(n<k))return A.a(q,n)
q[n]=m&l}p=A.U(k,q)
return new A.J(!1,q,p)},
cO(a,b){var s,r,q,p,o,n=this.c,m=this.b,l=a.b,k=new Uint16Array(n),j=a.c
if(n<j)j=n
for(s=m.length,r=l.length,q=0;q<j;++q){if(!(q<s))return A.a(m,q)
p=m[q]
if(!(q<r))return A.a(l,q)
o=l[q]
if(!(q<n))return A.a(k,q)
k[q]=p&~o}for(q=j;q<n;++q){if(!(q>=0&&q<s))return A.a(m,q)
r=m[q]
if(!(q<n))return A.a(k,q)
k[q]=r}s=A.U(n,k)
return new A.J(!1,k,s)},
cQ(a,b){var s,r,q,p,o,n,m,l,k=this.c,j=a.c,i=k>j?k:j,h=this.b,g=a.b,f=new Uint16Array(i)
if(k<j){s=k
r=a}else{s=j
r=this}for(q=h.length,p=g.length,o=0;o<s;++o){if(!(o<q))return A.a(h,o)
n=h[o]
if(!(o<p))return A.a(g,o)
m=g[o]
if(!(o<i))return A.a(f,o)
f[o]=n|m}l=r.b
for(q=l.length,o=s;o<i;++o){if(!(o>=0&&o<q))return A.a(l,o)
p=l[o]
if(!(o<i))return A.a(f,o)
f[o]=p}q=A.U(i,f)
return new A.J(q!==0,f,q)},
cz(a,b){var s,r,q,p=this
t.ev.a(b)
if(p.c===0||b.c===0)return $.V()
s=p.a
if(s===b.a){if(s){s=$.aL()
return p.a4(s,!0).cQ(b.a4(s,!0),!0).aE(s,!0)}return p.cP(b,!1)}if(s){r=p
q=b}else{r=b
q=p}return q.cO(r.a4($.aL(),!1),!1)},
aU(a,b){var s,r,q=this,p=q.c
if(p===0)return b
s=b.c
if(s===0)return q
r=q.a
if(r===b.a)return q.aE(b,r)
if(A.fx(q.b,p,b.b,s)>=0)return q.a4(b,r)
return b.a4(q,!r)},
aC(a,b){var s,r,q=this,p=q.c
if(p===0)return b.a1(0)
s=b.c
if(s===0)return q
r=q.a
if(r!==b.a)return q.aE(b,r)
if(A.fx(q.b,p,b.b,s)>=0)return q.a4(b,r)
return b.a4(q,!r)},
W(a,b){var s,r,q,p,o,n,m,l=this.c,k=b.c
if(l===0||k===0)return $.V()
s=l+k
r=this.b
q=b.b
p=new Uint16Array(s)
for(o=q.length,n=0;n<k;){if(!(n<o))return A.a(q,n)
A.j4(q[n],r,0,p,n,l);++n}o=this.a!==b.a
m=A.U(s,p)
return new A.J(m===0?!1:o,p,m)},
bE(a){var s,r,q,p
if(this.c<a.c)return $.V()
this.bF(a)
s=$.hM.S()-$.cq.S()
r=A.hO($.hL.S(),$.cq.S(),$.hM.S(),s)
q=A.U(s,r)
p=new A.J(!1,r,q)
return this.a!==a.a&&q>0?p.a1(0):p},
c1(a){var s,r,q,p=this
if(p.c<a.c)return p
p.bF(a)
s=A.hO($.hL.S(),0,$.cq.S(),$.cq.S())
r=A.U($.cq.S(),s)
q=new A.J(!1,s,r)
if($.hN.S()>0)q=q.aX(0,$.hN.S())
return p.a&&q.c>0?q.a1(0):q},
bF(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=c.c
if(b===$.j0&&a.c===$.j2&&c.b===$.j_&&a.b===$.j1)return
s=a.b
r=a.c
q=r-1
if(!(q>=0&&q<s.length))return A.a(s,q)
p=16-B.b.gap(s[q])
if(p>0){o=new Uint16Array(r+5)
n=A.iZ(s,r,p,o)
m=new Uint16Array(b+5)
l=A.iZ(c.b,b,p,m)}else{m=A.hO(c.b,0,b,b+2)
n=r
o=s
l=b}q=n-1
if(!(q>=0&&q<o.length))return A.a(o,q)
k=o[q]
j=l-n
i=new Uint16Array(l)
h=A.hP(o,n,j,i)
g=l+1
q=m.$flags|0
if(A.fx(m,l,i,h)>=0){q&2&&A.y(m)
if(!(l>=0&&l<m.length))return A.a(m,l)
m[l]=1
A.dv(m,g,i,h,m)}else{q&2&&A.y(m)
if(!(l>=0&&l<m.length))return A.a(m,l)
m[l]=0}q=n+2
f=new Uint16Array(q)
if(!(n>=0&&n<q))return A.a(f,n)
f[n]=1
A.dv(f,n+1,o,n,f)
e=l-1
for(q=m.length;j>0;){d=A.lj(k,m,e);--j
A.j4(d,f,0,m,j,n)
if(!(e>=0&&e<q))return A.a(m,e)
if(m[e]<d){h=A.hP(f,n,j,i)
A.dv(m,g,i,h,m)
for(;--d,m[e]<d;)A.dv(m,g,i,h,m)}--e}$.j_=c.b
$.j0=b
$.j1=s
$.j2=r
$.hL.b=m
$.hM.b=g
$.cq.b=n
$.hN.b=p},
gB(a){var s,r,q,p,o=new A.fy(),n=this.c
if(n===0)return 6707
s=this.a?83585:429689
for(r=this.b,q=r.length,p=0;p<n;++p){if(!(p<q))return A.a(r,p)
s=o.$2(s,r[p])}return new A.fz().$1(s)},
a_(a,b){if(b==null)return!1
return b instanceof A.J&&this.aP(0,b)===0},
gap(a){var s,r,q,p,o,n,m=this.c
if(m===0)return 0
s=this.b
r=m-1
q=s.length
if(!(r>=0&&r<q))return A.a(s,r)
p=s[r]
o=16*r+B.b.gap(p)
if(!this.a)return o
if((p&p-1)!==0)return o
for(n=m-2;n>=0;--n){if(!(n<q))return A.a(s,n)
if(s[n]!==0)return o}return o-1},
hc(a){var s,r
if(a===0)return $.aL()
s=$.aL()
for(r=this;a!==0;){if((a&1)===1)s=s.W(0,r)
a=a>>>1
if(a!==0)r=r.W(0,r)}return s},
aS(a){var s,r,q,p
for(s=this.c-1,r=this.b,q=r.length,p=0;s>=0;--s){if(!(s<q))return A.a(r,s)
p=p*65536+r[s]}return this.a?-p:p},
j(a){var s,r,q,p,o,n=this,m=n.c
if(m===0)return"0"
if(m===1){if(n.a){m=n.b
if(0>=m.length)return A.a(m,0)
return B.b.j(-m[0])}m=n.b
if(0>=m.length)return A.a(m,0)
return B.b.j(m[0])}s=A.b([],t.s)
m=n.a
r=m?n.a1(0):n
for(;r.c>1;){q=$.k0()
if(q.c===0)A.a0(B.y)
p=r.c1(q).j(0)
B.a.n(s,p)
o=p.length
if(o===1)B.a.n(s,"000")
if(o===2)B.a.n(s,"00")
if(o===3)B.a.n(s,"0")
r=r.bE(q)}q=r.b
if(0>=q.length)return A.a(q,0)
B.a.n(s,B.b.j(q[0]))
if(m)B.a.n(s,"-")
return new A.c8(s,t.bJ).bn(0)}}
A.fy.prototype={
$2(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
$S:47}
A.fz.prototype={
$1(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
$S:34}
A.cW.prototype={
a_(a,b){var s
if(b==null)return!1
s=!1
if(b instanceof A.cW)if(this.a===b.a)s=this.b===b.b
return s},
gB(a){return A.kU(this.a,this.b,B.p,B.p)},
j(a){var s=this,r=A.kv(A.l1(s)),q=A.cX(A.l_(s)),p=A.cX(A.kW(s)),o=A.cX(A.kX(s)),n=A.cX(A.kZ(s)),m=A.cX(A.l0(s)),l=A.ip(A.kY(s)),k=s.b,j=k===0?"":A.ip(k)
return r+"-"+q+"-"+p+" "+o+":"+n+":"+m+"."+l+j+"Z"}}
A.cY.prototype={
a_(a,b){if(b==null)return!1
return b instanceof A.cY},
gB(a){return B.b.gB(0)},
j(a){return"0:00:00."+B.f.cs(B.b.j(0),6,"0")}}
A.fC.prototype={
j(a){return this.R()}}
A.D.prototype={
gab(){return A.kV(this)}}
A.cO.prototype={
j(a){var s=this.a
if(s!=null)return"Assertion failed: "+A.e2(s)
return"Assertion failed"}}
A.aD.prototype={}
A.ag.prototype={
gb5(){return"Invalid argument"+(!this.a?"(s)":"")},
gb4(){return""},
j(a){var s=this,r=s.c,q=r==null?"":" ("+r+")",p=s.d,o=p==null?"":": "+p,n=s.gb5()+q+o
if(!s.a)return n
return n+s.gb4()+": "+A.e2(s.gbm())},
gbm(){return this.b}}
A.bm.prototype={
gbm(){return A.jm(this.b)},
gb5(){return"RangeError"},
gb4(){var s,r=this.e,q=this.f
if(r==null)s=q!=null?": Not less than or equal to "+A.t(q):""
else if(q==null)s=": Not greater than or equal to "+A.t(r)
else if(q>r)s=": Not in inclusive range "+A.t(r)+".."+A.t(q)
else s=q<r?": Valid value range is empty":": Only valid value is "+A.t(r)
return s}}
A.d_.prototype={
gbm(){return A.af(this.b)},
gb5(){return"RangeError"},
gb4(){if(A.af(this.b)<0)return": index must not be negative"
var s=this.f
if(s===0)return": no indices are valid"
return": index should be less than "+s},
gm(a){return this.f}}
A.ck.prototype={
j(a){return"Unsupported operation: "+this.a}}
A.dp.prototype={
j(a){var s=this.a
return s!=null?"UnimplementedError: "+s:"UnimplementedError"}}
A.bn.prototype={
j(a){return"Bad state: "+this.a}}
A.cU.prototype={
j(a){var s=this.a
if(s==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.e2(s)+"."}}
A.dg.prototype={
j(a){return"Out of Memory"},
gab(){return null},
$iD:1}
A.cc.prototype={
j(a){return"Stack Overflow"},
gab(){return null},
$iD:1}
A.fD.prototype={
j(a){return"Exception: "+this.a}}
A.e6.prototype={
j(a){var s,r,q,p,o,n,m,l,k,j,i,h=this.a,g=""!==h?"FormatException: "+h:"FormatException",f=this.c,e=this.b
if(typeof e=="string"){if(f!=null)s=f<0||f>e.length
else s=!1
if(s)f=null
if(f==null){if(e.length>78)e=B.f.aD(e,0,75)+"..."
return g+"\n"+e}for(r=e.length,q=1,p=0,o=!1,n=0;n<f;++n){if(!(n<r))return A.a(e,n)
m=e.charCodeAt(n)
if(m===10){if(p!==n||!o)++q
p=n+1
o=!1}else if(m===13){++q
p=n+1
o=!0}}g=q>1?g+(" (at line "+q+", character "+(f-p+1)+")\n"):g+(" (at character "+(f+1)+")\n")
for(n=f;n<r;++n){if(!(n>=0))return A.a(e,n)
m=e.charCodeAt(n)
if(m===10||m===13){r=n
break}}l=""
if(r-p>78){k="..."
if(f-p<75){j=p+75
i=p}else{if(r-f<75){i=r-75
j=r
k=""}else{i=f-36
j=f+36}l="..."}}else{j=r
i=p
k=""}return g+l+B.f.aD(e,i,j)+k+"\n"+B.f.W(" ",f-i+l.length)+"^\n"}else return f!=null?g+(" (at offset "+A.t(f)+")"):g}}
A.d0.prototype={
gab(){return null},
j(a){return"IntegerDivisionByZeroException"},
$iD:1}
A.l.prototype={
ad(a,b,c){var s=A.S(this)
return A.iH(this,s.u(c).h("1(l.E)").a(b),s.h("l.E"),c)},
T(a,b){var s
for(s=this.gD(this);s.q();)if(J.bb(s.gt(),b))return!0
return!1},
U(a,b){var s,r,q=this.gD(this)
if(!q.q())return""
s=J.a6(q.gt())
if(!q.q())return s
if(b.length===0){r=s
do r+=J.a6(q.gt())
while(q.q())}else{r=s
do r=r+b+J.a6(q.gt())
while(q.q())}return r.charCodeAt(0)==0?r:r},
gm(a){var s,r=this.gD(this)
for(s=0;r.q();)++s
return s},
I(a,b){var s,r
A.dk(b,"index")
s=this.gD(this)
for(r=b;s.q();){if(r===0)return s.gt();--r}throw A.f(A.hw(b,b-r,this,"index"))},
j(a){return A.kC(this,"(",")")}}
A.X.prototype={
j(a){return"MapEntry("+A.t(this.a)+": "+A.t(this.b)+")"}}
A.P.prototype={
gB(a){return A.h.prototype.gB.call(this,0)},
j(a){return"null"}}
A.h.prototype={$ih:1,
a_(a,b){return this===b},
gB(a){return A.c6(this)},
j(a){return"Instance of '"+A.dj(this)+"'"},
gG(a){return A.i3(this)},
toString(){return this.j(this)}}
A.dA.prototype={
j(a){return""},
$iat:1}
A.bo.prototype={
gm(a){return this.a.length},
j(a){var s=this.a
return s.charCodeAt(0)==0?s:s}}
A.e9.prototype={
$2(a,b){var s=t.g
this.a.aA(new A.e7(s.a(a)),new A.e8(s.a(b)),t.X)},
$S:35}
A.e7.prototype={
$1(a){var s=this.a
return s.call(s)},
$S:44}
A.e8.prototype={
$2(a,b){var s,r,q,p
A.j(a)
t.l.a(b)
s=t.g.a(v.G.Error)
r=A.h9(s,["Dart exception thrown from converted Future. Use the properties 'error' to fetch the boxed error and 'stack' to recover the stack trace."],t.m)
if(t.e.b(a))A.a0("Attempting to box non-Dart object.")
q={}
q[$.k6()]=a
r.error=q
r.stack=b.j(0)
p=this.a
p.call(p,r)},
$S:31}
A.hj.prototype={
$1(a){var s,r,q,p
if(A.ju(a))return a
s=this.a
if(s.a3(a))return s.k(0,a)
if(t.eO.b(a)){r={}
s.l(0,a,r)
for(s=a.gaw(),s=s.gD(s);s.q();){q=s.gt()
r[q]=this.$1(a.k(0,q))}return r}else if(t.R.b(a)){p=[]
s.l(0,a,p)
B.a.a8(p,J.dH(a,this,t.z))
return p}else return a},
$S:18}
A.hm.prototype={
$1(a){return this.a.a9(this.b.h("0/?").a(a))},
$S:13}
A.hn.prototype={
$1(a){if(a==null)return this.a.cq(new A.eN(a===undefined))
return this.a.cq(a)},
$S:13}
A.ha.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j,i,h
if(A.jt(a))return a
s=this.a
a.toString
if(s.a3(a))return s.k(0,a)
if(a instanceof Date){r=a.getTime()
if(r<-864e13||r>864e13)A.a0(A.a5(r,-864e13,864e13,"millisecondsSinceEpoch",null))
A.cL(!0,"isUtc",t.y)
return new A.cW(r,0,!0)}if(a instanceof RegExp)throw A.f(A.a7("structured clone of RegExp",null))
if(typeof Promise!="undefined"&&a instanceof Promise)return A.jH(a,t.X)
q=Object.getPrototypeOf(a)
if(q===Object.prototype||q===null){p=t.X
o=A.eK(p,p)
s.l(0,a,o)
n=Object.keys(a)
m=[]
for(s=J.aW(n),p=s.gD(n);p.q();)m.push(A.i2(p.gt()))
for(l=0;l<s.gm(n);++l){k=s.k(n,l)
if(!(l<m.length))return A.a(m,l)
j=m[l]
if(k!=null)o.l(0,j,this.$1(a[k]))}return o}if(a instanceof Array){i=a
o=[]
s.l(0,a,o)
h=A.af(a.length)
for(s=J.aI(i),l=0;l<h;++l)o.push(this.$1(s.k(i,l)))
return o}return a},
$S:18}
A.eN.prototype={
j(a){return"Promise was rejected with a value of `"+(this.a?"undefined":"null")+"`."}}
A.fQ.prototype={
cM(){var s=self.crypto
if(s!=null)if(s.getRandomValues!=null)return
throw A.f(A.bp("No source of cryptographically secure random numbers available."))},
bo(a){var s,r,q,p,o,n,m,l,k=null
if(a<=0||a>4294967296)throw A.f(new A.bm(k,k,!1,k,k,"max must be in range 0 < max \u2264 2^32, was "+a))
if(a>255)if(a>65535)s=a>16777215?4:3
else s=2
else s=1
r=this.a
r.$flags&2&&A.y(r,11)
r.setUint32(0,0,!1)
q=4-s
p=A.af(Math.pow(256,s))
for(o=a-1,n=(a&o)===0;!0;){crypto.getRandomValues(J.kb(B.aF.gco(r),q,s))
m=r.getUint32(0,!1)
if(n)return(m&o)>>>0
l=m%a
if(m-l+a<p)return l}}}
A.e0.prototype={}
A.bD.prototype={
R(){return"Base58Alphabets."+this.b}}
A.dR.prototype={}
A.fu.prototype={
n(a,b){var s=this,r=s.b,q=A.by(b,"\n","")
r=s.b=r+A.by(q,"\r","")
for(q=s.a;r.length>=4;){B.a.a8(q,A.iX(B.f.aD(r,0,4)))
r=B.f.aY(s.b,4)
s.b=r}}}
A.fv.prototype={
$0(){var s,r=t.S,q=A.ai(256,-1,!1,r)
for(s=0;s<64;++s)B.a.l(q,u.n.charCodeAt(s),s)
return A.hD(q,r)},
$S:46}
A.fw.prototype={
n(a,b){var s,r,q,p=this.b
B.a.a8(p,t.L.a(b))
for(s=this.a,r=p.$flags|0;p.length>=3;){q=A.iY(B.a.X(p,0,3))
s.a+=q
r&1&&A.y(p,18)
A.c7(0,3,p.length)
p.splice(0,3)}}}
A.dQ.prototype={}
A.dZ.prototype={
j(a){return this.a}}
A.eX.prototype={
aT(a){var s,r,q,p,o,n=this
t.L.a(a)
if(n.f)throw A.f(B.ap)
s=a.length
n.e+=s
r=0
if(n.d>0){q=n.c
while(!0){p=n.d
if(!(p<64&&s>0))break
n.d=p+1
o=r+1
if(!(r<a.length))return A.a(a,r)
B.a.l(q,p,a[r]&255);--s
r=o}if(p===64){n.ba(n.b,n.a,q,0,64)
n.d=0}}if(s>=64){r=n.ba(n.b,n.a,a,r,s)
s=B.b.a0(s,64)}for(q=n.c;s>0;r=o){p=n.d++
o=r+1
if(!(r<a.length))return A.a(a,r)
B.a.l(q,p,a[r]&255);--s}return n},
fZ(a){var s,r,q,p,o,n,m,l=this
t.L.a(a)
if(!l.f){s=l.e
r=l.d
q=B.b.N(s,536870912)
p=B.b.a0(s,64)<56?64:128
o=l.c
B.a.l(o,r,128)
for(n=r+1,m=p-8;n<m;++n)B.a.l(o,n,0)
A.i9(q>>>0,o,m)
A.i9(s<<3>>>0,o,p-4)
l.ba(l.b,l.a,o,0,p)
l.f=!0}for(q=l.a,n=0;n<8;++n)A.i9(q[n],a,n*4)
return l},
cu(){var s=this,r=s.a
B.a.l(r,0,1779033703)
B.a.l(r,1,3144134277)
B.a.l(r,2,1013904242)
B.a.l(r,3,2773480762)
B.a.l(r,4,1359893119)
B.a.l(r,5,2600822924)
B.a.l(r,6,528734635)
B.a.l(r,7,1541459225)
s.e=s.d=0
s.f=!1
return s},
ba(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=t.L
a2.a(a3)
a2.a(a4)
a2.a(a5)
for(a2=this.r,s=a2.length;a7>=64;){r=a4[0]
q=a4[1]
p=a4[2]
o=a4[3]
n=a4[4]
m=a4[5]
l=a4[6]
k=a4[7]
for(j=0;j<16;++j){i=a6+j*4
h=a5.length
if(!(i<h))return A.a(a5,i)
g=a5[i]
f=i+1
if(!(f<h))return A.a(a5,f)
f=a5[f]
e=i+2
if(!(e<h))return A.a(a5,e)
e=a5[e]
d=i+3
if(!(d<h))return A.a(a5,d)
B.a.l(a3,j,(g<<24|f<<16|e<<8|a5[d])>>>0)}for(j=16;j<64;++j){c=a3[j-2]
b=a3[j-15]
B.a.l(a3,j,(((((c>>>17|c<<15)^(c>>>19|c<<13)^c>>>10)>>>0)+a3[j-7]>>>0)+(((b>>>7|b<<25)^(b>>>18|b<<14)^b>>>3)>>>0)>>>0)+a3[j-16]>>>0)}for(j=0;j<64;++j,k=l,l=m,m=n,n=a0,o=p,p=q,q=r,r=a1){if(!(j<s))return A.a(a2,j)
a=((((n>>>6|n<<26)^(n>>>11|n<<21)^(n>>>25|n<<7))>>>0)+((n&m^~n&l)>>>0)>>>0)+((k+a2[j]>>>0)+a3[j]>>>0)>>>0
a0=o+a>>>0
a1=a+((((r>>>2|r<<30)^(r>>>13|r<<19)^(r>>>22|r<<10))>>>0)+((r&q^r&p^q&p)>>>0)>>>0)>>>0}B.a.l(a4,0,a4[0]+r>>>0)
B.a.l(a4,1,a4[1]+q>>>0)
B.a.l(a4,2,a4[2]+p>>>0)
B.a.l(a4,3,a4[3]+o>>>0)
B.a.l(a4,4,a4[4]+n>>>0)
B.a.l(a4,5,a4[5]+m>>>0)
B.a.l(a4,6,a4[6]+l>>>0)
B.a.l(a4,7,a4[7]+k>>>0)
a6+=64
a7-=64}return a6}}
A.dS.prototype={
j(a){var s,r,q=this.b
if(q==null)q=null
else{s=A.S(q).h("az<1,2>")
s=new A.cm(new A.az(q,s),s.h("C(l.E)").a(new A.dT()),s.h("cm<l.E>"))
q=s}if(q==null)q=A.b([],t.ao)
s=t.N
r=A.eK(s,t.z)
r.fQ(q)
if(r.a===0)return this.a
q=r.$ti.h("az<1,2>")
return this.a+" "+A.iH(new A.az(r,q),q.h("m(l.E)").a(new A.dU()),q.h("l.E"),s).U(0,", ")}}
A.dT.prototype={
$1(a){return t.I.a(a).b!=null},
$S:70}
A.dU.prototype={
$1(a){t.I.a(a)
return a.a+": "+A.t(a.b)},
$S:48}
A.bc.prototype={}
A.eM.prototype={}
A.fP.prototype={
fY(a,b){var s,r,q,p,o,n
t.L.a(a)
A.ko(a,"Invalid hex bytes")
s=a.length
r=A.ai(s*2,"",!1,t.N)
for(q=0;q<s;++q){if(!(q<a.length))return A.a(a,q)
p=a[q]
o=q*2
n=B.b.a6(p,4)
if(!(n<16))return A.a(B.v,n)
B.a.l(r,o,B.v[n])
n=p&15
if(!(n<16))return A.a(B.v,n)
B.a.l(r,o+1,B.v[n])}return B.a.bn(r)},
fV(a){var s,r,q,p,o,n,m=a.length
if(m===0){m=J.iu(0,t.S)
return m}if((m&1)!==0)throw A.f(B.aa)
s=A.ai(B.b.N(m,2),0,!1,t.S)
for(r=!1,q=0;q<m;q+=2){p=a.charCodeAt(q)
o=p<128?B.a0[p]:256
p=q+1
if(!(p<m))return A.a(a,p)
p=a.charCodeAt(p)
n=p<128?B.a0[p]:256
B.a.l(s,B.b.N(q,2),(o<<4|n)&255)
r=B.z.aB(r,B.z.aB(o===256,n===256))}if(r)throw A.f(B.ab)
return s}}
A.d8.prototype={
R(){return"LockId."+this.b}}
A.eZ.prototype={
br(a,b){var s,r,q
b.h("0/()").a(a)
s=this.a
r=s.k(0,B.R)
if(r==null){r=new A.u($.x,t.D)
r.b1(null)}q=new A.u($.x,t.D)
s.l(0,B.R,q)
return r.af(new A.f_(this,a,B.R,new A.cB(q,t.aj),b),b)}}
A.f_.prototype={
$1(a){return this.cA(a,this.e)},
cA(a,b){var s=0,r=A.ao(b),q,p=2,o=[],n=[],m=this,l,k,j
var $async$$1=A.ap(function(c,d){if(c===1){o.push(d)
s=p}while(true)switch(s){case 0:p=3
s=6
return A.aV(A.kB(m.b,m.e),$async$$1)
case 6:l=d
q=l
n=[1]
s=4
break
n.push(5)
s=4
break
case 3:n=[2]
case 4:p=2
l=m.a.a
k=m.c
j=m.d
if(l.k(0,k)===j.a)l.ae(0,k)
j.aQ()
s=n.pop()
break
case 5:case 1:return A.am(q,r)
case 2:return A.al(o.at(-1),r)}})
return A.an($async$$1,r)},
$S(){return this.e.h("Q<0>(~)")}}
A.e1.prototype={
a_(a,b){var s=this
if(b==null)return!1
if(s===b)return!0
if(!(b instanceof A.cl))return!1
if(A.i3(b)!==A.i3(s))return!1
return A.ku([s.d,null,s.a],[b.d,null,b.a],t.z)},
gB(a){return A.iq([this.d,null,this.a])}}
A.aC.prototype={
R(){return"StringEncoding."+this.b}}
A.ff.prototype={
$1(a){var s
if(a===6)return this.a.bo(16)&15|64
else{s=this.a
if(a===8)return s.bo(4)&3|8
else return s.bo(256)}},
$S:34}
A.fg.prototype={
$1(a){return B.f.cs(B.b.hf(A.af(a),16),2,"0")},
$S:50}
A.ds.prototype={
R(){return"Web3ErrorCode."+this.b}}
A.cl.prototype={
j(a){return this.a}}
A.dD.prototype={}
A.ej.prototype={
$1(a){return J.a6(A.j(a))},
$S:57}
A.ei.prototype={
$0(){return A.k(this.a.dataHex)},
$S:23}
A.eh.prototype={
$0(){return B.f.aY(A.k(this.a.dataHex),2)},
$S:23}
A.ee.prototype={
$0(){return A.j(this.a.data)},
$S:10}
A.ef.prototype={
$1(a){A.j(a).serializeFixedBytes(A.j(this.a.data))},
$S:24}
A.eg.prototype={
$0(){return A.k(this.a.dataHex)},
$S:23}
A.aN.prototype={
R(){return"JSAptosWalletStandardUserResponseStatus."+this.b}}
A.ek.prototype={
$1(a){return t.c_.a(a).c===this.a},
$S:41}
A.el.prototype={
$0(){return A.a0(B.m)},
$S:7}
A.aS.prototype={
cC(a,b,c,d){var s,r,q,p,o,n,m
A.j(a)
try{p=v.G
s=p.Reflect.get(a,b,d)
r=typeof s==="undefined"
o=b==null
n=!o||null
if(n===!0)if(!o&&typeof b==="string"){q=A.k(b)
if(typeof s==="undefined")J.dG(this.c,q)
o=r
n=J.id(this.c,q)
if(typeof o!=="boolean")return o.aB()
r=B.z.aB(o,n)}if(r){p=A.jk(p.Reflect.set(a,b,c,d))
return p}return!1}catch(m){return!1}},
cB(a,b,c){var s,r,q,p
A.j(a)
s=b==null
r=!s||null
if(r===!0)if(!s&&typeof b==="string"){q=A.k(A.i2(b))
if(B.f.bv(q,"is")&&!B.a.T(B.aA,q)){p=v.G.Reflect.get(a,b,c)
if(p!=null)return p
return!0}}return v.G.Reflect.get(a,b,c)},
sbp(a){this.c=t.a.a(a)}}
A.dh.prototype={}
A.e_.prototype={
$1(a){var s
A.d(a)
s=v.G
A.d(s.window).dispatchEvent(this.a)
A.d(s.window).removeEventListener("eip6963:requestProvider",A.c(this))},
$S:11}
A.fp.prototype={
$2(a,b){var s,r,q,p=t.g
p.a(a)
p.a(b)
p=this.a.aA(new A.fm(a),new A.fn(b),t.X)
s=new A.fo(b,a)
r=p.$ti
q=$.x
if(q!==B.i)s=A.jv(s,q)
p.aF(new A.aG(new A.u(q,r),2,null,s,r.h("aG<1,1>")))},
$S:35}
A.fm.prototype={
$1(a){var s=this.a
s.call(s,a)
return a},
$S:18}
A.fn.prototype={
$2(a,b){var s
A.j(a)
t.l.a(b)
s=this.a
s.call(s,a)
return a},
$S:49}
A.fo.prototype={
$1(a){this.a.call(this.b,a)
return a},
$S:36}
A.eS.prototype={
$0(){return this.a.a},
$S:21}
A.eT.prototype={
$0(){return this.a.b},
$S:20}
A.eU.prototype={
$0(){return this.a.c},
$S:19}
A.eV.prototype={
$1(a){this.a.sbp(t.a.a(a))},
$S:17}
A.eW.prototype={
$0(){var s,r,q,p=this.a,o=v.G,n=A.d(o.Object),m=A.d(n.create.apply(n,[null]))
m.set=A.hX(p.gaW())
m.get=A.hW(p.gaV())
n=A.d(o.Object)
s=A.d(n.create.apply(n,[null]))
s.get=A.p(new A.eS(p))
n=A.d(o.Object)
n.defineProperty.apply(n,[m,"debugKey",s])
n=A.d(o.Object)
r=A.d(n.create.apply(n,[null]))
r.get=A.p(new A.eT(p))
n=A.d(o.Object)
n.defineProperty.apply(n,[m,"object",r])
n=A.d(o.Object)
q=A.d(n.create.apply(n,[null]))
q.get=A.p(new A.eU(p))
q.set=A.c(new A.eV(p))
o=A.d(o.Object)
o.defineProperty.apply(o,[m,"probs",q])
return m},
$S:10}
A.eR.prototype={
$1(a){return A.k(a)},
$S:28}
A.hk.prototype={
$1(a){var s,r,q=this
A.d(a)
s=q.a
if(s.a)return
r=A.d(A.d(a.detail).data)
if(A.iA(A.k(r.status))===B.Q){s=r.data
if(s==null)s=A.j(s)
if(A.A(s.message)!=null)A.d(v.G.console).error(A.A(s.message))
s=q.b.d
if(s!=null)s.aQ()
return}s.a=!0
A.d(v.G.window).addEventListener("WALLET_ACTIVATION",A.c(q))
s=r.data
q.b.h3(A.k(s==null?null:A.i2(s)))},
$S:11}
A.aO.prototype={
R(){return"JSWalletMessageType."+this.b}}
A.eC.prototype={
$1(a){return t.fr.a(a).b===this.a},
$S:39}
A.eD.prototype={
$0(){return A.a0(B.m)},
$S:7}
A.W.prototype={
R(){return"JSNetworkEventType."+this.b}}
A.et.prototype={
$1(a){return t.bs.a(a).b===this.a},
$S:38}
A.eu.prototype={
$0(){return A.a0(B.m)},
$S:7}
A.ac.prototype={
R(){return"JSEventType."+this.b}}
A.er.prototype={
$1(a){return t.A.a(a).b===this.a},
$S:37}
A.es.prototype={
$0(){return A.a0(B.m)},
$S:7}
A.eq.prototype={
$1(a){return t.A.a(a).b===this.a},
$S:37}
A.aP.prototype={
R(){return"JSWalletResponseType."+this.b}}
A.eH.prototype={
$1(a){return t.e5.a(a).b===this.a},
$S:40}
A.eI.prototype={
$0(){return A.a0(B.m)},
$S:7}
A.L.prototype={
R(){return"JSClientType."+this.b}}
A.eo.prototype={
$1(a){return t.U.a(a).b===this.a},
$S:63}
A.ep.prototype={
$0(){return A.a0(B.m)},
$S:7}
A.c5.prototype={
R(){return"PageRequestType."+this.b}}
A.em.prototype={
gbq(){var s=this.a
return s===$?this.a=new A.eP(this.ghb(),A.eK(t.N,t.hg)):s},
gbi(){var s,r,q=this,p=q.b
if(p===$){s=q.gbq()
r=A.b([],t.G)
q.b!==$&&A.i8("_walletStandardController")
p=q.b=new A.d5(s,{},{},r)}return p},
aO(){var s=0,r=A.ao(t.H),q,p=this,o
var $async$aO=A.ap(function(a,b){if(a===1)return A.al(b,r)
while(true)switch(s){case 0:o=p.c
o=o==null?null:o.br(new A.en(p),t.H)
s=3
return A.aV(o instanceof A.u?o:A.hQ(o,t.H),$async$aO)
case 3:q=b
s=1
break
case 1:return A.am(q,r)}})
return A.an($async$aO,r)},
gc_(){var s,r,q,p,o,n=this,m=n.f
if(m===$){s=n.gbq()
r=t.G
q=t.A
p=t.u
o=A.E([B.F,new A.bM(A.E([B.h,A.b([],r),B.j,A.b([],r),B.l,A.b([],r),B.c,A.b([],r),B.n,A.b([],r)],q,p),s,A.E([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.M,new A.ci({base58:!1,hex:!1},A.E([B.h,A.b([],r),B.j,A.b([],r),B.l,A.b([],r),B.n,A.b([],r)],q,p),s,A.E([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.H,new A.cb(s,A.E([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.L,new A.ch(s,A.E([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.I,new A.cd(s,A.E([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.J,new A.cf(A.E([B.h,A.b([],r)],q,p),s,A.E([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.A,new A.bB(A.E([B.h,A.b([],r),B.j,A.b([],r)],q,p),s,A.E([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.K,new A.cg(s,A.E([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.E,new A.bJ(s,A.E([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.C,new A.bF(s,A.E([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.N,new A.c9(s,A.E([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.G,new A.bZ(s,A.E([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.D,new A.bA(s,A.E([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.B,new A.bE(s,A.E([B.d,A.b([],r),B.c,A.b([],r)],q,p))],t.U,t.aQ)
n.f!==$&&A.i8("_networks")
n.f=o
m=o}return m},
e0(){var s,r,q,p,o,n,m,l,k,j,i="Initializing wallet failed: "
try{for(m=this.gc_(),m=new A.az(m,A.S(m).h("az<1,2>")).gD(0),l=v.G;m.q();){k=m.d
k.toString
s=k
try{r=s.b
r.O(this.gbi().c)}catch(j){q=A.ar(j)
p=A.aJ(j)
A.d(l.console).error(i+s.a.c+" "+A.t(q)+" "+A.t(p))}}this.gbi().am()}catch(j){o=A.ar(j)
n=A.aJ(j)
A.d(v.G.console).error(i+A.t(o)+" "+A.t(n))}},
h1(a){var s,r,q,p,o
if(A.kM(A.k(A.d(a.data).type))===B.Z){s=this.gbq().b.k(0,A.k(a.requestId))
if(s!=null){r=A.d(a.data)
s.b.a9(r)}return}q=A.d(a.data)
if((A.A(a.client)==null?null:A.iw(A.A(a.client)))==null){s=this.gbi()
q=A.d(q.data)
r=t.r
if(r.a(q.accounts)!=null){p=r.a(q.accounts)
p.toString
s.b.accounts=p}if(r.a(q.chains)!=null){p=r.a(q.chains)
p.toString
s.b.chains=p}o={}
o.change=q
o.accounts=r.a(q.accounts)
o.chains=r.a(q.chains)
s.dq(o)
return}s=this.gc_()
s=s.k(0,A.A(a.client)==null?null:A.iw(A.A(a.client)))
if(s!=null)s.az(q)}}
A.en.prototype={
$0(){var s=0,r=A.ao(t.H),q,p=2,o=[],n=[],m=this,l
var $async$$0=A.ap(function(a,b){if(a===1){o.push(b)
s=p}while(true)switch(s){case 0:p=3
l=m.a.d
l=l==null?null:l.a
s=6
return A.aV(l instanceof A.u?l:A.hQ(l,t.H),$async$$0)
case 6:l=b
q=l
n=[1]
s=4
break
n.push(5)
s=4
break
case 3:n=[2]
case 4:p=2
l=m.a
l.c=l.d=null
s=n.pop()
break
case 5:case 1:return A.am(q,r)
case 2:return A.al(o.at(-1),r)}})
return A.an($async$$0,r)},
$S:42}
A.d4.prototype={
aR(a){var s=0,r=A.ao(t.H),q=this,p,o,n
var $async$aR=A.ap(function(b,c){if(b===1)return A.al(c,r)
while(true)switch(s){case 0:s=2
return A.aV(q.aO(),$async$aR)
case 2:p=q.e
o=v.G
n=A.d(new o.CustomEvent(p,{bubbles:!0,cancelable:!1,detail:a,data:null}))
A.d(o.window).dispatchEvent(n)
return A.am(null,r)}})
return A.an($async$aR,r)},
ei(a){this.h1(A.d(A.d(a).detail))},
h3(a){var s,r=this
if(r.e!=null)return
r.e="WALLET_"+a
A.d(v.G.window).addEventListener("ETH_"+a,A.c(r.geh()))
s=r.d
if(s!=null)s.aQ()}}
A.d5.prototype={
bd(a,b){var s
A.k(a)
t.g.a(b)
s=A.bQ(a)
if(s!==B.d)return null
if(s!=null)B.a.n(this.d,b)
this.a.a.$1(A.iJ(null,A.bj(B.d)))
return A.p(new A.ey(this,b))},
dq(a){var s,r,q,p=A.ad(this.d,t.g)
for(s=p.length,r=0;r<p.length;p.length===s||(0,A.av)(p),++r){q=p[r]
q.call(q,a)}},
p(a){return A.Z(new A.ev(this,A.F(a)).$0(),t.m)},
A(){return this.p(null)},
am(){var s,r,q,p=this,o=p.c
o["standard:events"]=A.a2(A.r(p.gK()))
s={}
s.connect=A.c(p.gv())
s.version="1.0.0"
o["standard:connect"]=s
r=p.b
r.features=o
r.name="OnChain"
r.version="1.0.0"
r.icon=u.f
r.accounts=A.b([],t.O)
r=v.G
q=A.d(new r.CustomEvent("wallet-standard:register-wallet",{bubbles:!1,cancelable:!1,detail:A.c(new A.ew(p))}))
A.d(r.window).addEventListener("wallet-standard:app-ready",A.c(new A.ex(q)))
A.d(r.window).dispatchEvent(q)}}
A.ey.prototype={
$0(){B.a.ae(this.a.d,this.b)},
$S:3}
A.ev.prototype={
$0(){var s=0,r=A.ao(t.m),q,p=this,o,n,m
var $async$$0=A.ap(function(a,b){if(a===1)return A.al(b,r)
while(true)switch(s){case 0:n=p.a
m=p.b
m=m!=null?A.b([m],t.O):null
s=3
return A.aV(n.a.P("connect",m,t.m),$async$$0)
case 3:o=b
n.b.accounts=t.c.a(o.accounts)
q=o
s=1
break
case 1:return A.am(q,r)}})
return A.an($async$$0,r)},
$S:45}
A.ew.prototype={
$1(a){A.j(a).register(this.a.b)},
$S:24}
A.ex.prototype={
$1(a){A.j(a)
A.d(v.G.window).dispatchEvent(this.a)},
$S:24}
A.N.prototype={
C(a,b,c,d){return this.a.cw(this.gH(),a,b,c,d)},
i(a,b,c){return this.C(a,b,B.o,c)},
ai(a,b,c){return this.C(a,null,b,c)},
ah(a,b){return this.C(a,null,B.o,b)},
P(a,b,c){return this.hl(a,b,c,c)},
hj(a,b){return this.P(a,null,b)},
hl(a,b,c,d){var s=0,r=A.ao(d),q,p=this
var $async$P=A.ap(function(e,f){if(e===1)return A.al(f,r)
while(true)switch(s){case 0:q=p.a.ag(p.gH(),a,b,B.o,c)
s=1
break
case 1:return A.am(q,r)}})
return A.an($async$P,r)},
dl(){return this.a.hm(this.gH(),"disconnect",t.X)},
ac(a){var s=A.kH(A.k(a.event))
if(!(s===B.h||s===B.j||s===B.l||s===B.d))return
this.a.a.$1(A.iJ(this.gH(),a))},
bd(a,b){var s,r
A.k(a)
t.g.a(b)
s=A.bQ(a)
r=this.b
if(r.k(0,s)==null)throw A.f({message:"Unsuported "+A.kJ(a)+" event."})
if(s!=null){r=r.k(0,s)
r.toString
B.a.n(r,b)
this.ac(A.bj(s))}},
aI(a,b){var s,r,q,p=A.ad(t.u.a(a),t.g)
for(s=p.length,r=0;r<p.length;p.length===s||(0,A.av)(p),++r){q=p[r]
q.call(q,b)}},
bG(a,b){var s=this.b
if(!s.a3(a))return
s=s.k(0,a)
s.toString
this.aI(s,b)},
az(a){var s,r,q=A.d(a.data),p=A.eE(q)
for(s=p.length,r=0;r<p.length;p.length===s||(0,A.av)(p),++r)switch(p[r]){case B.Y:this.bG(B.d,A.F(q.change))
break}}}
A.eP.prototype={
aL(a,b){return this.e_(a,b)},
e_(a,b){var s=0,r=A.ao(t.m),q,p=2,o=[],n=[],m=this,l,k,j,i
var $async$aL=A.ap(function(c,d){if(c===1){o.push(d)
s=p}while(true)switch(s){case 0:i=new A.dh(A.lc(),new A.aF(new A.u($.x,t.et),t.cR))
p=3
k=i.a
j=a==null?null:a.b
l={data:b,requestId:k,client:j}
m.a.$1(l)
j=m.b
k=i.a
if(j.k(0,k)==null)j.l(0,k,i)
s=6
return A.aV(i.b.a,$async$aL)
case 6:k=d
q=k
n=[1]
s=4
break
n.push(5)
s=4
break
case 3:n=[2]
case 4:p=2
m.b.ae(0,i.a)
s=n.pop()
break
case 5:case 1:return A.am(q,r)
case 2:return A.al(o.at(-1),r)}})
return A.an($async$aL,r)},
cw(a,b,c,d,e){return A.Z(this.ag(a,b,c,d,e),e)},
hm(a,b,c){return this.cw(a,b,null,B.o,c)},
h8(a,b,c){throw A.f(a)},
h9(a,b,c){return this.h8(a,b,c,t.X)},
ag(a,b,c,d,e){return this.hk(a,b,c,d,e,e)},
P(a,b,c){return this.ag(null,a,b,B.o,c)},
hk(a,b,c,d,e,f){var s=0,r=A.ao(f),q,p=this,o,n
var $async$ag=A.ap(function(g,h){if(g===1)return A.al(h,r)
while(true)$async$outer:switch(s){case 0:s=3
return A.aV(p.aL(a,{type:"request",method:b,params:c,providerType:d.b}),$async$ag)
case 3:n=h
switch(A.iA(A.k(n.status))){case B.a_:q=e.a(n.data)
s=1
break $async$outer
case B.Q:o=n.data
q=p.h9(o==null?A.j(o):o,b,d)
s=1
break $async$outer}case 1:return A.am(q,r)}})
return A.an($async$ag,r)}}
A.bA.prototype={
O(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=g.ge2(),e=A.p(f),d=A.c(g.gaj()),c={}
c.isEnabled=e
c.apiVersion="1"
c.name="OnChain"
c.icon=u.f
c.enable=d
e=v.G
if(e.cardano==null)e.cardano={}
A.j(e.cardano).onChain=A.a4(c,"cardanoExtension: ",t.K)
a["cardano:connect"]=A.ix(A.c(g.gv()))
c={}
c.signMessage=A.c(g.gE())
c.version="1.0.0"
a["cardano:signMessage"]=c
a["cardano:events"]=A.a2(A.r(g.gK()))
a["cardano:disconnect"]=A.ah(A.p(g.gJ()))
c={}
c.getNetwork=A.p(g.gfm())
c.version="1.0.0"
a["cardano:getNetworkId"]=c
c={}
c.getBalance=A.p(g.gfg())
c.version="1.0.0"
a["cardano:getBalance"]=c
c={}
c.getUtxos=A.r(g.gfB())
c.version="1.0.0"
a["cardano:getUtxos"]=c
c={}
c.getAddressUtxos=A.c(g.gfe())
c.version="1.0.0"
a["cardano:getAddressUtxos"]=c
c={}
c.getCollateral=A.c(g.gfk())
c.version="1.0.0"
a["cardano:getCollateral"]=c
c={}
c.getUsedAddresses=A.c(g.gfz())
c.version="1.0.0"
a["cardano:getUsedAddresses"]=c
c={}
c.getUnusedAddresses=A.c(g.gfv())
c.version="1.0.0"
a["cardano:getUnusedAddresses"]=c
c={}
c.getChangeAddress=A.p(g.gfi())
c.version="1.0.0"
a["cardano:getChangeAddress"]=c
c={}
c.getRewardAddresses=A.c(g.gfo())
c.version="1.0.0"
a["cardano:getRewardAddresses"]=c
c={}
c.signTx=A.r(g.gfG())
c.version="1.0.0"
a["cardano:signTx"]=c
c={}
c.signData=A.r(g.gfE())
c.version="1.0.0"
a["cardano:signData"]=c
c={}
c.signTransaction=A.c(g.gL())
c.version="1.0.0"
a["cardano:signTransaction"]=c
c={}
c.signAndSendTransaction=A.c(g.gbg())
c.version="1.0.0"
a["cardano:signAndSendTransaction"]=c
c={}
c.getScript=A.c(g.gfq())
c.version="1.0.0"
a["cardano:getScript"]=c
c={}
c.isEnabled=A.p(f)
c.version="1.0.0"
a["cardano:isEnabled"]=c
c={}
c.submitTx=A.c(g.gfK())
c.version="1.0.0"
a["cardano:submitTx"]=c
c={}
c.submitTxs=A.c(g.gfM())
c.version="1.0.0"
a["cardano:submitTxs"]=c
c={}
c.signTxs=A.c(g.gfI())
c.version="1.0.0"
a["cardano:signTxs"]=c
c={}
c.getAccountPub=A.c(g.gfc())
c.version="1.0.0"
a["cardano:getAccountPub"]=c
c={}
c.getScriptRequirements=A.c(g.gft())
c.version="1.0.0"
a["cardano:getScriptRequirements"]=c
c={}
c.submitUnsignedTx=A.c(g.gfO())
c.version="1.0.0"
a["cardano:submitUnsignedTx"]=c
f=A.c(g.geV())
e=A.c(g.gf7())
c={}
c.signTxs=f
c.submitTxs=e
s={}
s.getAccountPub=A.c(g.gdw())
e=A.c(g.gdR())
f=A.c(g.gdP())
d=A.c(g.gf9())
r=A.c(g.gdG())
q=g.gdE()
p=A.c(q)
o={}
o.getScriptRequirements=e
o.getScript=f
o.submitUnsignedTx=d
o.getCompletedTx=r
o.getCollateral=p
p=A.p(g.gdA())
r=A.p(g.gdC())
q=A.c(q)
d=A.p(g.gdI())
f=A.p(g.gdK())
e=A.c(g.gdN())
n=A.c(g.gdT())
m=A.c(g.gdV())
l=A.r(g.gdX())
k=A.r(g.geE())
j=A.r(g.geT())
i=A.c(g.gf5())
h={}
h.getExtensions=d
h.getNetworkId=f
h.getCollateral=q
h.getBalance=p
h.getUsedAddresses=m
h.getUnusedAddresses=n
h.getChangeAddress=r
h.getRewardAddresses=e
h.signTx=j
h.signData=k
h.submitTx=i
h.getUtxos=l
h.cip103=c
h.cip104=s
h.cip106=o
g.c!==$&&A.mJ("_api")
g.c=h},
cg(a){return this.i("cardano_getScriptRequirements",A.B(A.F(a)),t.c)},
fu(){return this.cg(null)},
bT(a){return this.C("cardano_getScriptRequirements",A.B(A.A(a)),B.e,t.c)},
dS(){return this.bT(null)},
dH(a){return this.C("cardano_getCompletedTx",A.b([A.k(a)],t.s),B.e,t.c)},
fa(a){return this.C("cardano_submitUnsignedTx",A.b([A.k(a)],t.s),B.e,t.N)},
fP(a){return this.i("cardano_submitUnsignedTx",A.b([A.k(a)],t.s),t.N)},
bS(a){return this.C("cardano_getScript",A.B(A.F(a)),B.e,t.N)},
dQ(){return this.bS(null)},
cf(a){return this.i("cardano_getScript",A.B(A.F(a)),t.N)},
fs(){return this.cf(null)},
c7(a,b){var s
A.k(a)
s=A.aa(A.ak(b))
return this.C("cardano_signTx",A.b([a,s==null?!1:s],t.f),B.e,t.K)},
eU(a){return this.c7(a,null)},
cc(a){return this.i("cardano_getAccountPub",A.B(A.F(a)),t.N)},
fd(){return this.cc(null)},
bH(a){return this.C("cardano_getAccountPub",A.B(A.F(a)),B.e,t.N)},
dz(){return this.bH(null)},
p(a){var s=A.a3(A.A(a)),r=s==null?null:A.b([s],t.s)
return this.i("cardano_requestAccounts",r,t.m)},
A(){return this.p(null)},
aJ(a){var s=A.a3(A.A(a)),r=s==null?null:A.b([s],t.s),q=t.m
return A.Z(this.P("cardano_requestAccounts",r,q).af(new A.dI(this),q),q)},
b3(){return this.aJ(null)},
e3(){return this.ah("cardano_isEnabled",t.y)},
fn(){return this.ah("cardano_getNetworkId",t.y)},
dL(){return this.ai("cardano_getNetworkId",B.e,t.i)},
b9(a,b){A.A(a)
A.F(b)
return this.C("cardano_getUtxos",[A.aa(a),A.aa(b)],B.e,t.c)},
dY(){return this.b9(null,null)},
dZ(a){return this.b9(a,null)},
ff(a){return this.i("cardano_getAddressUtxos",A.B(A.d(a)),t.c)},
bk(a,b){A.A(a)
A.F(b)
return this.i("cardano_getUtxos",[A.aa(a),A.aa(b)],t.c)},
fC(){return this.bk(null,null)},
fD(a){return this.bk(a,null)},
fh(){return this.ah("cardano_getBalance",t.N)},
dB(){return this.ai("cardano_getBalance",B.e,t.N)},
cj(a){return this.i("cardano_getUsedAddresses",[A.aa(A.F(a))],t.c)},
fA(){return this.cj(null)},
bV(a){return this.C("cardano_getUsedAddresses",[A.aa(A.F(a))],B.e,t.c)},
dW(){return this.bV(null)},
bU(a){return this.C("cardano_getUnusedAddresses",[A.aa(A.F(a))],B.e,t.c)},
dU(){return this.bU(null)},
ci(a){return this.i("cardano_getUnusedAddresses",[A.aa(A.F(a))],t.c)},
fw(){return this.ci(null)},
ce(a){return this.i("cardano_getRewardAddresses",[A.aa(A.F(a))],t.c)},
fp(){return this.ce(null)},
bR(a){return this.C("cardano_getRewardAddresses",[A.aa(A.F(a))],B.e,t.c)},
dO(){return this.bR(null)},
cd(a){return this.i("cardano_getCollateral",[A.aa(A.F(a))],t.r)},
fl(){return this.cd(null)},
bJ(a){return this.C("cardano_getCollateral",[A.aa(A.F(a))],B.e,t.r)},
dF(){return this.bJ(null)},
ck(a,b){var s
A.k(a)
s=A.aa(A.ak(b))
return this.i("cardano_signTx",A.b([a,s==null?!1:s],t.f),t.K)},
fH(a){return this.ck(a,null)},
eW(a){return this.C("cardano_signTxs",A.B(t.c.a(a)),B.e,t.K)},
f8(a){return this.C("cardano_submitTxs",A.B(t.c.a(a)),B.e,t.K)},
fJ(a){return this.i("cardano_signTxs",A.B(t.c.a(a)),t.K)},
fN(a){return this.i("cardano_submitTxs",A.B(t.c.a(a)),t.K)},
fF(a,b){return this.i("cardano_signData",A.b([A.j(a),A.j(b)],t.f),t.m)},
eF(a,b){return this.C("cardano_signData",A.b([A.k(a),A.j(b)],t.f),B.e,t.m)},
fj(){return this.ah("cardano_getChangeAddress",t.N)},
dD(){return this.ai("cardano_getChangeAddress",B.e,t.N)},
M(a){return this.i("cardano_signTransaction",A.B(A.j(a)),t.c)},
bh(a){return this.i("cardano_signAndSendTransaction",A.B(A.j(a)),t.c)},
F(a){return this.i("cardano_signMessage",A.b([A.d(a)],t.O),t.K)},
dJ(){return this.ai("cardano_getExtensions",B.e,t.c)},
f6(a){return this.C("cardano_submitTx",A.b([A.k(a)],t.s),B.e,t.N)},
fL(a){return this.i("cardano_submitTx",A.b([A.k(a)],t.s),t.N)},
gH(){return B.D}}
A.dI.prototype={
$1(a){var s
A.d(a)
s=this.a.c
s===$&&A.mK("_api")
return A.a4(s,"api: ",t.K)},
$S:1}
A.bB.prototype={
d9(a){return this.i("wallet_switchAptosChain",A.b([A.j(a)],t.f),t.K)},
F(a){var s=t.K
return A.Z(this.P("aptos_signMessage",A.b([A.j(a)],t.f),s).af(new A.dK(),s),s)},
M(a){var s=t.K
return A.Z(this.P("aptos_signTransaction",A.b([A.kF(A.j(a))],t.f),s).af(new A.dL(),s),s)},
c2(a){var s,r,q
A.A(a)
s=a!=null?A.a3(a):null
r=A.b([],t.s)
if(s!=null)r.push(s)
q=t.K
return A.Z(this.P("aptos_requestAccounts",r,q).af(new A.dJ(),q),q)},
eu(){return this.c2(null)},
ec(){return this.ah("aptos_network",t.K)},
ee(a){var s
t.g.a(a)
s=this.c.k(0,B.h)
s.toString
B.a.n(s,a)
this.ac(A.bj(B.h))},
eg(a){var s
t.g.a(a)
s=this.c.k(0,B.j)
s.toString
B.a.n(s,a)
this.ac(A.bj(B.j))},
aI(a,b){var s,r,q=A.ad(t.u.a(a),t.g)
for(s=q.length,r=0;r<q.length;q.length===s||(0,A.av)(q),++r)q[r].call(null,b)},
az(a){var s,r,q,p,o,n,m,l=this
l.aZ(a)
s=A.d(a.data)
r=A.eE(s)
for(q=r.length,p=l.c,o=0;o<r.length;r.length===q||(0,A.av)(r),++o)switch(r[o]){case B.u:n=p.k(0,B.h)
n.toString
l.aI(n,A.F(s.account))
break
case B.t:m=s.chainChanged
if(m!=null){n=p.k(0,B.j)
n.toString
l.aI(n,m)}break}},
gH(){return B.A},
O(a){var s=this,r=s.ges(),q={}
q.connect=A.c(r)
q.version="1.0.0"
a["aptos:connect"]=q
q={}
q.signTransaction=A.c(s.gL())
q.version="1.0.0"
a["aptos:signTransaction"]=q
q={}
q.signMessage=A.c(s.gE())
q.version="1.0.0"
a["aptos:signMessage"]=q
q={}
q.account=A.c(r)
q.version="1.0.0"
a["aptos:account"]=q
q={}
q.onNetworkChange=A.c(s.gef())
q.version="1.0.0"
a["aptos:onNetworkChange"]=q
q={}
q.network=A.p(s.geb())
q.version="1.0.0"
a["aptos:network"]=q
q={}
q.onAccountChange=A.c(s.ged())
q.version="1.0.0"
a["aptos:onAccountChange"]=q
q={}
q.disconnect=A.p(s.gJ())
q.version="1.0.0"
a["aptos:disconnect"]=q
q={}
q.changeNetwork=A.c(s.gd8())
q.version="1.0.0"
a["aptos:changeNetwork"]=q
a["aptos:events"]=A.a2(A.r(s.gK()))}}
A.dK.prototype={
$1(a){var s
A.j(a)
if(A.hy(A.k(a.status))===B.r)return a
s=A.j(a.args)
A.hx(s)
return A.hz(s,t.K)},
$S:12}
A.dL.prototype={
$1(a){var s
A.j(a)
if(A.hy(A.k(a.status))===B.r)return a
s=A.j(a.args)
A.hx(s)
return A.hz(s,t.K)},
$S:12}
A.dJ.prototype={
$1(a){var s,r
A.j(a)
if(A.hy(A.k(a.status))===B.r)return a
s=A.d(A.j(a.args))
A.hx(A.d(s.publicKey))
r=t.m
s.publicKey=A.a4(A.d(s.publicKey),null,r)
return A.hz(s,r)},
$S:12}
A.bF.prototype={
O(a){var s=this
a["bitcoin:connect"]=A.iB(A.c(s.gv()))
a["bitcoin:signPersonalMessage"]=A.iE(A.c(s.gd4()))
a["bitcoin:signTransaction"]=A.iF(A.c(s.gd6()))
a["bitcoin:getAccountAddresses"]=A.iC(A.c(s.gb7()))
a["bitcoin:sendTransaction"]=A.iD(A.c(s.gd2()))
a["bitcoin:disconnect"]=A.ah(A.p(s.gJ()))
a["bitcoin:events"]=A.a2(A.r(s.gK()))},
p(a){var s=A.a3(A.A(a)),r=s==null?null:A.b([s],t.s)
return this.i("bitcoin_requestAccounts",r,t.m)},
A(){return this.p(null)},
d5(a){return this.i("bitcoin_signPersonalMessage",A.b([A.j(a)],t.f),t.K)},
d7(a){return this.i("bitcoin_signTransaction",A.b([A.j(a)],t.f),t.K)},
b8(a){return this.i("bitcoin_getAccountAddresses",A.b([A.j(a)],t.f),t.c)},
d3(a){return this.i("bitcoin_sendTransaction",A.B(t.c.a(a)),t.K)},
gH(){return B.C}}
A.bE.prototype={
O(a){var s=this
a["bch:connect"]=A.iB(A.c(s.gv()))
a["bch:signPersonalMessage"]=A.iE(A.c(s.gcZ()))
a["bch:signTransaction"]=A.iF(A.c(s.gd0()))
a["bch:getAccountAddresses"]=A.iC(A.c(s.gb7()))
a["bch:sendTransaction"]=A.iD(A.c(s.gcX()))
a["bch:disconnect"]=A.ah(A.p(s.gJ()))
a["bch:events"]=A.a2(A.r(s.gK()))},
p(a){var s=A.a3(A.A(a)),r=s==null?null:A.b([s],t.s)
return this.i("bch_requestAccounts",r,t.m)},
A(){return this.p(null)},
d_(a){return this.i("bch_signPersonalMessage",A.b([A.j(a)],t.f),t.K)},
d1(a){return this.i("bch_signTransaction",A.b([A.j(a)],t.f),t.K)},
b8(a){return this.i("bch_getAccountAddresses",A.b([A.j(a)],t.f),t.c)},
cY(a){return this.i("bch_sendTransaction",A.B(t.c.a(a)),t.K)},
gH(){return B.B}}
A.bJ.prototype={
cr(a){var s=A.a3(A.A(a)),r=s==null?null:A.b([s],t.s)
return this.i("cosmos_requestAccounts",r,t.m)},
fU(){return this.cr(null)},
F(a){return this.i("cosmos_signMessage",A.b([A.j(a)],t.f),t.K)},
cG(a){return this.i("cosmos_signTransactionDirect",A.b([A.j(a)],t.f),t.K)},
cE(a){return this.i("cosmos_signTransactionAmino",A.b([A.j(a)],t.f),t.K)},
bM(a,b){var s,r,q
A.k(a)
s=A.p(new A.dX(this,a))
r=A.r(new A.dY(this,a,b))
q={}
q.getAccounts=s
q.signDirect=r
return A.a4(q,null,t.K)},
bL(a){return this.bM(a,null)},
bQ(a,b){var s,r,q
A.k(a)
s=A.p(new A.dV(this,a))
r=A.r(new A.dW(this,a,b))
q={}
q.getAccounts=s
q.signAmino=r
return A.a4(q,null,t.K)},
bP(a){return this.bQ(a,null)},
c8(a,b){var s,r
A.k(a)
s=this.bL(a)
r={}
r.amino=this.bP(a)
r.direct=s
return A.a4(r,null,t.K)},
f3(a){return this.c8(a,null)},
dM(a){A.k(a)
throw A.f(A.hK(null))},
gH(){return B.E},
b0(a){return this.i("wallet_addCosmosChain",A.b([A.j(a)],t.f),t.y)},
M(a){return this.i("cosmos_signTransaction",A.b([A.j(a)],t.f),t.K)},
O(a){var s,r,q=this
if(q.c==null){s={}
s.getOfflineSigner=A.r(q.gbK())
s.getOfflineSignerOnlyAmino=A.r(q.gbO())
s.getOfflineSignerAuto=A.c(q.gbN())
r=A.a4(s,null,t.m)
q.c=s
q.d=r}r=v.G
r.cosmos=q.d
r.getOfflineSigner=A.r(q.gbK())
r.getOfflineSignerOnlyAmino=A.r(q.gbO())
r.getOfflineSignerAuto=A.c(q.gbN())
s={}
s.connect=A.c(q.gfT())
s.version="1.0.0"
a["cosmos:connect"]=s
a["cosmos:events"]=A.a2(A.r(q.gK()))
s={}
s.signer=A.r(q.gf2())
s.version="1.0.0"
a["cosmos:signer"]=s
s={}
s.signTransactionDirect=A.c(q.gcF())
s.version="1.0.0"
a["cosmos:signTransactionDirect"]=s
s={}
s.signTransactionAmino=A.c(q.gcD())
s.version="1.0.0"
a["cosmos:signTransactionAmino"]=s
s={}
s.addNewChain=A.c(q.gb_())
s.version="1.0.0"
a["cosmos:addNewChain"]=s
s={}
s.signMessage=A.c(q.gE())
s.version="1.0.0"
a["cosmos:signMessage"]=s
s={}
s.signTransaction=A.c(q.gL())
s.version="1.0.0"
a["cosmos:signTransaction"]=s
a["cosmos:disconnect"]=A.ah(A.p(q.gJ()))}}
A.dX.prototype={
$0(){return this.a.i("cosmos_requestAccounts",A.iO(A.b([this.b],t.s)),t.c)},
$S:4}
A.dY.prototype={
$2(a,b){var s
A.k(a)
s={}
s.signDoc=A.j(b)
s.signerAddress=a
s.chainId=this.b
s.signOption=this.c
return this.a.i("cosmos_signTransactionDirect",A.b([s],t.f),t.K)},
$S:22}
A.dV.prototype={
$0(){return this.a.i("cosmos_requestAccounts",A.iO(A.b([this.b],t.s)),t.c)},
$S:4}
A.dW.prototype={
$2(a,b){var s
A.k(a)
A.j(b)
s={}
s.signDoc=A.k(A.d(v.G.JSON).stringify(b))
s.signerAddress=a
s.chainId=this.b
s.signOption=this.c
return this.a.i("cosmos_signTransactionAmino",A.b([s],t.f),t.K)},
$S:22}
A.bM.prototype={
be(a){A.d(a)
return this.C(A.k(a.method),A.B(a.params),B.k,t.X)},
am(){var s,r,q,p,o,n,m,l,k=this,j=k.c
if(j==null){j=A.p(k.gdc())
r=A.c(k.gaM())
q=A.r(k.gcS())
p=A.r(k.gel())
o=A.p(k.gJ())
n={}
n.request=r
n.on=q
n.removeListener=p
n.disconnect=o
n.enable=j
n.connect=j
n.isOnChain=!0
k.c=n
j=n}m=A.a4(j,null,t.m)
s=m
try{v.G.ethereum=s}catch(l){A.d(v.G.console).error("failed to set ethereum ")}A.kw(s)},
dd(){return this.ai("eth_requestAccounts",B.k,t.c)},
p(a){var s=A.a3(A.A(a)),r=s==null?null:A.b([s],t.s)
return this.i("eth_requestAccounts",r,t.m)},
A(){return this.p(null)},
b0(a){return this.i("wallet_addEthereumChain",A.B(A.d(a)),t.N)},
eY(a){return this.i("eth_signTypedData",A.B(A.d(a)),t.N)},
f_(a){return this.i("eth_signTypedData_v3",A.B(A.d(a)),t.N)},
f1(a){return this.i("eth_signTypedData_v4",A.B(A.d(a)),t.N)},
ek(a){return this.i("personal_sign",A.B(A.d(a)),t.N)},
dt(a){return this.i("eth_sign",A.B(A.d(a)),t.N)},
Z(a){return this.i("eth_sendTransaction",A.B(A.d(a)),t.N)},
O(a){var s,r=this
r.am()
s={}
s.connect=A.c(r.gv())
s.version="1.0.0"
a["ethereum:connect"]=s
s={}
s.addNewChain=A.c(r.gb_())
s.version="1.0.0"
a["ethereum:addNewChain"]=s
s={}
s.signTypedData=A.c(r.geX())
s.version="1.0.0"
a["ethereum:signTypedData"]=s
s={}
s.signTypedDataV3=A.c(r.geZ())
s.version="1.0.0"
a["ethereum:signTypedDataV3"]=s
s={}
s.signTypedDataV4=A.c(r.gf0())
s.version="1.0.0"
a["ethereum:signTypedDataV4"]=s
s={}
s.personalSign=A.c(r.gej())
s.version="1.0.0"
a["ethereum:personalSign"]=s
s={}
s.ethSign=A.c(r.gds())
s.version="1.0.0"
a["ethereum:ethSign"]=s
s={}
s.sendTransaction=A.c(r.gY())
s.version="1.0.0"
a["ethereum:sendTransaction"]=s
s={}
s.request=A.c(r.gaM())
s.version="1.0.0"
a["ethereum:request"]=s
a["ethereum:events"]=A.a2(A.r(r.gK()))
a["ethereum:disconnect"]=A.ah(A.p(r.gJ()))},
az(a){var s,r,q,p,o,n,m,l,k,j=this,i=null
j.aZ(a)
s=A.d(a.data)
r=A.eE(s)
for(q=r.length,p=t.g,o=0;o<r.length;r.length===q||(0,A.av)(r),++o)switch(r[o]){case B.u:n=j.c
if(n!=null){m=A.F(s.account)
m=m==null?i:A.k(m.address)
n.selectedAddress=m}break
case B.P:j.ak(B.c,s.message)
j.bG(B.c,s.message)
break
case B.O:n=A.F(s.networkAccounts)
j.ak(B.h,n==null?i:A.iz(n))
break
case B.t:l=A.F(s.chainChanged)
n=j.c
if(n!=null){m=l==null?i:A.k(l.chainId)
n.chainId=m}n=j.c
if(n!=null){m=l==null?i:A.k(l.netVersion)
n.networkVersion=m}if(s.disconnect!=null)j.ak(B.n,s.disconnect)
n=l!=null
if(n){if(s.disconnect==null)j.ak(B.l,l)
j.ak(B.j,A.k(l.chainId))}m=j.c
k=m==null?i:m.autoRefreshOnNetworkChange
if(k!=null&&n){n=A.it(k,"Function")
if(n){p.a(k)
k.call(k,A.k(l.chainId))}}break}},
ak(a,b){var s,r,q
if(b==null||!this.d.a3(a))return
s=this.d.k(0,a)
s.toString
s=A.ad(s,t.g)
for(r=s.length,q=0;q<s.length;s.length===r||(0,A.av)(s),++q)s[q].call(null,b)},
cT(a,b){var s,r,q
A.k(a)
t.g.a(b)
s=A.bQ(a)
r=this.d
q=r.k(0,s)
if(s==null||q==null)return
if(B.a.fR(q,new A.e3(b))||B.a.T(q,b))return
r=r.k(0,s)
if(r!=null)B.a.n(r,b)
this.ac(A.bj(s))},
em(a,b){var s
A.k(a)
t.g.a(b)
s=this.d.k(0,A.bQ(a))
if(s!=null)B.a.ae(s,b)},
gH(){return B.F}}
A.e3.prototype={
$1(a){return t.g.a(a)===this.a},
$S:60}
A.bZ.prototype={
O(a){var s=this,r={}
r.signAndSendTransaction=A.c(s.gY())
r.version="1.0.0"
a["monero:signAndSendTransaction"]=r
r={}
r.signMessage=A.c(s.gE())
r.version="1.0.0"
a["monero:signMessage"]=r
r={}
r.connect=A.c(s.gv())
r.version="1.0.0"
a["monero:connect"]=r
a["monero:events"]=A.a2(A.r(s.gK()))
a["monero:disconnect"]=A.ah(A.p(s.gJ()))},
p(a){var s=A.a3(A.A(a)),r=s==null?null:A.b([s],t.s)
return this.i("monero_requestAccounts",r,t.m)},
A(){return this.p(null)},
Z(a){return this.i("monero_signAndSendTransaction",A.b([A.j(a)],t.f),t.K)},
F(a){return this.i("monero_signMessage",A.b([A.d(a)],t.O),t.K)},
gH(){return B.G}}
A.c9.prototype={
O(a){var s=this,r={}
r.signAndSendTransaction=A.c(s.gY())
r.version="1.0.0"
a["xrpl:signAndSendTransaction"]=r
r={}
r.signTransaction=A.c(s.gL())
r.version="1.0.0"
a["xrpl:signTransaction"]=r
r={}
r.signMessage=A.c(s.gE())
r.version="1.0.0"
a["xrpl:signMessage"]=r
r={}
r.connect=A.c(s.gv())
r.version="1.0.0"
a["xrpl:connect"]=r
a["xrpl:events"]=A.a2(A.r(s.gK()))
a["xrpl:disconnect"]=A.ah(A.p(s.gJ()))},
p(a){var s=A.a3(A.A(a)),r=s==null?null:A.b([s],t.s)
return this.i("xrpl_requestAccounts",r,t.m)},
A(){return this.p(null)},
M(a){return this.i("xrpl_signTransaction",A.b([A.j(a)],t.f),t.K)},
Z(a){return this.i("xrpl_signAndSendTransaction",A.b([A.j(a)],t.f),t.K)},
F(a){return this.i("xrpl_signMessage",A.b([A.d(a)],t.O),t.K)},
gH(){return B.N}}
A.cb.prototype={
O(a){var s=this,r=A.c(s.gbg()),q=A.c(s.geM()),p=A.c(s.gew()),o=A.c(s.gE()),n=$.jO(),m={}
m.signAllTransactions=p
m.version="1.0.0"
m.supportedTransactionVersions=n
a["solana:signAllTransactions"]=m
m={}
m.signTransaction=q
m.version="1.0.0"
m.supportedTransactionVersions=n
a["solana:signTransaction"]=m
m={}
m.signAndSendTransaction=r
m.version="1.0.0"
m.supportedTransactionVersions=n
a["solana:signAndSendTransaction"]=m
m={}
m.signMessage=o
m.version="1.0.0"
a["solana:signMessage"]=m
m={}
m.signAndSendAllTransactions=A.r(s.geC())
m.version="1.0.0"
m.supportedTransactionVersions=n
a["solana:signAndSendAllTransactions"]=m
a["solana:events"]=A.a2(A.r(s.gK()))
m={}
m.connect=A.c(s.gv())
m.version="1.0.0"
a["solana:connect"]=m
m={}
m.signIn=A.c(s.geG())
m.version="1.0.0"
a["solana:signIn"]=m
a["solana:disconnect"]=A.ah(A.p(s.gJ()))},
p(a){var s=A.a3(A.A(a)),r=s==null?null:A.b([s],t.s)
return this.i("solana_requestAccounts",r,t.m)},
A(){return this.p(null)},
eH(a){var s=t.m
return A.Z(this.P("solana_signIn",A.B(A.d(a)),s),s)},
F(a){var s=t.c
return A.Z(this.P("solana_signMessage",A.B(A.d(a)),s),s)},
eN(a){var s=t.c
return A.Z(this.P("solana_signTransaction",A.B(A.j(a)),s),s)},
ex(a){var s=t.c
return A.Z(this.P("solana_signAllTransactions",A.B(A.j(a)),s),s)},
bh(a){return this.i("solana_signAndSendTransaction",A.B(A.d(a)),t.c)},
c4(a,b){var s,r=t.c
r.a(a)
A.F(b)
s=A.B(a)
return this.i("solana_signAndSendAllTransactions",s,r)},
eD(a){return this.c4(a,null)},
gH(){return B.H}}
A.cd.prototype={
O(a){var s=this,r={}
r.signAndSendTransaction=A.c(s.gY())
r.version="1.0.0"
a["stellar:signAndSendTransaction"]=r
r={}
r.signTransaction=A.c(s.gL())
r.version="1.0.0"
a["stellar:signTransaction"]=r
r={}
r.signMessage=A.c(s.gE())
r.version="1.0.0"
a["stellar:signMessage"]=r
a["stellar:connect"]=A.ix(A.c(s.gv()))
a["stellar:events"]=A.a2(A.r(s.gK()))
a["stellar:disconnect"]=A.ah(A.p(s.gJ()))},
p(a){var s=A.a3(A.A(a)),r=s==null?null:A.b([s],t.s)
return this.i("stellar_requestAccounts",r,t.m)},
A(){return this.p(null)},
M(a){return this.i("stellar_signTransaction",A.b([A.j(a)],t.f),t.K)},
Z(a){return this.i("stellar_sendTransaction",A.b([A.j(a)],t.f),t.K)},
F(a){return this.i("stellar_signMessage",A.b([A.d(a)],t.O),t.K)},
gH(){return B.I}}
A.cf.prototype={
O(a){var s,r=this
r.e1()
s={}
s.signTransaction=A.c(r.gbu())
s.version="1.0.0"
a["polkadot:signTransaction"]=s
s={}
s.signMessage=A.c(r.gbt())
s.version="1.0.0"
a["polkadot:signMessage"]=s
s={}
s.addNewChain=A.c(r.gbX())
s.version="1.0.0"
a["polkadot:addNewChain"]=s
s={}
s.connect=A.c(r.gv())
s.version="1.0.0"
a["polkadot:connect"]=s
a["polkadot:events"]=A.a2(A.r(r.gK()))
a["polkadot:disconnect"]=A.ah(A.p(r.gJ()))},
e1(){var s,r,q,p,o=this,n=null,m=o.d
if(m==null){s={}
r={}
q={}
p={}
q.signPayload=A.c(o.gbu())
q.signRaw=A.c(o.gbt())
q.update=A.c(o.ghh())
s.get=A.c(o.ge4())
s.provide=A.c(o.gbX())
r.get=A.c(o.gde())
r.subscribe=A.c(o.ge6())
m=t.m
p.metadata=A.a4(s,n,m)
p.accounts=A.a4(r,n,m)
p.signer=A.a4(q,n,m)
m=o.gaj()
p.connect=A.c(m)
p.enable=A.c(m)
p.name="OnChain"
p.version="0.4.0"
m=o.d=new A.aS(n,p,A.b([],t.s),t.p)}if(o.e==null)o.e=A.h9(v.G.Proxy,[m.b,new A.f7(o).$0()],t.m)
m=v.G
if(A.F(m.injectedWeb3)==null)m.injectedWeb3={}
A.d(m.injectedWeb3)["0"]=o.e
m.substrate=o.e},
bW(a){A.ak(a)
return this.ah("polkadot_knownMetadata",t.m)},
e5(){return this.bW(null)},
e8(a){return this.i("wallet_addPolkadotChain",A.b([A.d(a)],t.O),t.y)},
cI(a){return this.i("polkadot_signTransaction",A.b([A.d(a)],t.O),t.m)},
cH(a){return this.i("polkadot_signMessage",A.b([A.d(a)],t.O),t.m)},
p(a){var s=A.a3(A.A(a)),r=s==null?null:A.b([s],t.s)
return this.i("polkadot_requestAccounts",r,t.m)},
A(){return this.p(null)},
bD(a){var s=t.c
return A.Z(this.hj("polkadot_requestAccounts",t.m).af(new A.f1(),s),s)},
df(){return this.bD(null)},
aT(a){throw A.f($.ia())},
hi(){return this.aT(null)},
aJ(a){A.k(a)
return A.Z(new A.f2(this).$0(),t.B)},
e7(a){var s
t.g.a(a)
s=this.c.k(0,B.h)
s.toString
B.a.n(s,a)
this.ac(A.bj(B.h))},
gH(){return B.J}}
A.f3.prototype={
$0(){return this.a.a},
$S:21}
A.f4.prototype={
$0(){return this.a.b},
$S:20}
A.f5.prototype={
$0(){return this.a.c},
$S:19}
A.f6.prototype={
$1(a){this.a.sbp(t.a.a(a))},
$S:17}
A.f7.prototype={
$0(){var s,r,q,p,o,n,m=this.a.d
m.toString
s=v.G
r=A.d(s.Object)
q=A.d(r.create.apply(r,[null]))
q.set=A.hX(m.gaW())
q.get=A.hW(m.gaV())
r=A.d(s.Object)
p=A.d(r.create.apply(r,[null]))
p.get=A.p(new A.f3(m))
r=A.d(s.Object)
r.defineProperty.apply(r,[q,"debugKey",p])
r=A.d(s.Object)
o=A.d(r.create.apply(r,[null]))
o.get=A.p(new A.f4(m))
r=A.d(s.Object)
r.defineProperty.apply(r,[q,"object",o])
r=A.d(s.Object)
n=A.d(r.create.apply(r,[null]))
n.get=A.p(new A.f5(m))
n.set=A.c(new A.f6(m))
s=A.d(s.Object)
s.defineProperty.apply(s,[q,"probs",n])
return q},
$S:10}
A.f1.prototype={
$1(a){return t.c.a(A.d(a).accounts)},
$S:64}
A.f2.prototype={
$0(){var s=0,r=A.ao(t.B),q,p=this
var $async$$0=A.ap(function(a,b){if(a===1)return A.al(b,r)
while(true)switch(s){case 0:q=p.a.e
s=1
break
case 1:return A.am(q,r)}})
return A.an($async$$0,r)},
$S:65}
A.cg.prototype={
F(a){return this.i("sui_signMessage",A.b([A.j(a)],t.f),t.K)},
eL(a){return this.i("sui_signPersonalMessage",A.b([A.j(a)],t.f),t.K)},
a7(a,b,c){A.mq(c,t.K,"T","_signTransction_")
return this.eS(a,b,c,c)},
eS(a,b,c,d){var s=0,r=A.ao(d),q,p=this,o,n
var $async$a7=A.ap(function(e,f){if(e===1)return A.al(f,r)
while(true)switch(s){case 0:o=a
n=A
s=3
return A.aV(A.ez(b),$async$a7)
case 3:q=p.P(o,n.b([f],t.f),c)
s=1
break
case 1:return A.am(q,r)}})
return A.an($async$a7,r)},
M(a){var s=t.K
return A.Z(this.a7("sui_signTransaction",A.j(a),s),s)},
eB(a){var s=t.K
return A.Z(this.a7("sui_signAndExecuteTransaction",A.j(a),s),s)},
ez(a){var s=t.K
return A.Z(this.a7("sui_signAndExecuteTransactionBlock",A.j(a),s),s)},
eP(a){var s=t.K
return A.Z(this.a7("sui_signTransactionBlock",A.j(a),s),s)},
er(a){A.j(a)
return A.kz(A.kA(B.U,t.z))},
gH(){return B.K},
p(a){var s=A.a3(A.A(a)),r=s==null?null:A.b([s],t.s)
return this.i("sui_requestAccounts",r,t.m)},
A(){return this.p(null)},
O(a){var s=this,r={}
r.signTransaction=A.c(s.gL())
r.version="1.0.0"
a["sui:signTransaction"]=r
r={}
r.connect=A.c(s.gv())
r.version="1.0.0"
a["sui:connect"]=r
r={}
r.signTransactionBlock=A.c(s.geO())
r.version="1.0.0"
a["sui:signTransactionBlock"]=r
r={}
r.signAndExecuteTransactionBlock=A.c(s.gey())
r.version="1.0.0"
a["sui:signAndExecuteTransactionBlock"]=r
r={}
r.signAndExecuteTransaction=A.c(s.geA())
r.version="2.0.0"
a["sui:signAndExecuteTransaction"]=r
r={}
r.signPersonalMessage=A.c(s.geK())
r.version="1.0.0"
a["sui:signPersonalMessage"]=r
r={}
r.signMessage=A.c(s.gE())
r.version="1.0.0"
a["sui:signMessage"]=r
r={}
r.reportTransactionEffects=A.c(s.geq())
r.version="1.0.0"
a["sui:reportTransactionEffects"]=r
r={}
r.disconnect=A.p(s.gJ())
r.version="1.0.0"
a["sui:disconnect"]=r
a["sui:events"]=A.a2(A.r(s.gK()))}}
A.ch.prototype={
O(a){var s=this,r={}
r.signAndSendTransaction=A.c(s.gY())
r.version="1.0.0"
a["ton:signAndSendTransaction"]=r
r={}
r.signTransaction=A.c(s.gL())
r.version="1.0.0"
a["ton:signTransaction"]=r
r={}
r.signMessage=A.c(s.gE())
r.version="1.0.0"
a["ton:signMessage"]=r
r={}
r.connect=A.c(s.gv())
r.version="1.0.0"
a["ton:connect"]=r
a["ton:disconnect"]=A.ah(A.p(s.gJ()))
a["ton:events"]=A.a2(A.r(s.gK()))},
p(a){var s=A.a3(A.A(a)),r=s==null?null:A.b([s],t.s)
return this.i("ton_requestAccounts",r,t.m)},
A(){return this.p(null)},
M(a){return this.i("ton_signTransaction",A.b([A.d(a)],t.O),t.K)},
Z(a){return this.i("ton_sendTransaction",A.b([A.d(a)],t.O),t.K)},
F(a){return this.i("ton_signMessage",A.b([A.d(a)],t.O),t.K)},
gH(){return B.L}}
A.ci.prototype={
am(){var s,r,q,p,o,n,m,l,k=this,j=null,i=v.G,h=new i.TronWeb("https://api.shasta.trongrid.io","https://api.shasta.trongrid.io","https://api.shasta.trongrid.io"),g=k.e,f=A.b([],t.s),e=t.m,d=A.h9(i.Proxy,[g,new A.fc(new A.aS(j,g,f,t.p)).$0()],e)
A.d(h.trx).sign=A.r(k.geQ())
A.d(h.trx).signMessageV2=A.r(k.geI())
A.d(h.trx).multiSign=A.r(k.ge9())
f=k.gdj()
h.setPrivateKey=A.c(f)
h.setAddress=A.c(f)
h.setFullNode=A.c(f)
h.setSolidityNode=A.c(f)
h.setHeader=A.c(f)
h.setFullNodeHeader=A.c(f)
h.setDefaultBlock=A.c(f)
h.defaultPrivateKey=""
h.defaultAddress=d
f=t.K
g=A.a4(h,j,f)
s=A.c(k.gaM())
r=A.r(k.gcU())
q=A.p(k.gaj())
p=A.r(k.geo())
o=A.p(k.gJ())
n={}
n.dappIcon=""
n.dappName=""
n.openTronLinkAppOnMobile=!0
n.openUrlWhenWalletNotFound=!0
m={}
m.config=n
m.request=s
m.on=r
m.removeListener=p
m.tronWeb=g
m.enable=q
m.connect=q
m.ready=!0
m.disconnect=o
l=A.d(i.Object.freeze(m))
i.tronLink=A.a4(l,j,e)
i.tronWeb=A.a4(h,j,f)
i.tron=A.a4(l,j,e)
k.c=l
k.d=h},
dk(a){throw A.f($.ia())},
c5(a,b){A.j(a)
if(b!=null)A.hT(b)
return this.C("tron_signMessageV2",A.b([a],t.f),B.k,t.N)},
eJ(a){return this.c5(a,null)},
c6(a,b){A.j(a)
if(b!=null)A.hT(b)
return this.C("tron_signTransaction",A.b([a],t.f),B.k,t.m)},
eR(a){return this.c6(a,null)},
bZ(a,b){A.j(a)
if(b!=null)A.hT(b)
return this.C("tron_signTransaction",A.b([a],t.f),B.k,t.X)},
ea(a){return this.bZ(a,null)},
al(a,b){var s,r,q
if(b==null||!this.f.a3(a))return
s=this.f.k(0,a)
s.toString
s=A.ad(s,t.g)
for(r=s.length,q=0;q<s.length;s.length===r||(0,A.av)(s),++q)s[q].call(null,b)},
cV(a,b){var s,r
A.k(a)
t.g.a(b)
s=A.bQ(a)
if(s==null)return
r=this.f.k(0,s)
if(r!=null)B.a.n(r,b)
this.ac(A.bj(s))},
ep(a,b){var s
A.k(a)
t.g.a(b)
s=this.f.k(0,A.bQ(a))
if(s!=null)B.a.ae(s,b)},
b3(){return this.ai("tron_requestAccounts",B.k,t.c)},
be(a){A.d(a)
return this.C(A.k(a.method),A.B(a.params),B.k,t.X)},
gH(){return B.M},
az(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=null
c.aZ(a)
s=A.d(a.data)
r=A.eE(s)
for(q=r.length,p=v.G,o=t.N,n=t.B,m=t.X,l=t.z,k=c.e,j=0;j<r.length;r.length===q||(0,A.av)(r),++j)switch(r[j]){case B.u:i=A.F(s.account)
h=c.c
g=h==null
f=g?b:A.A(h.selectedAddress)
e=i==null
if(f!=(e?b:A.k(i.address))){if(!g){g=e?b:A.k(i.address)
h.selectedAddress=g}h=e?b:A.k(i.address)
if(h==null)h=!1
k.base58=h
h=e?b:A.k(i.hex)
if(h==null)h=!1
k.hex=h
A.d(p.window).postMessage(A.hi(A.E(["message",A.E(["action","accountsChanged","data",i],o,m),"source","contentScript"],o,l)))}break
case B.P:c.al(B.c,s.message)
break
case B.O:h=A.F(s.networkAccounts)
c.al(B.h,h==null?b:A.iz(h))
break
case B.t:d=A.F(s.chainChanged)
h=c.c
if(h!=null){g=d==null?b:A.k(d.chainId)
h.chainId=g}h=c.c
if(h!=null){g=d==null?b:A.k(d.netVersion)
h.networkVersion=g}if(s.disconnect!=null)c.al(B.n,s.disconnect)
if(d!=null){if(s.disconnect==null){c.al(B.l,d)
A.d(p.window).postMessage(A.hi(A.E(["message",A.E(["action","connect","data",null],o,m),"source","contentScript"],o,l)))}h=A.k(d.fullNode)
g=c.d
if(g!=null)g.fullNode=new p.TronWeb.providers.HttpProvider(h)
g=c.d
if(g!=null)g.solidityNode=new p.TronWeb.providers.HttpProvider(h)
g=c.d
if(g!=null)g.setEventServer(new p.TronWeb.providers.HttpProvider(h))
c.al(B.j,A.k(d.chainId))
A.d(p.window).postMessage(A.hi(A.E(["message",A.E(["action","setNode","data",A.E(["node",d],o,n)],o,m),"source","contentScript"],o,l)))}break}},
p(a){var s=A.a3(A.A(a)),r=s==null?null:A.b([s],t.s)
return this.i("tron_requestAccounts",r,t.m)},
A(){return this.p(null)},
F(a){return this.i("tron_signMessageV2",A.b([A.d(a)],t.O),t.m)},
M(a){return this.i("tron_signTransaction",A.b([A.d(a)],t.O),t.m)},
O(a){var s,r,q=this
q.am()
s={}
s.connect=A.c(q.gv())
s.version="1.0.0"
a["tron:connect"]=s
s={}
s.signMessage=A.c(q.gE())
s.version="1.0.0"
a["tron:signMessage"]=s
r=q.gL()
a["tron:signTransaction"]=A.iU(A.c(r))
a["tron:signTransaction"]=A.iU(A.c(r))
a["tron:disconnect"]=A.ah(A.p(q.gJ()))
a["tron:events"]=A.a2(A.r(q.gK()))}}
A.f8.prototype={
$0(){return this.a.a},
$S:21}
A.f9.prototype={
$0(){return this.a.b},
$S:20}
A.fa.prototype={
$0(){return this.a.c},
$S:19}
A.fb.prototype={
$1(a){this.a.sbp(t.a.a(a))},
$S:17}
A.fc.prototype={
$0(){var s,r,q,p=this.a,o=v.G,n=A.d(o.Object),m=A.d(n.create.apply(n,[null]))
m.set=A.hX(p.gaW())
m.get=A.hW(p.gaV())
n=A.d(o.Object)
s=A.d(n.create.apply(n,[null]))
s.get=A.p(new A.f8(p))
n=A.d(o.Object)
n.defineProperty.apply(n,[m,"debugKey",s])
n=A.d(o.Object)
r=A.d(n.create.apply(n,[null]))
r.get=A.p(new A.f9(p))
n=A.d(o.Object)
n.defineProperty.apply(n,[m,"object",r])
n=A.d(o.Object)
q=A.d(n.create.apply(n,[null]))
q.get=A.p(new A.fa(p))
q.set=A.c(new A.fb(p))
o=A.d(o.Object)
o.defineProperty.apply(o,[m,"probs",q])
return m},
$S:10}
A.eF.prototype={
$1(a){return A.k(a)},
$S:28}
A.eG.prototype={
$1(a){return A.kI(A.k(a))},
$S:68}
A.eB.prototype={
$1(a){return A.k(A.d(a).address)},
$S:69};(function aliases(){var s=J.aQ.prototype
s.cK=s.j
s=A.N.prototype
s.aZ=s.az})();(function installTearOffs(){var s=hunkHelpers._static_1,r=hunkHelpers._static_0,q=hunkHelpers.installInstanceTearOff,p=hunkHelpers._instance_1u,o=hunkHelpers._instance_2u,n=hunkHelpers._instance_0u
s(A,"mn","le",15)
s(A,"mo","lf",15)
s(A,"mp","lg",15)
r(A,"jA","mi",3)
var m
q(m=A.aS.prototype,"gaW",0,4,null,["$4"],["cC"],55,0,0)
q(m,"gaV",0,3,null,["$3"],["cB"],51,0,0)
p(m=A.d4.prototype,"ghb","aR",11)
p(m,"geh","ei",11)
o(m=A.d5.prototype,"gK","bd",43)
q(m,"gv",0,0,null,["$1","$0"],["p","A"],5,0,0)
n(m=A.N.prototype,"gJ","dl",4)
o(m,"gK","bd",9)
q(m=A.bA.prototype,"gft",0,0,null,["$1","$0"],["cg","fu"],5,0,0)
q(m,"gdR",0,0,null,["$1","$0"],["bT","dS"],2,0,0)
p(m,"gdG","dH",6)
p(m,"gf9","fa",6)
p(m,"gfO","fP",6)
q(m,"gdP",0,0,null,["$1","$0"],["bS","dQ"],5,0,0)
q(m,"gfq",0,0,null,["$1","$0"],["cf","fs"],5,0,0)
q(m,"geT",0,1,null,["$2","$1"],["c7","eU"],30,0,0)
q(m,"gfc",0,0,null,["$1","$0"],["cc","fd"],5,0,0)
q(m,"gdw",0,0,null,["$1","$0"],["bH","dz"],5,0,0)
q(m,"gv",0,0,null,["$1","$0"],["p","A"],2,0,0)
q(m,"gaj",0,0,null,["$1","$0"],["aJ","b3"],2,0,0)
n(m,"ge2","e3",4)
n(m,"gfm","fn",4)
n(m,"gdK","dL",4)
q(m,"gdX",0,0,null,["$2","$0","$1"],["b9","dY","dZ"],29,0,0)
p(m,"gfe","ff",1)
q(m,"gfB",0,0,null,["$2","$0","$1"],["bk","fC","fD"],29,0,0)
n(m,"gfg","fh",4)
n(m,"gdA","dB",4)
q(m,"gfz",0,0,null,["$1","$0"],["cj","fA"],5,0,0)
q(m,"gdV",0,0,null,["$1","$0"],["bV","dW"],5,0,0)
q(m,"gdT",0,0,null,["$1","$0"],["bU","dU"],5,0,0)
q(m,"gfv",0,0,null,["$1","$0"],["ci","fw"],5,0,0)
q(m,"gfo",0,0,null,["$1","$0"],["ce","fp"],5,0,0)
q(m,"gdN",0,0,null,["$1","$0"],["bR","dO"],5,0,0)
q(m,"gfk",0,0,null,["$1","$0"],["cd","fl"],5,0,0)
q(m,"gdE",0,0,null,["$1","$0"],["bJ","dF"],5,0,0)
q(m,"gfG",0,1,null,["$2","$1"],["ck","fH"],30,0,0)
p(m,"geV","eW",8)
p(m,"gf7","f8",8)
p(m,"gfI","fJ",8)
p(m,"gfM","fN",8)
o(m,"gfE","fF",54)
o(m,"geE","eF",22)
n(m,"gfi","fj",4)
n(m,"gdC","dD",4)
p(m,"gL","M",0)
p(m,"gbg","bh",0)
p(m,"gE","F",1)
n(m,"gdI","dJ",4)
p(m,"gf5","f6",6)
p(m,"gfK","fL",6)
p(m=A.bB.prototype,"gd8","d9",0)
p(m,"gE","F",0)
p(m,"gL","M",0)
q(m,"ges",0,0,null,["$1","$0"],["c2","eu"],2,0,0)
n(m,"geb","ec",4)
p(m,"ged","ee",14)
p(m,"gef","eg",14)
q(m=A.bF.prototype,"gv",0,0,null,["$1","$0"],["p","A"],2,0,0)
p(m,"gd4","d5",0)
p(m,"gd6","d7",0)
p(m,"gb7","b8",0)
p(m,"gd2","d3",8)
q(m=A.bE.prototype,"gv",0,0,null,["$1","$0"],["p","A"],2,0,0)
p(m,"gcZ","d_",0)
p(m,"gd0","d1",0)
p(m,"gb7","b8",0)
p(m,"gcX","cY",8)
q(m=A.bJ.prototype,"gfT",0,0,null,["$1","$0"],["cr","fU"],2,0,0)
p(m,"gE","F",0)
p(m,"gcF","cG",0)
p(m,"gcD","cE",0)
q(m,"gbK",0,1,null,["$2","$1"],["bM","bL"],25,0,0)
q(m,"gbO",0,1,null,["$2","$1"],["bQ","bP"],25,0,0)
q(m,"gf2",0,1,null,["$2","$1"],["c8","f3"],25,0,0)
p(m,"gbN","dM",6)
p(m,"gb_","b0",0)
p(m,"gL","M",0)
p(m=A.bM.prototype,"gaM","be",1)
n(m,"gdc","dd",4)
q(m,"gv",0,0,null,["$1","$0"],["p","A"],2,0,0)
p(m,"gb_","b0",1)
p(m,"geX","eY",1)
p(m,"geZ","f_",1)
p(m,"gf0","f1",1)
p(m,"gej","ek",1)
p(m,"gds","dt",1)
p(m,"gY","Z",1)
o(m,"gcS","cT",9)
o(m,"gel","em",9)
q(m=A.bZ.prototype,"gv",0,0,null,["$1","$0"],["p","A"],2,0,0)
p(m,"gY","Z",0)
p(m,"gE","F",1)
q(m=A.c9.prototype,"gv",0,0,null,["$1","$0"],["p","A"],2,0,0)
p(m,"gL","M",0)
p(m,"gY","Z",0)
p(m,"gE","F",1)
q(m=A.cb.prototype,"gv",0,0,null,["$1","$0"],["p","A"],2,0,0)
p(m,"geG","eH",1)
p(m,"gE","F",1)
p(m,"geM","eN",0)
p(m,"gew","ex",0)
p(m,"gbg","bh",1)
q(m,"geC",0,1,null,["$2","$1"],["c4","eD"],61,0,0)
q(m=A.cd.prototype,"gv",0,0,null,["$1","$0"],["p","A"],2,0,0)
p(m,"gL","M",0)
p(m,"gY","Z",0)
p(m,"gE","F",1)
q(m=A.cf.prototype,"ge4",0,0,null,["$1","$0"],["bW","e5"],62,0,0)
p(m,"gbX","e8",1)
p(m,"gbu","cI",1)
p(m,"gbt","cH",1)
q(m,"gv",0,0,null,["$1","$0"],["p","A"],2,0,0)
q(m,"gde",0,0,null,["$1","$0"],["bD","df"],26,0,0)
q(m,"ghh",0,0,null,["$1","$0"],["aT","hi"],26,0,0)
p(m,"gaj","aJ",6)
p(m,"ge6","e7",14)
p(m=A.cg.prototype,"gE","F",0)
p(m,"geK","eL",0)
p(m,"gL","M",0)
p(m,"geA","eB",0)
p(m,"gey","ez",0)
p(m,"geO","eP",0)
p(m,"geq","er",0)
q(m,"gv",0,0,null,["$1","$0"],["p","A"],2,0,0)
q(m=A.ch.prototype,"gv",0,0,null,["$1","$0"],["p","A"],2,0,0)
p(m,"gL","M",1)
p(m,"gY","Z",1)
p(m,"gE","F",1)
p(m=A.ci.prototype,"gdj","dk",66)
q(m,"geI",0,1,null,["$2","$1"],["c5","eJ"],16,0,0)
q(m,"geQ",0,1,null,["$2","$1"],["c6","eR"],16,0,0)
q(m,"ge9",0,1,null,["$2","$1"],["bZ","ea"],16,0,0)
o(m,"gcU","cV",9)
o(m,"geo","ep",9)
n(m,"gaj","b3",4)
p(m,"gaM","be",1)
q(m,"gv",0,0,null,["$1","$0"],["p","A"],2,0,0)
p(m,"gE","F",1)
p(m,"gL","M",1)})();(function inheritance(){var s=hunkHelpers.mixin,r=hunkHelpers.inherit,q=hunkHelpers.inheritMany
r(A.h,null)
q(A.h,[A.hA,J.d1,A.ca,J.bC,A.l,A.bG,A.D,A.f0,A.b1,A.bY,A.cn,A.bL,A.G,A.bI,A.fd,A.eO,A.bN,A.cA,A.aM,A.aR,A.eJ,A.bW,A.bV,A.cz,A.d6,A.fA,A.dC,A.aj,A.dx,A.dB,A.fT,A.co,A.a8,A.br,A.aG,A.u,A.dt,A.dz,A.cG,A.cu,A.w,A.bH,A.cV,A.h0,A.fY,A.J,A.cW,A.cY,A.fC,A.dg,A.cc,A.fD,A.e6,A.d0,A.X,A.P,A.dA,A.bo,A.eN,A.fQ,A.e0,A.dS,A.fu,A.fw,A.eX,A.fP,A.eZ,A.e1,A.dD,A.aS,A.dh,A.em,A.d5,A.N,A.eP])
q(J.d1,[J.bP,J.bS,J.I,J.bf,J.bg,J.bT,J.be])
q(J.I,[J.aQ,J.q,A.b2,A.c2])
q(J.aQ,[J.di,J.cj,J.H])
r(J.d2,A.ca)
r(J.eA,J.q)
q(J.bT,[J.bR,J.d3])
q(A.l,[A.bq,A.n,A.aB,A.cm])
r(A.cH,A.bq)
r(A.cr,A.cH)
r(A.ax,A.cr)
q(A.D,[A.bh,A.aD,A.d7,A.dq,A.dl,A.dw,A.cO,A.ag,A.ck,A.dp,A.bn,A.cU])
q(A.n,[A.M,A.aZ,A.b0,A.az,A.ct])
q(A.M,[A.ce,A.Y,A.c8])
r(A.bK,A.aB)
r(A.bO,A.bI)
r(A.c4,A.aD)
q(A.aM,[A.cR,A.cS,A.dn,A.he,A.hg,A.fr,A.fq,A.h2,A.fN,A.fz,A.e7,A.hj,A.hm,A.hn,A.ha,A.dT,A.dU,A.f_,A.ff,A.fg,A.ej,A.ef,A.ek,A.e_,A.fm,A.fo,A.eV,A.eR,A.hk,A.eC,A.et,A.er,A.eq,A.eH,A.eo,A.ew,A.ex,A.dI,A.dK,A.dL,A.dJ,A.e3,A.f6,A.f1,A.fb,A.eF,A.eG,A.eB])
q(A.dn,[A.dm,A.bd])
q(A.aR,[A.ay,A.cs])
r(A.bU,A.ay)
q(A.cS,[A.hf,A.h3,A.h8,A.fO,A.eL,A.fy,A.e9,A.e8,A.fp,A.fn,A.dY,A.dW])
q(A.c2,[A.c_,A.bi])
q(A.bi,[A.cv,A.cx])
r(A.cw,A.cv)
r(A.c0,A.cw)
r(A.cy,A.cx)
r(A.c1,A.cy)
q(A.c0,[A.d9,A.da])
q(A.c1,[A.db,A.dc,A.dd,A.de,A.df,A.c3,A.b3])
r(A.bt,A.dw)
q(A.cR,[A.fs,A.ft,A.fU,A.ea,A.fE,A.fJ,A.fI,A.fG,A.fF,A.fM,A.fL,A.fK,A.h7,A.fS,A.h_,A.fZ,A.fv,A.ei,A.eh,A.ee,A.eg,A.el,A.eS,A.eT,A.eU,A.eW,A.eD,A.eu,A.es,A.eI,A.ep,A.en,A.ey,A.ev,A.dX,A.dV,A.f3,A.f4,A.f5,A.f7,A.f2,A.f8,A.f9,A.fa,A.fc])
q(A.br,[A.aF,A.cB])
r(A.dy,A.cG)
r(A.bs,A.cs)
r(A.cZ,A.bH)
r(A.cN,A.cZ)
q(A.cV,[A.fW,A.fV,A.fl,A.dr])
r(A.dO,A.fW)
r(A.dN,A.fV)
q(A.ag,[A.bm,A.d_])
q(A.fC,[A.bD,A.d8,A.aC,A.ds,A.aN,A.aO,A.W,A.ac,A.aP,A.L,A.c5])
q(A.dS,[A.dR,A.dQ,A.dZ,A.bc,A.eM])
r(A.cl,A.dD)
r(A.d4,A.em)
q(A.N,[A.bA,A.bB,A.bF,A.bE,A.bJ,A.bM,A.bZ,A.c9,A.cb,A.cd,A.cf,A.cg,A.ch,A.ci])
s(A.cH,A.w)
s(A.cv,A.w)
s(A.cw,A.G)
s(A.cx,A.w)
s(A.cy,A.G)
s(A.dD,A.e1)})()
var v={G:typeof self!="undefined"?self:globalThis,typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{e:"int",v:"double",ba:"num",m:"String",C:"bool",P:"Null",o:"List",h:"Object",aA:"Map",i:"JSObject"},mangledNames:{},types:["i(h)","i(i)","i([m?])","~()","i()","i([i?])","i(m)","0&()","i(q<h?>)","~(m,H)","h()","~(i)","h(h)","~(@)","~(H)","~(~())","i(h[h?])","~(o<m>)","h?(h?)","o<m>()","h?()","m?()","i(m,h)","m()","P(h)","i(m[h?])","i([h?])","@()","m(m)","i([m?,i?])","i(m[C?])","P(h,at)","P()","P(@)","e(e)","P(H,H)","@(@)","C(ac)","C(W)","C(aO)","C(aP)","C(aN)","Q<~>()","H?(m,H)","h?(~)","Q<i>()","o<e>()","e(e,e)","m(X<m,@>)","h(h,at)","m(e)","h?(h,h?,h?)","~(e,@)","P(@,at)","i(h,h)","C(h,h?,h?,h?)","P(~())","m(h)","@(m)","~(h?,h?)","C(H)","i(q<h?>[i?])","i([C?])","C(L)","q<h?>(i)","Q<i?>()","~(h?)","@(@,m)","W(m)","m(i)","C(X<m,@>)"],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti"),rttc:{}}
A.lz(v.typeUniverse,JSON.parse('{"H":"aQ","di":"aQ","cj":"aQ","mP":"b2","q":{"o":["1"],"I":[],"n":["1"],"i":[],"l":["1"]},"bP":{"C":[],"z":[]},"bS":{"z":[]},"I":{"i":[]},"aQ":{"I":[],"i":[]},"d2":{"ca":[]},"eA":{"q":["1"],"o":["1"],"I":[],"n":["1"],"i":[],"l":["1"]},"bC":{"T":["1"]},"bT":{"v":[],"ba":[]},"bR":{"v":[],"e":[],"ba":[],"z":[]},"d3":{"v":[],"ba":[],"z":[]},"be":{"m":[],"eQ":[],"z":[]},"bq":{"l":["2"]},"bG":{"T":["2"]},"cr":{"w":["2"],"o":["2"],"bq":["1","2"],"n":["2"],"l":["2"]},"ax":{"cr":["1","2"],"w":["2"],"o":["2"],"bq":["1","2"],"n":["2"],"l":["2"],"w.E":"2","l.E":"2"},"bh":{"D":[]},"n":{"l":["1"]},"M":{"n":["1"],"l":["1"]},"ce":{"M":["1"],"n":["1"],"l":["1"],"M.E":"1","l.E":"1"},"b1":{"T":["1"]},"aB":{"l":["2"],"l.E":"2"},"bK":{"aB":["1","2"],"n":["2"],"l":["2"],"l.E":"2"},"bY":{"T":["2"]},"Y":{"M":["2"],"n":["2"],"l":["2"],"M.E":"2","l.E":"2"},"cm":{"l":["1"],"l.E":"1"},"cn":{"T":["1"]},"aZ":{"n":["1"],"l":["1"],"l.E":"1"},"bL":{"T":["1"]},"c8":{"M":["1"],"n":["1"],"l":["1"],"M.E":"1","l.E":"1"},"bI":{"aA":["1","2"]},"bO":{"bI":["1","2"],"aA":["1","2"]},"c4":{"aD":[],"D":[]},"d7":{"D":[]},"dq":{"D":[]},"cA":{"at":[]},"aM":{"b_":[]},"cR":{"b_":[]},"cS":{"b_":[]},"dn":{"b_":[]},"dm":{"b_":[]},"bd":{"b_":[]},"dl":{"D":[]},"ay":{"aR":["1","2"],"hC":["1","2"],"aA":["1","2"]},"b0":{"n":["1"],"l":["1"],"l.E":"1"},"bW":{"T":["1"]},"az":{"n":["X<1,2>"],"l":["X<1,2>"],"l.E":"X<1,2>"},"bV":{"T":["X<1,2>"]},"bU":{"ay":["1","2"],"aR":["1","2"],"hC":["1","2"],"aA":["1","2"]},"d6":{"eQ":[]},"b2":{"I":[],"i":[],"cQ":[],"z":[]},"c2":{"I":[],"i":[]},"dC":{"cQ":[]},"c_":{"I":[],"hs":[],"i":[],"z":[]},"bi":{"a9":["1"],"I":[],"i":[]},"c0":{"w":["v"],"o":["v"],"a9":["v"],"I":[],"n":["v"],"i":[],"l":["v"],"G":["v"]},"c1":{"w":["e"],"o":["e"],"a9":["e"],"I":[],"n":["e"],"i":[],"l":["e"],"G":["e"]},"d9":{"e4":[],"w":["v"],"o":["v"],"a9":["v"],"I":[],"n":["v"],"i":[],"l":["v"],"G":["v"],"z":[],"w.E":"v","G.E":"v"},"da":{"e5":[],"w":["v"],"o":["v"],"a9":["v"],"I":[],"n":["v"],"i":[],"l":["v"],"G":["v"],"z":[],"w.E":"v","G.E":"v"},"db":{"eb":[],"w":["e"],"o":["e"],"a9":["e"],"I":[],"n":["e"],"i":[],"l":["e"],"G":["e"],"z":[],"w.E":"e","G.E":"e"},"dc":{"ec":[],"w":["e"],"o":["e"],"a9":["e"],"I":[],"n":["e"],"i":[],"l":["e"],"G":["e"],"z":[],"w.E":"e","G.E":"e"},"dd":{"ed":[],"w":["e"],"o":["e"],"a9":["e"],"I":[],"n":["e"],"i":[],"l":["e"],"G":["e"],"z":[],"w.E":"e","G.E":"e"},"de":{"fh":[],"w":["e"],"o":["e"],"a9":["e"],"I":[],"n":["e"],"i":[],"l":["e"],"G":["e"],"z":[],"w.E":"e","G.E":"e"},"df":{"fi":[],"w":["e"],"o":["e"],"a9":["e"],"I":[],"n":["e"],"i":[],"l":["e"],"G":["e"],"z":[],"w.E":"e","G.E":"e"},"c3":{"fj":[],"w":["e"],"o":["e"],"a9":["e"],"I":[],"n":["e"],"i":[],"l":["e"],"G":["e"],"z":[],"w.E":"e","G.E":"e"},"b3":{"fk":[],"w":["e"],"o":["e"],"a9":["e"],"I":[],"n":["e"],"i":[],"l":["e"],"G":["e"],"z":[],"w.E":"e","G.E":"e"},"dw":{"D":[]},"bt":{"aD":[],"D":[]},"co":{"cT":["1"]},"a8":{"D":[]},"br":{"cT":["1"]},"aF":{"br":["1"],"cT":["1"]},"cB":{"br":["1"],"cT":["1"]},"u":{"Q":["1"]},"cG":{"iW":[]},"dy":{"cG":[],"iW":[]},"cs":{"aR":["1","2"],"aA":["1","2"]},"bs":{"cs":["1","2"],"aR":["1","2"],"aA":["1","2"]},"ct":{"n":["1"],"l":["1"],"l.E":"1"},"cu":{"T":["1"]},"aR":{"aA":["1","2"]},"cN":{"bH":["m","o<e>"]},"cZ":{"bH":["m","o<e>"]},"v":{"ba":[]},"e":{"ba":[]},"o":{"n":["1"],"l":["1"]},"m":{"eQ":[]},"cO":{"D":[]},"aD":{"D":[]},"ag":{"D":[]},"bm":{"D":[]},"d_":{"D":[]},"ck":{"D":[]},"dp":{"D":[]},"bn":{"D":[]},"cU":{"D":[]},"dg":{"D":[]},"cc":{"D":[]},"d0":{"D":[]},"dA":{"at":[]},"ed":{"o":["e"],"n":["e"],"l":["e"]},"fk":{"o":["e"],"n":["e"],"l":["e"]},"fj":{"o":["e"],"n":["e"],"l":["e"]},"eb":{"o":["e"],"n":["e"],"l":["e"]},"fh":{"o":["e"],"n":["e"],"l":["e"]},"ec":{"o":["e"],"n":["e"],"l":["e"]},"fi":{"o":["e"],"n":["e"],"l":["e"]},"e4":{"o":["v"],"n":["v"],"l":["v"]},"e5":{"o":["v"],"n":["v"],"l":["v"]},"bA":{"N":[]},"bB":{"N":[]},"bF":{"N":[]},"bE":{"N":[]},"bJ":{"N":[]},"bM":{"N":[]},"bZ":{"N":[]},"c9":{"N":[]},"cb":{"N":[]},"cd":{"N":[]},"cf":{"N":[]},"cg":{"N":[]},"ch":{"N":[]},"ci":{"N":[]}}'))
A.ly(v.typeUniverse,JSON.parse('{"cH":2,"bi":1,"cV":2}'))
var u={n:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",c:"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type",f:"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAhGVYSWZNTQAqAAAACAAFARIAAwAAAAEAAQAAARoABQAAAAEAAABKARsABQAAAAEAAABSASgAAwAAAAEAAgAAh2kABAAAAAEAAABaAAAAAAAAAEgAAAABAAAASAAAAAEAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAIKADAAQAAAABAAAAIAAAAABfvA/wAAAACXBIWXMAAAsTAAALEwEAmpwYAAACyGlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNi4wLjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyIKICAgICAgICAgICAgeG1sbnM6ZXhpZj0iaHR0cDovL25zLmFkb2JlLmNvbS9leGlmLzEuMC8iPgogICAgICAgICA8dGlmZjpZUmVzb2x1dGlvbj43MjwvdGlmZjpZUmVzb2x1dGlvbj4KICAgICAgICAgPHRpZmY6UmVzb2x1dGlvblVuaXQ+MjwvdGlmZjpSZXNvbHV0aW9uVW5pdD4KICAgICAgICAgPHRpZmY6WFJlc29sdXRpb24+NzI8L3RpZmY6WFJlc29sdXRpb24+CiAgICAgICAgIDx0aWZmOk9yaWVudGF0aW9uPjE8L3RpZmY6T3JpZW50YXRpb24+CiAgICAgICAgIDxleGlmOlBpeGVsWERpbWVuc2lvbj41MDwvZXhpZjpQaXhlbFhEaW1lbnNpb24+CiAgICAgICAgIDxleGlmOkNvbG9yU3BhY2U+MTwvZXhpZjpDb2xvclNwYWNlPgogICAgICAgICA8ZXhpZjpQaXhlbFlEaW1lbnNpb24+NTA8L2V4aWY6UGl4ZWxZRGltZW5zaW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KZxgR6QAAB6lJREFUWAnlVmlsXFcZPfe9ecvsYzt2SihSk1SQBUWCqKUJSEkQyw+qSqXEKhKFssROLSTU0MQJAtUI0WYtKkJpYtqoqBJLDAXyB4kSakUlZSkCEtwQoRYqJXU2e+zxvHnztns5903sOBlH6o9KCHGleXPX7zvfud9ygf/3Jm5CgIDiil6d/W/1brJ9wem3Q8aCgudPaog3M2L+vpv22w8rJbB7oAJlGAhtBTsUCFWARw96VKUwNGQAowYeHU3SsRat2BvZbODV1XpdckZgaCAPWzhzMoSU2HlwCkJoTufafAC6TwEPVuDaJyDUOyHRgGE6sIwAnrcR3/jBa3Mn9z2Qzwb5ih6XnMLUxe37vbm1x7+wDLYzili5kEkAAzkocR7K3IBdT1W5r6WLnczcodmOk+VisgSm2QkTnem0lIOp8r4+C8vFRii5AgngZ2So1wM1bWf3PkQ9yVmvjBfRP/w6DvR/F4bYRzktyTEPKI/sXd/aAWCaG3MNwOyiokkk8b3Y+cwJ7N6ynuOPIjFPIxONdKNUtExVqFgWlIrrZ86Nz6CQXWcju8vcu/W4/9VD+7G77/fIGD+nwYu4qQHXuo5+DaUNUYrPJO3a/RPMKt9CCtchmD6QyVpTrlF80i26v+ypVH5V4e8dXYuPfWLN+568f9XaWnj6Fwf8RN7p7u3vw87hlxDLe6mcmgwHzUhTn4pO//lpBxAUAphGk0uD2Hn4BB7bsoW+0ISTPyhyHc/GGfN4T6nQ223ZK0UcL+4yrMXvLvesqJRLvaZj/ubT9ww+N/TetYebSeTNgTCM7bBMH5aiXLYWjBu76bj1GaITDR15Hfv619GR1iPAU8gbLxuuvUb6UXRnpVvcVu4ywjgQPbkibNNQkYxlV66opo3Eqk3X/r7cdj8wdPqVrdmM+Qd/x6HfYVbmPDW6e9VDbpgd/UuV4ZSBWXsQgfU95NWzcJ1Nqu43y5btCEijk3+3FMuiaLlCCIjufMlwbNv0/EbTzueWnPfqK0+/9MzXjZ73fCZZtvYkDjw9cYOWdNh+BWmccy07voEXNIZifAds61Oo+xFj2E3jh3dqCh7l1dJyFJ0s8vzpccYw3LjeiEzH+uT99+y4KwzD03kdObrNyk4HrU87gFVjVx1FrkIkTiJSfVowf0LTVZMJOqnMtR36l8Qlr4bxmUl4QRN2JoOsaSOKY6YdiZlm0IfEO0mGVrTUjbbpa7+Co2NAuZZl+L0fInmD1n8FUvYYUmkcwjZMLCt1IWfZCKIA9cAnC0x+ZMU2LW5VqPp1eGEomioxGD3PX46S23s+vmrM+9qxEN9sQZn9tiFKU6XvVchxyKsuMJl0IpEMBCUUre+2s5zOoBGFDBYLHXRCl4oNXkkjJKCwiZkwEF4QoCFlpysyBYk4nJFWmd6vuZwXAwtlwllokjVBN202f0Uzg9hQyLkuM5/Em14dJgEtrXSjSFAhWfB9D5ONGVQ1K2SkQfO8KGJEU4LOBQu0dgZ0McrmWTSk5Vhihrl8suQ4eFdHj7qtczHLgonppod/1qp4g1T/7cp5XKLSehzhvJ6bmUI9itS0jDAdBpMXkrDOYHMaRjSt/ahl0jUk7QBGeg1s+46vGQ8iFqNInqrT8su1qozjmDfEmKOkDEU1mN/HSfUEHbBGSyXB1QhkIgzkJFm60vBPBQhoBH1k+3NeWjGv6U577QB0SU2bOMMw/BAy5jD9Cpf8umrS6bR3K9J5a2URlhQruCVfhk9QV+gT434D50n/lShQlzmuy2gYifVB3uE/UpFzslsa9LcdQKueA0snR3lwJWT4ZxWGP3E6ylYpV2henKmiQYuTpPUcsDMm7z9OPf/s1GWm+7DpOaaVNPyfwpv4I+laDf/WF1OVs7Kv6V8AgF781ueWo3eEGtSvyetWjFc/Hzb8v/47nHEbcRyVcsV4oj4tz05cUOeql9WFqQn5WvVSzKQUiULOhd88BWvys3A6+hkqLzABxanMeYpnu/PzQMvrH3kgj47CK/jYHQ52HP4xPrJ2BfLualyobgtt83bpWGtCFRuTUUBnEKIpE+FDCuU6hiAdvKcRZCbvRljezPiJMTh8DPsHdjCfHML6pcMYfVW/IVq62Gm/gq6CzSRkM/4ex7f7NmHX94+k+3rKX16EeIv0401TtdoPlRBjTH3jwrHGRSYzhiD4kWqGH4YKv4ioY4BPOhu7hp9mNd0AyD2IKTPIssyzXfUy3V34QSJzLMkkxzJ+RhD3UdAR7PnSXVeU+TCFncllzUca9YTPrKSkXIZIIuuQpoeMpMNxjxAvYPDwy9hL5Yb5fGqw5Luy++qDZM7+BQGUuZ/CNUxDdMAxf4snBnZh28HdOLr5T/hX58ZGqO6DTfaUGSBh3lAsABkmS5hn0Dj7GIZGYxx4aJAidmsrW9lM5NDkA/eG1s6AYN6FOsdKo7NXgynZoVUDdKIR9KaP0uOUcRxPPJyFTtn6OnXi0rljtunaDwwwZi+SnYCM5LjtTYg8ZV/f2hBRqcCe/hKtMuD6Ck0+UgO+bIeG+U5k0yVVV8zNRyUFt25Tn9EJ7NqznPv6cmTPmZOhDRs8XJs7cz2O/96onYEWloXm5/nuWwL8dsh4S4r+tzf9Bwpfgk0+0buPAAAAAElFTkSuQmCC"}
var t=(function rtii(){var s=A.au
return{n:s("a8"),E:s("cQ"),Y:s("hs"),V:s("n<@>"),C:s("D"),W:s("e4"),q:s("e5"),Z:s("b_"),x:s("Q<~>"),d:s("eb"),k:s("ec"),w:s("ed"),R:s("l<@>"),c_:s("aN"),O:s("q<i>"),G:s("q<H>"),ao:s("q<X<m,@>>"),f:s("q<h>"),s:s("q<m>"),b:s("q<@>"),t:s("q<e>"),c:s("q<h?>"),U:s("L"),A:s("ac"),bs:s("W"),T:s("bS"),m:s("i"),fr:s("aO"),e5:s("aP"),g:s("H"),aU:s("a9<@>"),e:s("I"),cl:s("o<i>"),u:s("o<H>"),ew:s("o<h>"),a:s("o<m>"),j:s("o<@>"),L:s("o<e>"),fs:s("d8"),I:s("X<m,@>"),eO:s("aA<@,@>"),bm:s("b3"),P:s("P"),K:s("h"),hg:s("dh"),p:s("aS<h>"),gT:s("mR"),bQ:s("+()"),bJ:s("c8<m>"),l:s("at"),N:s("m"),dm:s("z"),eK:s("aD"),h7:s("fh"),bv:s("fi"),go:s("fj"),gc:s("fk"),ak:s("cj"),aQ:s("N"),cR:s("aF<i>"),h:s("aF<~>"),ev:s("J"),et:s("u<i>"),_:s("u<@>"),D:s("u<~>"),J:s("bs<h?,h?>"),aj:s("cB<~>"),y:s("C"),al:s("C(h)"),i:s("v"),z:s("@"),fO:s("@()"),v:s("@(h)"),Q:s("@(h,at)"),S:s("e"),eH:s("Q<P>?"),r:s("q<h?>?"),B:s("i?"),X:s("h?"),dk:s("m?"),F:s("aG<@,@>?"),fQ:s("C?"),cD:s("v?"),h6:s("e?"),cg:s("ba?"),o:s("ba"),H:s("~"),M:s("~()")}})();(function constants(){var s=hunkHelpers.makeConstList
B.aq=J.d1.prototype
B.a=J.q.prototype
B.z=J.bP.prototype
B.b=J.bR.prototype
B.at=J.bT.prototype
B.f=J.be.prototype
B.av=J.H.prototype
B.aw=J.I.prototype
B.aF=A.c_.prototype
B.aG=A.b3.prototype
B.a3=J.di.prototype
B.T=J.cj.prototype
B.a9=new A.bc("invalid hex bytes",null)
B.aa=new A.bc("Hex input string must be divisible by two",null)
B.ab=new A.bc("Incorrect characters for hex decoding",null)
B.ac=new A.dN(!1)
B.x=new A.bD("bitcoin")
B.ae=new A.cN()
B.af=new A.dO()
B.U=new A.cY()
B.ag=new A.bL(A.au("bL<0&>"))
B.aX=new A.e0()
B.y=new A.d0()
B.V=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.ah=function() {
  var toStringFunction = Object.prototype.toString;
  function getTag(o) {
    var s = toStringFunction.call(o);
    return s.substring(8, s.length - 1);
  }
  function getUnknownTag(object, tag) {
    if (/^HTML[A-Z].*Element$/.test(tag)) {
      var name = toStringFunction.call(object);
      if (name == "[object Object]") return null;
      return "HTMLElement";
    }
  }
  function getUnknownTagGenericBrowser(object, tag) {
    if (object instanceof HTMLElement) return "HTMLElement";
    return getUnknownTag(object, tag);
  }
  function prototypeForTag(tag) {
    if (typeof window == "undefined") return null;
    if (typeof window[tag] == "undefined") return null;
    var constructor = window[tag];
    if (typeof constructor != "function") return null;
    return constructor.prototype;
  }
  function discriminator(tag) { return null; }
  var isBrowser = typeof HTMLElement == "function";
  return {
    getTag: getTag,
    getUnknownTag: isBrowser ? getUnknownTagGenericBrowser : getUnknownTag,
    prototypeForTag: prototypeForTag,
    discriminator: discriminator };
}
B.am=function(getTagFallback) {
  return function(hooks) {
    if (typeof navigator != "object") return hooks;
    var userAgent = navigator.userAgent;
    if (typeof userAgent != "string") return hooks;
    if (userAgent.indexOf("DumpRenderTree") >= 0) return hooks;
    if (userAgent.indexOf("Chrome") >= 0) {
      function confirm(p) {
        return typeof window == "object" && window[p] && window[p].name == p;
      }
      if (confirm("Window") && confirm("HTMLElement")) return hooks;
    }
    hooks.getTag = getTagFallback;
  };
}
B.ai=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.al=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Firefox") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "GeoGeolocation": "Geolocation",
    "Location": "!Location",
    "WorkerMessageEvent": "MessageEvent",
    "XMLDocument": "!Document"};
  function getTagFirefox(o) {
    var tag = getTag(o);
    return quickMap[tag] || tag;
  }
  hooks.getTag = getTagFirefox;
}
B.ak=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Trident/") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "HTMLDDElement": "HTMLElement",
    "HTMLDTElement": "HTMLElement",
    "HTMLPhraseElement": "HTMLElement",
    "Position": "Geoposition"
  };
  function getTagIE(o) {
    var tag = getTag(o);
    var newTag = quickMap[tag];
    if (newTag) return newTag;
    if (tag == "Object") {
      if (window.DataView && (o instanceof window.DataView)) return "DataView";
    }
    return tag;
  }
  function prototypeForTagIE(tag) {
    var constructor = window[tag];
    if (constructor == null) return null;
    return constructor.prototype;
  }
  hooks.getTag = getTagIE;
  hooks.prototypeForTag = prototypeForTagIE;
}
B.aj=function(hooks) {
  var getTag = hooks.getTag;
  var prototypeForTag = hooks.prototypeForTag;
  function getTagFixed(o) {
    var tag = getTag(o);
    if (tag == "Document") {
      if (!!o.xmlVersion) return "!Document";
      return "!HTMLDocument";
    }
    return tag;
  }
  function prototypeForTagFixed(tag) {
    if (tag == "Document") return null;
    return prototypeForTag(tag);
  }
  hooks.getTag = getTagFixed;
  hooks.prototypeForTag = prototypeForTagFixed;
}
B.W=function(hooks) { return hooks; }

B.an=new A.dg()
B.p=new A.f0()
B.ao=new A.fl()
B.X=new A.fP()
B.i=new A.dy()
B.q=new A.dA()
B.ap=new A.dZ("SHA256: can't update because hash was finished.",null)
B.r=new A.aN("Rejected","rejected")
B.A=new A.L("Aptos","aptos")
B.B=new A.L("BitcoinCash","bitcoinCash")
B.C=new A.L("Bitcoin","bitcoin")
B.D=new A.L("Cardano","cardano")
B.E=new A.L("Cosmos","cosmos")
B.F=new A.L("Ethereum","ethereum")
B.G=new A.L("Monero","monero")
B.H=new A.L("Solana","solana")
B.I=new A.L("Stellar","stellar")
B.J=new A.L("Substrate","substrate")
B.K=new A.L("Sui","sui")
B.L=new A.L("TON","ton")
B.M=new A.L("Tron","tron")
B.N=new A.L("XRPL","xrpl")
B.h=new A.ac("accountsChanged")
B.j=new A.ac("chainChanged")
B.c=new A.ac("message")
B.l=new A.ac("connect")
B.n=new A.ac("disconnect")
B.d=new A.ac("change")
B.O=new A.W("networkAccountsChanged")
B.Y=new A.W("change")
B.t=new A.W("defaultChainChanged")
B.u=new A.W("defaultAccountChanged")
B.P=new A.W("message")
B.Z=new A.aO("response")
B.a_=new A.aP("success")
B.Q=new A.aP("failed")
B.v=s(["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"],t.s)
B.a0=s([256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,0,1,2,3,4,5,6,7,8,9,256,256,256,256,256,256,256,10,11,12,13,14,15,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,10,11,12,13,14,15,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256],t.t)
B.a1=s([B.h,B.j,B.c,B.l,B.n,B.d],A.au("q<ac>"))
B.ax=s([1116352408,1899447441,3049323471,3921009573,961987163,1508970993,2453635748,2870763221,3624381080,310598401,607225278,1426881987,1925078388,2162078206,2614888103,3248222580,3835390401,4022224774,264347078,604807628,770255983,1249150122,1555081692,1996064986,2554220882,2821834349,2952996808,3210313671,3336571891,3584528711,113926993,338241895,666307205,773529912,1294757372,1396182291,1695183700,1986661051,2177026350,2456956037,2730485921,2820302411,3259730800,3345764771,3516065817,3600352804,4094571909,275423344,430227734,506948616,659060556,883997877,958139571,1322822218,1537002063,1747873779,1955562222,2024104815,2227730452,2361852424,2428436474,2756734187,3204031479,3329325298],t.b)
B.au=new A.aO("event")
B.ay=s([B.Z,B.au],A.au("q<aO>"))
B.as=new A.L("","global")
B.az=s([B.as,B.F,B.M,B.H,B.L,B.I,B.N,B.J,B.A,B.K,B.C,B.E,B.G,B.D,B.B],A.au("q<L>"))
B.aA=s(["isDapper"],t.s)
B.aB=s([B.O,B.Y,B.t,B.u,B.P],A.au("q<W>"))
B.ar=new A.aN("Approved","approved")
B.aC=s([B.ar,B.r],A.au("q<aN>"))
B.aD=s([B.a_,B.Q],A.au("q<aP>"))
B.R=new A.d8("one")
B.ad=new A.bD("ripple")
B.a2=new A.bO([B.x,"123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz",B.ad,"rpshnaf39wBUDNEGHJKLM4PQRST7VWXYZ2bcdeCg65jkm8oFqi1tuvAxyz"],A.au("bO<bD,m>"))
B.aE=new A.eM("Invalid character in Base58 string",null)
B.o=new A.c5("walletStandard")
B.k=new A.c5("eip1993")
B.e=new A.c5("cardano")
B.a4=new A.aC("ascii")
B.S=new A.aC("utf8")
B.w=new A.aC("base64")
B.a5=new A.aC("base64UrlSafe")
B.a6=new A.aC("base58")
B.a7=new A.aC("base58Check")
B.a8=new A.aC("hex")
B.aH=A.aq("cQ")
B.aI=A.aq("hs")
B.aJ=A.aq("e4")
B.aK=A.aq("e5")
B.aL=A.aq("eb")
B.aM=A.aq("ec")
B.aN=A.aq("ed")
B.aO=A.aq("h")
B.aP=A.aq("fh")
B.aQ=A.aq("fi")
B.aR=A.aq("fj")
B.aS=A.aq("fk")
B.aT=new A.dr(!1)
B.aU=new A.dr(!0)
B.aW=new A.ds("invalidParams")
B.aV=new A.ds("internalError")
B.m=new A.cl("An error occurred during the request",B.aV)})();(function staticFields(){$.fR=null
$.ab=A.b([],t.f)
$.iL=null
$.ik=null
$.ij=null
$.jE=null
$.jz=null
$.jI=null
$.hc=null
$.hh=null
$.i4=null
$.nd=A.b([],A.au("q<o<h>?>"))
$.bu=null
$.cI=null
$.cJ=null
$.hZ=!1
$.x=B.i
$.j_=null
$.j0=null
$.j1=null
$.j2=null
$.hL=A.fB("_lastQuoRemDigits")
$.hM=A.fB("_lastQuoRemUsed")
$.cq=A.fB("_lastRemUsed")
$.hN=A.fB("_lastRem_nsh")})();(function lazyInitializers(){var s=hunkHelpers.lazyFinal
s($,"mM","bz",()=>A.my("_$dart_dartClosure"))
s($,"nj","k7",()=>A.b([new J.d2()],A.au("q<ca>")))
s($,"mW","jR",()=>A.aE(A.fe({
toString:function(){return"$receiver$"}})))
s($,"mX","jS",()=>A.aE(A.fe({$method$:null,
toString:function(){return"$receiver$"}})))
s($,"mY","jT",()=>A.aE(A.fe(null)))
s($,"mZ","jU",()=>A.aE(function(){var $argumentsExpr$="$arguments$"
try{null.$method$($argumentsExpr$)}catch(r){return r.message}}()))
s($,"n1","jX",()=>A.aE(A.fe(void 0)))
s($,"n2","jY",()=>A.aE(function(){var $argumentsExpr$="$arguments$"
try{(void 0).$method$($argumentsExpr$)}catch(r){return r.message}}()))
s($,"n0","jW",()=>A.aE(A.iV(null)))
s($,"n_","jV",()=>A.aE(function(){try{null.$method$}catch(r){return r.message}}()))
s($,"n4","k_",()=>A.aE(A.iV(void 0)))
s($,"n3","jZ",()=>A.aE(function(){try{(void 0).$method$}catch(r){return r.message}}()))
s($,"n5","ib",()=>A.ld())
s($,"ng","k5",()=>A.iI(4096))
s($,"ne","k3",()=>new A.h_().$0())
s($,"nf","k4",()=>new A.fZ().$0())
s($,"nc","V",()=>A.du(0))
s($,"na","aL",()=>A.du(1))
s($,"nb","k2",()=>A.du(2))
s($,"n9","ic",()=>$.aL().a1(0))
s($,"n7","k0",()=>A.du(1e4))
s($,"n8","k1",()=>A.iI(8))
s($,"nh","hp",()=>A.dF(B.aO))
s($,"ni","k6",()=>Symbol("jsBoxedDartObjectProperty"))
s($,"mQ","jN",()=>{var r=new A.fQ(new DataView(new ArrayBuffer(A.lP(8))))
r.cM()
return r})
s($,"n6","ho",()=>new A.fv().$0())
s($,"mU","jP",()=>A.l6("^(0x|0X)?([0-9A-Fa-f]{2})+$"))
s($,"mO","ia",()=>({message:"this feature disabled by wallet provider."}))
s($,"mN","jM",()=>({uuid:"466aef37-e077-42d1-b26b-801ff1af4a36",name:"OnChain",icon:u.f,rdns:"com.mrtnetwork.wallet"}))
s($,"mS","jO",()=>A.kQ(A.b(["legacy",0],t.f),t.K))
s($,"mV","jQ",()=>({message:"Invalid Sui transaction. The transaction must include transactionBlock with the blockData property for v1, or transaction with the toJSON property for v2."}))})();(function nativeSupport(){!function(){var s=function(a){var m={}
m[a]=1
return Object.keys(hunkHelpers.convertToFastObject(m))[0]}
v.getIsolateTag=function(a){return s("___dart_"+a+v.isolateTag)}
var r="___dart_isolate_tags_"
var q=Object[r]||(Object[r]=Object.create(null))
var p="_ZxYxX"
for(var o=0;;o++){var n=s(p+"_"+o+"_")
if(!(n in q)){q[n]=1
v.isolateTag=n
break}}v.dispatchPropertyName=v.getIsolateTag("dispatch_record")}()
hunkHelpers.setOrUpdateInterceptorsByTag({ArrayBuffer:A.b2,SharedArrayBuffer:A.b2,ArrayBufferView:A.c2,DataView:A.c_,Float32Array:A.d9,Float64Array:A.da,Int16Array:A.db,Int32Array:A.dc,Int8Array:A.dd,Uint16Array:A.de,Uint32Array:A.df,Uint8ClampedArray:A.c3,CanvasPixelArray:A.c3,Uint8Array:A.b3})
hunkHelpers.setOrUpdateLeafTags({ArrayBuffer:true,SharedArrayBuffer:true,ArrayBufferView:false,DataView:true,Float32Array:true,Float64Array:true,Int16Array:true,Int32Array:true,Int8Array:true,Uint16Array:true,Uint32Array:true,Uint8ClampedArray:true,CanvasPixelArray:true,Uint8Array:false})
A.bi.$nativeSuperclassTag="ArrayBufferView"
A.cv.$nativeSuperclassTag="ArrayBufferView"
A.cw.$nativeSuperclassTag="ArrayBufferView"
A.c0.$nativeSuperclassTag="ArrayBufferView"
A.cx.$nativeSuperclassTag="ArrayBufferView"
A.cy.$nativeSuperclassTag="ArrayBufferView"
A.c1.$nativeSuperclassTag="ArrayBufferView"})()
Function.prototype.$2=function(a,b){return this(a,b)}
Function.prototype.$0=function(){return this()}
Function.prototype.$1=function(a){return this(a)}
Function.prototype.$3=function(a,b,c){return this(a,b,c)}
Function.prototype.$4=function(a,b,c,d){return this(a,b,c,d)}
Function.prototype.$1$1=function(a){return this(a)}
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!="undefined"){a(document.currentScript)
return}var s=document.scripts
function onLoad(b){for(var q=0;q<s.length;++q){s[q].removeEventListener("load",onLoad,false)}a(b.target)}for(var r=0;r<s.length;++r){s[r].addEventListener("load",onLoad,false)}})(function(a){v.currentScript=a
var s=function(b){return A.i6(A.mt(b))}
if(typeof dartMainRunner==="function"){dartMainRunner(s,[])}else{s([])}})})()