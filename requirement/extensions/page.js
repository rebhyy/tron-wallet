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
if(a[b]!==s){A.cF(b)}a[b]=r}var q=a[b]
a[c]=function(){return q}
return q}}function makeConstList(a){a.$flags=7
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var s=0;s<a.length;++s){convertToFastObject(a[s])}}var y=0
function instanceTearOffGetter(a,b){var s=null
return a?function(c){if(s===null)s=A.hL(b)
return new s(c,this)}:function(){if(s===null)s=A.hL(b)
return new s(this,null)}}function staticTearOffGetter(a){var s=null
return function(){if(s===null)s=A.hL(a).prototype
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
hR(a,b,c,d){return{i:a,p:b,e:c,x:d}},
fV(a){var s,r,q,p,o,n=a[v.dispatchPropertyName]
if(n==null)if($.hO==null){A.m5()
n=a[v.dispatchPropertyName]}if(n!=null){s=n.p
if(!1===s)return n.i
if(!0===s)return a
r=Object.getPrototypeOf(a)
if(s===r)return n.i
if(n.e===r)throw A.d(A.ht("Return interceptor for "+A.n(s(a,n))))}q=a.constructor
if(q==null)p=null
else{o=$.fy
if(o==null)o=$.fy=v.getIsolateTag("_$dart_js")
p=q[o]}if(p!=null)return p
p=A.m9(a)
if(p!=null)return p
if(typeof a=="function")return B.as
s=Object.getPrototypeOf(a)
if(s==null)return B.a0
if(s===Object.prototype)return B.a0
if(typeof q=="function"){o=$.fy
if(o==null)o=$.fy=v.getIsolateTag("_$dart_js")
Object.defineProperty(q,o,{value:B.O,enumerable:false,writable:true,configurable:true})
return B.O}return B.O},
i9(a,b){if(a<0||a>4294967295)throw A.d(A.a1(a,0,4294967295,"length",null))
return J.ka(new Array(a),b)},
ia(a,b){if(a<0)throw A.d(A.a_("Length must be a non-negative integer: "+a,null))
return A.b(new Array(a),b.h("o<0>"))},
ka(a,b){var s=A.b(a,b.h("o<0>"))
s.$flags=1
return s},
b2(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.bI.prototype
return J.cW.prototype}if(typeof a=="string")return J.ba.prototype
if(a==null)return J.bJ.prototype
if(typeof a=="boolean")return J.bG.prototype
if(Array.isArray(a))return J.o.prototype
if(typeof a!="object"){if(typeof a=="function")return J.D.prototype
if(typeof a=="symbol")return J.bc.prototype
if(typeof a=="bigint")return J.bb.prototype
return a}if(a instanceof A.e)return a
return J.fV(a)},
b3(a){if(typeof a=="string")return J.ba.prototype
if(a==null)return a
if(Array.isArray(a))return J.o.prototype
if(typeof a!="object"){if(typeof a=="function")return J.D.prototype
if(typeof a=="symbol")return J.bc.prototype
if(typeof a=="bigint")return J.bb.prototype
return a}if(a instanceof A.e)return a
return J.fV(a)},
b4(a){if(a==null)return a
if(Array.isArray(a))return J.o.prototype
if(typeof a!="object"){if(typeof a=="function")return J.D.prototype
if(typeof a=="symbol")return J.bc.prototype
if(typeof a=="bigint")return J.bb.prototype
return a}if(a instanceof A.e)return a
return J.fV(a)},
ja(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.D.prototype
if(typeof a=="symbol")return J.bc.prototype
if(typeof a=="bigint")return J.bb.prototype
return a}if(a instanceof A.e)return a
return J.fV(a)},
h7(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.b2(a).Z(a,b)},
jF(a,b){if(typeof b==="number")if(Array.isArray(a)||typeof a=="string"||A.m8(a,a[v.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.b3(a).k(a,b)},
hW(a,b){return J.b4(a).m(a,b)},
jG(a){return J.ja(a).bS(a)},
jH(a,b,c){return J.ja(a).bT(a,b,c)},
h8(a,b){return J.b4(a).G(a,b)},
ap(a){return J.b2(a).gv(a)},
aR(a){return J.b4(a).gC(a)},
ak(a){return J.b3(a).gn(a)},
jI(a){return J.b2(a).gD(a)},
dz(a,b,c){return J.b4(a).ad(a,b,c)},
jJ(a,b){return J.b4(a).cf(a,b)},
jK(a,b){return J.b4(a).c2(a,b)},
Z(a){return J.b2(a).i(a)},
cV:function cV(){},
bG:function bG(){},
bJ:function bJ(){},
A:function A(){},
aK:function aK(){},
dc:function dc(){},
cb:function cb(){},
D:function D(){},
bb:function bb(){},
bc:function bc(){},
o:function o(a){this.$ti=a},
ep:function ep(a){this.$ti=a},
bu:function bu(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
bK:function bK(){},
bI:function bI(){},
cW:function cW(){},
ba:function ba(){}},A={hj:function hj(){},
kh(a){return new A.bN("Field '"+a+"' has been assigned during initialization.")},
aN(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
hr(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
cD(a,b,c){return a},
hP(a){var s,r
for(s=$.a2.length,r=0;r<s;++r)if(a===$.a2[r])return!0
return!1},
hq(a,b,c,d){A.dd(b,"start")
if(c!=null){A.dd(c,"end")
if(b>c)A.X(A.a1(b,0,c,"start",null))}return new A.c6(a,b,c,d.h("c6<0>"))},
ig(a,b,c,d){if(t.V.b(a))return new A.bB(a,b,c.h("@<0>").u(d).h("bB<1,2>"))
return new A.av(a,b,c.h("@<0>").u(d).h("av<1,2>"))},
i7(){return new A.bh("No element")},
bj:function bj(){},
bx:function bx(a,b){this.a=a
this.$ti=b},
cj:function cj(){},
aq:function aq(a,b){this.a=a
this.$ti=b},
bN:function bN(a){this.a=a},
eL:function eL(){},
l:function l(){},
F:function F(){},
c6:function c6(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
aV:function aV(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
av:function av(a,b,c){this.a=a
this.b=b
this.$ti=c},
bB:function bB(a,b,c){this.a=a
this.b=b
this.$ti=c},
bR:function bR(a,b,c){var _=this
_.a=null
_.b=a
_.c=b
_.$ti=c},
U:function U(a,b,c){this.a=a
this.b=b
this.$ti=c},
ce:function ce(a,b,c){this.a=a
this.b=b
this.$ti=c},
cf:function cf(a,b,c){this.a=a
this.b=b
this.$ti=c},
aS:function aS(a){this.$ti=a},
bC:function bC(a){this.$ti=a},
Q:function Q(){},
c1:function c1(a,b){this.a=a
this.$ti=b},
cz:function cz(){},
jh(a){var s=v.mangledGlobalNames[a]
if(s!=null)return s
return"minified:"+a},
m8(a,b){var s
if(b!=null){s=b.x
if(s!=null)return s}return t.aU.b(a)},
n(a){var s
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
s=J.Z(a)
return s},
c_(a){var s,r=$.ik
if(r==null)r=$.ik=Symbol("identityHashCode")
s=a[r]
if(s==null){s=Math.random()*0x3fffffff|0
a[r]=s}return s},
eE(a){var s,r,q,p
if(a instanceof A.e)return A.W(A.b5(a),null)
s=J.b2(a)
if(s===B.an||s===B.at||t.ak.b(a)){r=B.Q(a)
if(r!=="Object"&&r!=="")return r
q=a.constructor
if(typeof q=="function"){p=q.name
if(typeof p=="string"&&p!=="Object"&&p!=="")return p}}return A.W(A.b5(a),null)},
kw(a){if(a==null||typeof a=="number"||A.fN(a))return J.Z(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.aG)return a.i(0)
if(a instanceof A.cr)return a.eF(!0)
return"Instance of '"+A.eE(a)+"'"},
ij(a){var s,r,q,p,o=a.length
if(o<=500)return String.fromCharCode.apply(null,a)
for(s="",r=0;r<o;r=q){q=r+500
p=q<o?q:o
s+=String.fromCharCode.apply(null,a.slice(r,p))}return s},
kx(a){var s,r,q,p=A.b([],t.t)
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.an)(a),++r){q=a[r]
if(!A.fO(q))throw A.d(A.cC(q))
if(q<=65535)B.a.m(p,q)
else if(q<=1114111){B.a.m(p,55296+(B.b.a5(q-65536,10)&1023))
B.a.m(p,56320+(q&1023))}else throw A.d(A.cC(q))}return A.ij(p)},
il(a){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(!A.fO(q))throw A.d(A.cC(q))
if(q<0)throw A.d(A.cC(q))
if(q>65535)return A.kx(a)}return A.ij(a)},
ky(a,b,c){var s,r,q,p
if(c<=500&&b===0&&c===a.length)return String.fromCharCode.apply(null,a)
for(s=b,r="";s<c;s=q){q=s+500
p=q<c?q:c
r+=String.fromCharCode.apply(null,a.subarray(s,p))}return r},
aX(a){var s
if(0<=a){if(a<=65535)return String.fromCharCode(a)
if(a<=1114111){s=a-65536
return String.fromCharCode((B.b.a5(s,10)|55296)>>>0,s&1023|56320)}}throw A.d(A.a1(a,0,1114111,null,null))},
bf(a){if(a.date===void 0)a.date=new Date(a.a)
return a.date},
kv(a){var s=A.bf(a).getUTCFullYear()+0
return s},
kt(a){var s=A.bf(a).getUTCMonth()+1
return s},
kp(a){var s=A.bf(a).getUTCDate()+0
return s},
kq(a){var s=A.bf(a).getUTCHours()+0
return s},
ks(a){var s=A.bf(a).getUTCMinutes()+0
return s},
ku(a){var s=A.bf(a).getUTCSeconds()+0
return s},
kr(a){var s=A.bf(a).getUTCMilliseconds()+0
return s},
ko(a){var s=a.$thrownJsError
if(s==null)return null
return A.aP(s)},
im(a,b){var s
if(a.$thrownJsError==null){s=new Error()
A.K(a,s)
a.$thrownJsError=s
s.stack=b.i(0)}},
a(a,b){if(a==null)J.ak(a)
throw A.d(A.fT(a,b))},
fT(a,b){var s,r="index"
if(!A.fO(b))return new A.a8(!0,b,r,null)
s=J.ak(a)
if(b<0||b>=s)return A.hf(b,s,a,r)
return new A.bg(null,null,!0,b,r,"Value not in range")},
lZ(a,b,c){if(a>c)return A.a1(a,0,c,"start",null)
if(b!=null)if(b<a||b>c)return A.a1(b,a,c,"end",null)
return new A.a8(!0,b,"end",null)},
cC(a){return new A.a8(!0,a,null,null)},
d(a){return A.K(a,new Error())},
K(a,b){var s
if(a==null)a=new A.ax()
b.dartException=a
s=A.md
if("defineProperty" in Object){Object.defineProperty(b,"message",{get:s})
b.name=""}else b.toString=s
return b},
md(){return J.Z(this.dartException)},
X(a,b){throw A.K(a,b==null?new Error():b)},
x(a,b,c){var s
if(b==null)b=0
if(c==null)c=0
s=Error()
A.X(A.lm(a,b,c),s)},
lm(a,b,c){var s,r,q,p,o,n,m,l,k
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
return new A.cc("'"+s+"': Cannot "+o+" "+l+k+n)},
an(a){throw A.d(A.a9(a))},
ay(a){var s,r,q,p,o,n
a=A.jg(a.replace(String({}),"$receiver$"))
s=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(s==null)s=A.b([],t.s)
r=s.indexOf("\\$arguments\\$")
q=s.indexOf("\\$argumentsExpr\\$")
p=s.indexOf("\\$expr\\$")
o=s.indexOf("\\$method\\$")
n=s.indexOf("\\$receiver\\$")
return new A.eV(a.replace(new RegExp("\\\\\\$arguments\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$argumentsExpr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$expr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$method\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$receiver\\\\\\$","g"),"((?:x|[^x])*)"),r,q,p,o,n)},
eW(a){return function($expr$){var $argumentsExpr$="$arguments$"
try{$expr$.$method$($argumentsExpr$)}catch(s){return s.message}}(a)},
iv(a){return function($expr$){try{$expr$.$method$}catch(s){return s.message}}(a)},
hk(a,b){var s=b==null,r=s?null:b.method
return new A.cZ(a,r,s?null:b.receiver)},
ao(a){var s
if(a==null)return new A.eC(a)
if(a instanceof A.bE){s=a.a
return A.aQ(a,s==null?t.K.a(s):s)}if(typeof a!=="object")return a
if("dartException" in a)return A.aQ(a,a.dartException)
return A.lQ(a)},
aQ(a,b){if(t.C.b(b))if(b.$thrownJsError==null)b.$thrownJsError=a
return b},
lQ(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(!("message" in a))return a
s=a.message
if("number" in a&&typeof a.number=="number"){r=a.number
q=r&65535
if((B.b.a5(r,16)&8191)===10)switch(q){case 438:return A.aQ(a,A.hk(A.n(s)+" (Error "+q+")",null))
case 445:case 5007:A.n(s)
return A.aQ(a,new A.bZ())}}if(a instanceof TypeError){p=$.jo()
o=$.jp()
n=$.jq()
m=$.jr()
l=$.ju()
k=$.jv()
j=$.jt()
$.js()
i=$.jx()
h=$.jw()
g=p.U(s)
if(g!=null)return A.aQ(a,A.hk(A.k(s),g))
else{g=o.U(s)
if(g!=null){g.method="call"
return A.aQ(a,A.hk(A.k(s),g))}else if(n.U(s)!=null||m.U(s)!=null||l.U(s)!=null||k.U(s)!=null||j.U(s)!=null||m.U(s)!=null||i.U(s)!=null||h.U(s)!=null){A.k(s)
return A.aQ(a,new A.bZ())}}return A.aQ(a,new A.di(typeof s=="string"?s:""))}if(a instanceof RangeError){if(typeof s=="string"&&s.indexOf("call stack")!==-1)return new A.c4()
s=function(b){try{return String(b)}catch(f){}return null}(a)
return A.aQ(a,new A.a8(!1,null,null,typeof s=="string"?s.replace(/^RangeError:\s*/,""):s))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof s=="string"&&s==="too much recursion")return new A.c4()
return a},
aP(a){var s
if(a instanceof A.bE)return a.b
if(a==null)return new A.cs(a)
s=a.$cachedTrace
if(s!=null)return s
s=new A.cs(a)
if(typeof a==="object")a.$cachedTrace=s
return s},
dy(a){if(a==null)return J.ap(a)
if(typeof a=="object")return A.c_(a)
return J.ap(a)},
lV(a){if(typeof a=="number")return B.aq.gv(a)
if(a instanceof A.du)return A.c_(a)
if(a instanceof A.cr)return a.gv(a)
return A.dy(a)},
j9(a,b){var s,r,q,p=a.length
for(s=0;s<p;s=q){r=s+1
q=r+1
b.l(0,a[s],a[r])}return b},
lw(a,b,c,d,e,f){t.Z.a(a)
switch(A.ad(b)){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw A.d(new A.fk("Unsupported number of arguments for wrapped closure"))},
cE(a,b){var s=a.$identity
if(!!s)return s
s=A.lW(a,b)
a.$identity=s
return s},
lW(a,b){var s
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
return function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,A.lw)},
jY(a2){var s,r,q,p,o,n,m,l,k,j,i=a2.co,h=a2.iS,g=a2.iI,f=a2.nDA,e=a2.aI,d=a2.fs,c=a2.cs,b=d[0],a=c[0],a0=i[b],a1=a2.fT
a1.toString
s=h?Object.create(new A.df().constructor.prototype):Object.create(new A.b9(null,null).constructor.prototype)
s.$initialize=s.constructor
r=h?function static_tear_off(){this.$initialize()}:function tear_off(a3,a4){this.$initialize(a3,a4)}
s.constructor=r
r.prototype=s
s.$_name=b
s.$_target=a0
q=!h
if(q)p=A.i4(b,a0,g,f)
else{s.$static_name=b
p=a0}s.$S=A.jU(a1,h,g)
s[a]=p
for(o=p,n=1;n<d.length;++n){m=d[n]
if(typeof m=="string"){l=i[m]
k=m
m=l}else k=""
j=c[n]
if(j!=null){if(q)m=A.i4(k,m,g,f)
s[j]=m}if(n===e)o=m}s.$C=o
s.$R=a2.rC
s.$D=a2.dV
return r},
jU(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.d("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.jQ)}throw A.d("Error in functionType of tearoff")},
jV(a,b,c,d){var s=A.i2
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,s)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,s)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,s)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,s)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,s)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,s)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,s)}},
i4(a,b,c,d){if(c)return A.jX(a,b,d)
return A.jV(b.length,d,a,b)},
jW(a,b,c,d){var s=A.i2,r=A.jR
switch(b?-1:a){case 0:throw A.d(new A.de("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,r,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,r,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,r,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,r,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,r,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,r,s)
default:return function(e,f,g){return function(){var q=[g(this)]
Array.prototype.push.apply(q,arguments)
return e.apply(f(this),q)}}(d,r,s)}},
jX(a,b,c){var s,r
if($.i0==null)$.i0=A.i_("interceptor")
if($.i1==null)$.i1=A.i_("receiver")
s=b.length
r=A.jW(s,c,a,b)
return r},
hL(a){return A.jY(a)},
jQ(a,b){return A.cx(v.typeUniverse,A.b5(a.a),b)},
i2(a){return a.a},
jR(a){return a.b},
i_(a){var s,r,q,p=new A.b9("receiver","interceptor"),o=Object.getOwnPropertyNames(p)
o.$flags=1
s=o
for(o=s.length,r=0;r<o;++r){q=s[r]
if(p[q]===a)return q}throw A.d(A.a_("Field name "+a+" not found.",null))},
m1(a){return v.getIsolateTag(a)},
lX(a){var s,r=A.b([],t.s)
if(a==null)return r
if(Array.isArray(a)){for(s=0;s<a.length;++s)r.push(String(a[s]))
return r}r.push(String(a))
return r},
mL(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
m9(a){var s,r,q,p,o,n=A.k($.jb.$1(a)),m=$.fU[n]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.fZ[n]
if(s!=null)return s
r=v.interceptorsByTag[n]
if(r==null){q=A.B($.j6.$2(a,n))
if(q!=null){m=$.fU[q]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.fZ[q]
if(s!=null)return s
r=v.interceptorsByTag[q]
n=q}}if(r==null)return null
s=r.prototype
p=n[0]
if(p==="!"){m=A.h2(s)
$.fU[n]=m
Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}if(p==="~"){$.fZ[n]=s
return s}if(p==="-"){o=A.h2(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}if(p==="+")return A.jd(a,s)
if(p==="*")throw A.d(A.ht(n))
if(v.leafTags[n]===true){o=A.h2(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}else return A.jd(a,s)},
jd(a,b){var s=Object.getPrototypeOf(a)
Object.defineProperty(s,v.dispatchPropertyName,{value:J.hR(b,s,null,null),enumerable:false,writable:true,configurable:true})
return b},
h2(a){return J.hR(a,!1,null,!!a.$ia0)},
mb(a,b,c){var s=b.prototype
if(v.leafTags[a]===true)return A.h2(s)
else return J.hR(s,c,null,null)},
m5(){if(!0===$.hO)return
$.hO=!0
A.m6()},
m6(){var s,r,q,p,o,n,m,l
$.fU=Object.create(null)
$.fZ=Object.create(null)
A.m4()
s=v.interceptorsByTag
r=Object.getOwnPropertyNames(s)
if(typeof window!="undefined"){window
q=function(){}
for(p=0;p<r.length;++p){o=r[p]
n=$.jf.$1(o)
if(n!=null){m=A.mb(o,s[o],n)
if(m!=null){Object.defineProperty(n,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
q.prototype=n}}}}for(p=0;p<r.length;++p){o=r[p]
if(/^[A-Za-z_]/.test(o)){l=s[o]
s["!"+o]=l
s["~"+o]=l
s["-"+o]=l
s["+"+o]=l
s["*"+o]=l}}},
m4(){var s,r,q,p,o,n,m=B.ae()
m=A.bp(B.af,A.bp(B.ag,A.bp(B.R,A.bp(B.R,A.bp(B.ah,A.bp(B.ai,A.bp(B.aj(B.Q),m)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){s=dartNativeDispatchHooksTransformer
if(typeof s=="function")s=[s]
if(Array.isArray(s))for(r=0;r<s.length;++r){q=s[r]
if(typeof q=="function")m=q(m)||m}}p=m.getTag
o=m.getUnknownTag
n=m.prototypeForTag
$.jb=new A.fW(p)
$.j6=new A.fX(o)
$.jf=new A.fY(n)},
bp(a,b){return a(b)||b},
lY(a,b){var s=b.length,r=v.rttc[""+s+";"+a]
if(r==null)return null
if(s===0)return r
if(s===r.length)return r.apply(null,b)
return r(b)},
kf(a,b,c,d,e,f){var s=b?"m":"",r=c?"":"i",q=d?"u":"",p=e?"s":"",o=function(g,h){try{return new RegExp(g,h)}catch(n){return n}}(a,s+r+q+p+f)
if(o instanceof RegExp)return o
throw A.d(A.he("Illegal RegExp pattern ("+String(o)+")",a,null))},
m_(a){if(a.indexOf("$",0)>=0)return a.replace(/\$/g,"$$$$")
return a},
jg(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
br(a,b,c){var s=A.mc(a,b,c)
return s},
mc(a,b,c){var s,r,q
if(b===""){if(a==="")return c
s=a.length
r=""+c
for(q=0;q<s;++q)r=r+a[q]+c
return r.charCodeAt(0)==0?r:r}if(a.indexOf(b,0)<0)return a
if(a.length<500||c.indexOf("$",0)>=0)return a.split(b).join(c)
return a.replace(new RegExp(A.jg(b),"g"),A.m_(c))},
bz:function bz(){},
bF:function bF(a,b){this.a=a
this.$ti=b},
eV:function eV(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
bZ:function bZ(){},
cZ:function cZ(a,b,c){this.a=a
this.b=b
this.c=c},
di:function di(a){this.a=a},
eC:function eC(a){this.a=a},
bE:function bE(a,b){this.a=a
this.b=b},
cs:function cs(a){this.a=a
this.b=null},
aG:function aG(){},
cK:function cK(){},
cL:function cL(){},
dg:function dg(){},
df:function df(){},
b9:function b9(a,b){this.a=a
this.b=b},
de:function de(a){this.a=a},
as:function as(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
ey:function ey(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=null},
aU:function aU(a,b){this.a=a
this.$ti=b},
bP:function bP(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
at:function at(a,b){this.a=a
this.$ti=b},
bO:function bO(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
bM:function bM(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
fW:function fW(a){this.a=a},
fX:function fX(a){this.a=a},
fY:function fY(a){this.a=a},
cr:function cr(){},
cY:function cY(a,b){var _=this
_.a=a
_.b=b
_.e=_.d=_.c=null},
cF(a){throw A.K(A.kh(a),new Error())},
fi(a){var s=new A.fh(a)
return s.b=s},
fh:function fh(a){this.a=a
this.b=null},
lk(a){return a},
fM(a,b,c){},
kl(a,b,c){var s
A.fM(a,b,c)
s=new DataView(a,b)
return s},
ih(a){return new Uint8Array(a)},
km(a,b,c){var s
A.fM(a,b,c)
s=new Uint8Array(a,b,c)
return s},
b_(a,b,c){if(a>>>0!==a||a>=c)throw A.d(A.fT(b,a))},
ll(a,b,c){var s
if(!(a>>>0!==a))s=b>>>0!==b||a>b||b>c
else s=!0
if(s)throw A.d(A.lZ(a,b,c))
return b},
bT:function bT(){},
bX:function bX(){},
dv:function dv(a){this.a=a},
bU:function bU(){},
bd:function bd(){},
bV:function bV(){},
bW:function bW(){},
d1:function d1(){},
d2:function d2(){},
d3:function d3(){},
d4:function d4(){},
d5:function d5(){},
d6:function d6(){},
d7:function d7(){},
bY:function bY(){},
aW:function aW(){},
cn:function cn(){},
co:function co(){},
cp:function cp(){},
cq:function cq(){},
ho(a,b){var s=b.c
return s==null?b.c=A.cv(a,"M",[b.x]):s},
ip(a){var s=a.w
if(s===6||s===7)return A.ip(a.x)
return s===11||s===12},
kB(a){return a.as},
aE(a){return A.fE(v.typeUniverse,a,!1)},
b0(a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=a2.w
switch(a0){case 5:case 1:case 2:case 3:case 4:return a2
case 6:s=a2.x
r=A.b0(a1,s,a3,a4)
if(r===s)return a2
return A.iP(a1,r,!0)
case 7:s=a2.x
r=A.b0(a1,s,a3,a4)
if(r===s)return a2
return A.iO(a1,r,!0)
case 8:q=a2.y
p=A.bo(a1,q,a3,a4)
if(p===q)return a2
return A.cv(a1,a2.x,p)
case 9:o=a2.x
n=A.b0(a1,o,a3,a4)
m=a2.y
l=A.bo(a1,m,a3,a4)
if(n===o&&l===m)return a2
return A.hD(a1,n,l)
case 10:k=a2.x
j=a2.y
i=A.bo(a1,j,a3,a4)
if(i===j)return a2
return A.iQ(a1,k,i)
case 11:h=a2.x
g=A.b0(a1,h,a3,a4)
f=a2.y
e=A.lN(a1,f,a3,a4)
if(g===h&&e===f)return a2
return A.iN(a1,g,e)
case 12:d=a2.y
a4+=d.length
c=A.bo(a1,d,a3,a4)
o=a2.x
n=A.b0(a1,o,a3,a4)
if(c===d&&n===o)return a2
return A.hE(a1,n,c,!0)
case 13:b=a2.x
if(b<a4)return a2
a=a3[b-a4]
if(a==null)return a2
return a
default:throw A.d(A.cI("Attempted to substitute unexpected RTI kind "+a0))}},
bo(a,b,c,d){var s,r,q,p,o=b.length,n=A.fJ(o)
for(s=!1,r=0;r<o;++r){q=b[r]
p=A.b0(a,q,c,d)
if(p!==q)s=!0
n[r]=p}return s?n:b},
lO(a,b,c,d){var s,r,q,p,o,n,m=b.length,l=A.fJ(m)
for(s=!1,r=0;r<m;r+=3){q=b[r]
p=b[r+1]
o=b[r+2]
n=A.b0(a,o,c,d)
if(n!==o)s=!0
l.splice(r,3,q,p,n)}return s?l:b},
lN(a,b,c,d){var s,r=b.a,q=A.bo(a,r,c,d),p=b.b,o=A.bo(a,p,c,d),n=b.c,m=A.lO(a,n,c,d)
if(q===r&&o===p&&m===n)return b
s=new A.dq()
s.a=q
s.b=o
s.c=m
return s},
b(a,b){a[v.arrayRti]=b
return a},
j8(a){var s=a.$S
if(s!=null){if(typeof s=="number")return A.m3(s)
return a.$S()}return null},
m7(a,b){var s
if(A.ip(b))if(a instanceof A.aG){s=A.j8(a)
if(s!=null)return s}return A.b5(a)},
b5(a){if(a instanceof A.e)return A.L(a)
if(Array.isArray(a))return A.V(a)
return A.hH(J.b2(a))},
V(a){var s=a[v.arrayRti],r=t.b
if(s==null)return r
if(s.constructor!==r.constructor)return r
return s},
L(a){var s=a.$ti
return s!=null?s:A.hH(a)},
hH(a){var s=a.constructor,r=s.$ccache
if(r!=null)return r
return A.lt(a,s)},
lt(a,b){var s=a instanceof A.aG?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,r=A.l3(v.typeUniverse,s.name)
b.$ccache=r
return r},
m3(a){var s,r=v.types,q=r[a]
if(typeof q=="string"){s=A.fE(v.typeUniverse,q,!1)
r[a]=s
return s}return q},
hN(a){return A.b1(A.L(a))},
hK(a){var s
if(a instanceof A.cr)return A.m0(a.$r,a.eE())
s=a instanceof A.aG?A.j8(a):null
if(s!=null)return s
if(t.dm.b(a))return J.jI(a).a
if(Array.isArray(a))return A.V(a)
return A.b5(a)},
b1(a){var s=a.r
return s==null?a.r=new A.du(a):s},
m0(a,b){var s,r,q=b,p=q.length
if(p===0)return t.bQ
if(0>=p)return A.a(q,0)
s=A.cx(v.typeUniverse,A.hK(q[0]),"@<0>")
for(r=1;r<p;++r){if(!(r<q.length))return A.a(q,r)
s=A.iR(v.typeUniverse,s,A.hK(q[r]))}return A.cx(v.typeUniverse,s,a)},
aj(a){return A.b1(A.fE(v.typeUniverse,a,!1))},
ls(a){var s,r,q,p,o=this
if(o===t.K)return A.aD(o,a,A.lB)
if(A.b6(o))return A.aD(o,a,A.lF)
s=o.w
if(s===6)return A.aD(o,a,A.lq)
if(s===1)return A.aD(o,a,A.j_)
if(s===7)return A.aD(o,a,A.lx)
if(o===t.S)r=A.fO
else if(o===t.i||o===t.o)r=A.lA
else if(o===t.N)r=A.lD
else r=o===t.y?A.fN:null
if(r!=null)return A.aD(o,a,r)
if(s===8){q=o.x
if(o.y.every(A.b6)){o.f="$i"+q
if(q==="m")return A.aD(o,a,A.lz)
return A.aD(o,a,A.lE)}}else if(s===10){p=A.lY(o.x,o.y)
return A.aD(o,a,p==null?A.j_:p)}return A.aD(o,a,A.lo)},
aD(a,b,c){a.b=c
return a.b(b)},
lr(a){var s=this,r=A.ln
if(A.b6(s))r=A.ld
else if(s===t.K)r=A.lc
else if(A.bq(s))r=A.lp
if(s===t.S)r=A.ad
else if(s===t.h6)r=A.la
else if(s===t.N)r=A.k
else if(s===t.dk)r=A.B
else if(s===t.y)r=A.iV
else if(s===t.fQ)r=A.aB
else if(s===t.o)r=A.lb
else if(s===t.cg)r=A.iW
else if(s===t.i)r=A.l8
else if(s===t.cD)r=A.l9
s.a=r
return s.a(a)},
lo(a){var s=this
if(a==null)return A.bq(s)
return A.jc(v.typeUniverse,A.m7(a,s),s)},
lq(a){if(a==null)return!0
return this.x.b(a)},
lE(a){var s,r=this
if(a==null)return A.bq(r)
s=r.f
if(a instanceof A.e)return!!a[s]
return!!J.b2(a)[s]},
lz(a){var s,r=this
if(a==null)return A.bq(r)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
s=r.f
if(a instanceof A.e)return!!a[s]
return!!J.b2(a)[s]},
ln(a){var s=this
if(a==null){if(A.bq(s))return a}else if(s.b(a))return a
throw A.K(A.iX(a,s),new Error())},
lp(a){var s=this
if(a==null||s.b(a))return a
throw A.K(A.iX(a,s),new Error())},
iX(a,b){return new A.bm("TypeError: "+A.iG(a,A.W(b,null)))},
lU(a,b,c,d){if(A.jc(v.typeUniverse,a,b))return a
throw A.K(A.kW("The type argument '"+A.W(a,null)+"' is not a subtype of the type variable bound '"+A.W(b,null)+"' of type variable '"+c+"' in '"+d+"'."),new Error())},
iG(a,b){return A.dT(a)+": type '"+A.W(A.hK(a),null)+"' is not a subtype of type '"+b+"'"},
kW(a){return new A.bm("TypeError: "+a)},
am(a,b){return new A.bm("TypeError: "+A.iG(a,b))},
lx(a){var s=this
return s.x.b(a)||A.ho(v.typeUniverse,s).b(a)},
lB(a){return a!=null},
lc(a){if(a!=null)return a
throw A.K(A.am(a,"Object"),new Error())},
lF(a){return!0},
ld(a){return a},
j_(a){return!1},
fN(a){return!0===a||!1===a},
iV(a){if(!0===a)return!0
if(!1===a)return!1
throw A.K(A.am(a,"bool"),new Error())},
aB(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.K(A.am(a,"bool?"),new Error())},
l8(a){if(typeof a=="number")return a
throw A.K(A.am(a,"double"),new Error())},
l9(a){if(typeof a=="number")return a
if(a==null)return a
throw A.K(A.am(a,"double?"),new Error())},
fO(a){return typeof a=="number"&&Math.floor(a)===a},
ad(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.K(A.am(a,"int"),new Error())},
la(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.K(A.am(a,"int?"),new Error())},
lA(a){return typeof a=="number"},
lb(a){if(typeof a=="number")return a
throw A.K(A.am(a,"num"),new Error())},
iW(a){if(typeof a=="number")return a
if(a==null)return a
throw A.K(A.am(a,"num?"),new Error())},
lD(a){return typeof a=="string"},
k(a){if(typeof a=="string")return a
throw A.K(A.am(a,"String"),new Error())},
B(a){if(typeof a=="string")return a
if(a==null)return a
throw A.K(A.am(a,"String?"),new Error())},
j4(a,b){var s,r,q
for(s="",r="",q=0;q<a.length;++q,r=", ")s+=r+A.W(a[q],b)
return s},
lI(a,b){var s,r,q,p,o,n,m=a.x,l=a.y
if(""===m)return"("+A.j4(l,b)+")"
s=l.length
r=m.split(",")
q=r.length-s
for(p="(",o="",n=0;n<s;++n,o=", "){p+=o
if(q===0)p+="{"
p+=A.W(l[n],b)
if(q>=0)p+=" "+r[q];++q}return p+"})"},
iY(a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=", ",a2=null
if(a5!=null){s=a5.length
if(a4==null)a4=A.b([],t.s)
else a2=a4.length
r=a4.length
for(q=s;q>0;--q)B.a.m(a4,"T"+(r+q))
for(p=t.X,o="<",n="",q=0;q<s;++q,n=a1){m=a4.length
l=m-1-q
if(!(l>=0))return A.a(a4,l)
o=o+n+a4[l]
k=a5[q]
j=k.w
if(!(j===2||j===3||j===4||j===5||k===p))o+=" extends "+A.W(k,a4)}o+=">"}else o=""
p=a3.x
i=a3.y
h=i.a
g=h.length
f=i.b
e=f.length
d=i.c
c=d.length
b=A.W(p,a4)
for(a="",a0="",q=0;q<g;++q,a0=a1)a+=a0+A.W(h[q],a4)
if(e>0){a+=a0+"["
for(a0="",q=0;q<e;++q,a0=a1)a+=a0+A.W(f[q],a4)
a+="]"}if(c>0){a+=a0+"{"
for(a0="",q=0;q<c;q+=3,a0=a1){a+=a0
if(d[q+1])a+="required "
a+=A.W(d[q+2],a4)+" "+d[q]}a+="}"}if(a2!=null){a4.toString
a4.length=a2}return o+"("+a+") => "+b},
W(a,b){var s,r,q,p,o,n,m,l=a.w
if(l===5)return"erased"
if(l===2)return"dynamic"
if(l===3)return"void"
if(l===1)return"Never"
if(l===4)return"any"
if(l===6){s=a.x
r=A.W(s,b)
q=s.w
return(q===11||q===12?"("+r+")":r)+"?"}if(l===7)return"FutureOr<"+A.W(a.x,b)+">"
if(l===8){p=A.lP(a.x)
o=a.y
return o.length>0?p+("<"+A.j4(o,b)+">"):p}if(l===10)return A.lI(a,b)
if(l===11)return A.iY(a,b,null)
if(l===12)return A.iY(a.x,b,a.y)
if(l===13){n=a.x
m=b.length
n=m-1-n
if(!(n>=0&&n<m))return A.a(b,n)
return b[n]}return"?"},
lP(a){var s=v.mangledGlobalNames[a]
if(s!=null)return s
return"minified:"+a},
l4(a,b){var s=a.tR[b]
for(;typeof s=="string";)s=a.tR[s]
return s},
l3(a,b){var s,r,q,p,o,n=a.eT,m=n[b]
if(m==null)return A.fE(a,b,!1)
else if(typeof m=="number"){s=m
r=A.cw(a,5,"#")
q=A.fJ(s)
for(p=0;p<s;++p)q[p]=r
o=A.cv(a,b,q)
n[b]=o
return o}else return m},
l2(a,b){return A.iT(a.tR,b)},
l1(a,b){return A.iT(a.eT,b)},
fE(a,b,c){var s,r=a.eC,q=r.get(b)
if(q!=null)return q
s=A.iL(A.iJ(a,null,b,!1))
r.set(b,s)
return s},
cx(a,b,c){var s,r,q=b.z
if(q==null)q=b.z=new Map()
s=q.get(c)
if(s!=null)return s
r=A.iL(A.iJ(a,b,c,!0))
q.set(c,r)
return r},
iR(a,b,c){var s,r,q,p=b.Q
if(p==null)p=b.Q=new Map()
s=c.as
r=p.get(s)
if(r!=null)return r
q=A.hD(a,b,c.w===9?c.y:[c])
p.set(s,q)
return q},
aO(a,b){b.a=A.lr
b.b=A.ls
return b},
cw(a,b,c){var s,r,q=a.eC.get(c)
if(q!=null)return q
s=new A.ac(null,null)
s.w=b
s.as=c
r=A.aO(a,s)
a.eC.set(c,r)
return r},
iP(a,b,c){var s,r=b.as+"?",q=a.eC.get(r)
if(q!=null)return q
s=A.l_(a,b,r,c)
a.eC.set(r,s)
return s},
l_(a,b,c,d){var s,r,q
if(d){s=b.w
r=!0
if(!A.b6(b))if(!(b===t.P||b===t.T))if(s!==6)r=s===7&&A.bq(b.x)
if(r)return b
else if(s===1)return t.P}q=new A.ac(null,null)
q.w=6
q.x=b
q.as=c
return A.aO(a,q)},
iO(a,b,c){var s,r=b.as+"/",q=a.eC.get(r)
if(q!=null)return q
s=A.kY(a,b,r,c)
a.eC.set(r,s)
return s},
kY(a,b,c,d){var s,r
if(d){s=b.w
if(A.b6(b)||b===t.K)return b
else if(s===1)return A.cv(a,"M",[b])
else if(b===t.P||b===t.T)return t.eH}r=new A.ac(null,null)
r.w=7
r.x=b
r.as=c
return A.aO(a,r)},
l0(a,b){var s,r,q=""+b+"^",p=a.eC.get(q)
if(p!=null)return p
s=new A.ac(null,null)
s.w=13
s.x=b
s.as=q
r=A.aO(a,s)
a.eC.set(q,r)
return r},
cu(a){var s,r,q,p=a.length
for(s="",r="",q=0;q<p;++q,r=",")s+=r+a[q].as
return s},
kX(a){var s,r,q,p,o,n=a.length
for(s="",r="",q=0;q<n;q+=3,r=","){p=a[q]
o=a[q+1]?"!":":"
s+=r+p+o+a[q+2].as}return s},
cv(a,b,c){var s,r,q,p=b
if(c.length>0)p+="<"+A.cu(c)+">"
s=a.eC.get(p)
if(s!=null)return s
r=new A.ac(null,null)
r.w=8
r.x=b
r.y=c
if(c.length>0)r.c=c[0]
r.as=p
q=A.aO(a,r)
a.eC.set(p,q)
return q},
hD(a,b,c){var s,r,q,p,o,n
if(b.w===9){s=b.x
r=b.y.concat(c)}else{r=c
s=b}q=s.as+(";<"+A.cu(r)+">")
p=a.eC.get(q)
if(p!=null)return p
o=new A.ac(null,null)
o.w=9
o.x=s
o.y=r
o.as=q
n=A.aO(a,o)
a.eC.set(q,n)
return n},
iQ(a,b,c){var s,r,q="+"+(b+"("+A.cu(c)+")"),p=a.eC.get(q)
if(p!=null)return p
s=new A.ac(null,null)
s.w=10
s.x=b
s.y=c
s.as=q
r=A.aO(a,s)
a.eC.set(q,r)
return r},
iN(a,b,c){var s,r,q,p,o,n=b.as,m=c.a,l=m.length,k=c.b,j=k.length,i=c.c,h=i.length,g="("+A.cu(m)
if(j>0){s=l>0?",":""
g+=s+"["+A.cu(k)+"]"}if(h>0){s=l>0?",":""
g+=s+"{"+A.kX(i)+"}"}r=n+(g+")")
q=a.eC.get(r)
if(q!=null)return q
p=new A.ac(null,null)
p.w=11
p.x=b
p.y=c
p.as=r
o=A.aO(a,p)
a.eC.set(r,o)
return o},
hE(a,b,c,d){var s,r=b.as+("<"+A.cu(c)+">"),q=a.eC.get(r)
if(q!=null)return q
s=A.kZ(a,b,c,r,d)
a.eC.set(r,s)
return s},
kZ(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(e){s=c.length
r=A.fJ(s)
for(q=0,p=0;p<s;++p){o=c[p]
if(o.w===1){r[p]=o;++q}}if(q>0){n=A.b0(a,b,r,0)
m=A.bo(a,c,r,0)
return A.hE(a,n,m,c!==m)}}l=new A.ac(null,null)
l.w=12
l.x=b
l.y=c
l.as=d
return A.aO(a,l)},
iJ(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
iL(a){var s,r,q,p,o,n,m,l=a.r,k=a.s
for(s=l.length,r=0;r<s;){q=l.charCodeAt(r)
if(q>=48&&q<=57)r=A.kQ(r+1,q,l,k)
else if((((q|32)>>>0)-97&65535)<26||q===95||q===36||q===124)r=A.iK(a,r,l,k,!1)
else if(q===46)r=A.iK(a,r,l,k,!0)
else{++r
switch(q){case 44:break
case 58:k.push(!1)
break
case 33:k.push(!0)
break
case 59:k.push(A.aZ(a.u,a.e,k.pop()))
break
case 94:k.push(A.l0(a.u,k.pop()))
break
case 35:k.push(A.cw(a.u,5,"#"))
break
case 64:k.push(A.cw(a.u,2,"@"))
break
case 126:k.push(A.cw(a.u,3,"~"))
break
case 60:k.push(a.p)
a.p=k.length
break
case 62:A.kS(a,k)
break
case 38:A.kR(a,k)
break
case 63:p=a.u
k.push(A.iP(p,A.aZ(p,a.e,k.pop()),a.n))
break
case 47:p=a.u
k.push(A.iO(p,A.aZ(p,a.e,k.pop()),a.n))
break
case 40:k.push(-3)
k.push(a.p)
a.p=k.length
break
case 41:A.kP(a,k)
break
case 91:k.push(a.p)
a.p=k.length
break
case 93:o=k.splice(a.p)
A.iM(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-1)
break
case 123:k.push(a.p)
a.p=k.length
break
case 125:o=k.splice(a.p)
A.kU(a.u,a.e,o)
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
return A.aZ(a.u,a.e,m)},
kQ(a,b,c,d){var s,r,q=b-48
for(s=c.length;a<s;++a){r=c.charCodeAt(a)
if(!(r>=48&&r<=57))break
q=q*10+(r-48)}d.push(q)
return a},
iK(a,b,c,d,e){var s,r,q,p,o,n,m=b+1
for(s=c.length;m<s;++m){r=c.charCodeAt(m)
if(r===46){if(e)break
e=!0}else{if(!((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124))q=r>=48&&r<=57
else q=!0
if(!q)break}}p=c.substring(b,m)
if(e){s=a.u
o=a.e
if(o.w===9)o=o.x
n=A.l4(s,o.x)[p]
if(n==null)A.X('No "'+p+'" in "'+A.kB(o)+'"')
d.push(A.cx(s,o,n))}else d.push(p)
return m},
kS(a,b){var s,r=a.u,q=A.iI(a,b),p=b.pop()
if(typeof p=="string")b.push(A.cv(r,p,q))
else{s=A.aZ(r,a.e,p)
switch(s.w){case 11:b.push(A.hE(r,s,q,a.n))
break
default:b.push(A.hD(r,s,q))
break}}},
kP(a,b){var s,r,q,p=a.u,o=b.pop(),n=null,m=null
if(typeof o=="number")switch(o){case-1:n=b.pop()
break
case-2:m=b.pop()
break
default:b.push(o)
break}else b.push(o)
s=A.iI(a,b)
o=b.pop()
switch(o){case-3:o=b.pop()
if(n==null)n=p.sEA
if(m==null)m=p.sEA
r=A.aZ(p,a.e,o)
q=new A.dq()
q.a=s
q.b=n
q.c=m
b.push(A.iN(p,r,q))
return
case-4:b.push(A.iQ(p,b.pop(),s))
return
default:throw A.d(A.cI("Unexpected state under `()`: "+A.n(o)))}},
kR(a,b){var s=b.pop()
if(0===s){b.push(A.cw(a.u,1,"0&"))
return}if(1===s){b.push(A.cw(a.u,4,"1&"))
return}throw A.d(A.cI("Unexpected extended operation "+A.n(s)))},
iI(a,b){var s=b.splice(a.p)
A.iM(a.u,a.e,s)
a.p=b.pop()
return s},
aZ(a,b,c){if(typeof c=="string")return A.cv(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.kT(a,b,c)}else return c},
iM(a,b,c){var s,r=c.length
for(s=0;s<r;++s)c[s]=A.aZ(a,b,c[s])},
kU(a,b,c){var s,r=c.length
for(s=2;s<r;s+=3)c[s]=A.aZ(a,b,c[s])},
kT(a,b,c){var s,r,q=b.w
if(q===9){if(c===0)return b.x
s=b.y
r=s.length
if(c<=r)return s[c-1]
c-=r
b=b.x
q=b.w}else if(c===0)return b
if(q!==8)throw A.d(A.cI("Indexed base must be an interface type"))
s=b.y
if(c<=s.length)return s[c-1]
throw A.d(A.cI("Bad index "+c+" for "+b.i(0)))},
jc(a,b,c){var s,r=b.d
if(r==null)r=b.d=new Map()
s=r.get(c)
if(s==null){s=A.G(a,b,null,c,null)
r.set(c,s)}return s},
G(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i
if(b===d)return!0
if(A.b6(d))return!0
s=b.w
if(s===4)return!0
if(A.b6(b))return!1
if(b.w===1)return!0
r=s===13
if(r)if(A.G(a,c[b.x],c,d,e))return!0
q=d.w
p=t.P
if(b===p||b===t.T){if(q===7)return A.G(a,b,c,d.x,e)
return d===p||d===t.T||q===6}if(d===t.K){if(s===7)return A.G(a,b.x,c,d,e)
return s!==6}if(s===7){if(!A.G(a,b.x,c,d,e))return!1
return A.G(a,A.ho(a,b),c,d,e)}if(s===6)return A.G(a,p,c,d,e)&&A.G(a,b.x,c,d,e)
if(q===7){if(A.G(a,b,c,d.x,e))return!0
return A.G(a,b,c,A.ho(a,d),e)}if(q===6)return A.G(a,b,c,p,e)||A.G(a,b,c,d.x,e)
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
if(!A.G(a,j,c,i,e)||!A.G(a,i,e,j,c))return!1}return A.iZ(a,b.x,c,d.x,e)}if(q===11){if(b===t.g)return!0
if(p)return!1
return A.iZ(a,b,c,d,e)}if(s===8){if(q!==8)return!1
return A.ly(a,b,c,d,e)}if(o&&q===10)return A.lC(a,b,c,d,e)
return!1},
iZ(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
if(!A.G(a3,a4.x,a5,a6.x,a7))return!1
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
if(!A.G(a3,p[h],a7,g,a5))return!1}for(h=0;h<m;++h){g=l[h]
if(!A.G(a3,p[o+h],a7,g,a5))return!1}for(h=0;h<i;++h){g=l[m+h]
if(!A.G(a3,k[h],a7,g,a5))return!1}f=s.c
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
if(!A.G(a3,e[a+2],a7,g,a5))return!1
break}}for(;b<d;){if(f[b+1])return!1
b+=3}return!0},
ly(a,b,c,d,e){var s,r,q,p,o,n=b.x,m=d.x
for(;n!==m;){s=a.tR[n]
if(s==null)return!1
if(typeof s=="string"){n=s
continue}r=s[m]
if(r==null)return!1
q=r.length
p=q>0?new Array(q):v.typeUniverse.sEA
for(o=0;o<q;++o)p[o]=A.cx(a,b,r[o])
return A.iU(a,p,null,c,d.y,e)}return A.iU(a,b.y,null,c,d.y,e)},
iU(a,b,c,d,e,f){var s,r=b.length
for(s=0;s<r;++s)if(!A.G(a,b[s],d,e[s],f))return!1
return!0},
lC(a,b,c,d,e){var s,r=b.y,q=d.y,p=r.length
if(p!==q.length)return!1
if(b.x!==d.x)return!1
for(s=0;s<p;++s)if(!A.G(a,r[s],c,q[s],e))return!1
return!0},
bq(a){var s=a.w,r=!0
if(!(a===t.P||a===t.T))if(!A.b6(a))if(s!==6)r=s===7&&A.bq(a.x)
return r},
b6(a){var s=a.w
return s===2||s===3||s===4||s===5||a===t.X},
iT(a,b){var s,r,q=Object.keys(b),p=q.length
for(s=0;s<p;++s){r=q[s]
a[r]=b[r]}},
fJ(a){return a>0?new Array(a):v.typeUniverse.sEA},
ac:function ac(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.d=_.c=null
_.w=0
_.as=_.Q=_.z=_.y=_.x=null},
dq:function dq(){this.c=this.b=this.a=null},
du:function du(a){this.a=a},
dp:function dp(){},
bm:function bm(a){this.a=a},
kH(){var s,r,q
if(self.scheduleImmediate!=null)return A.lR()
if(self.MutationObserver!=null&&self.document!=null){s={}
r=self.document.createElement("div")
q=self.document.createElement("span")
s.a=null
new self.MutationObserver(A.cE(new A.f8(s),1)).observe(r,{childList:true})
return new A.f7(s,r,q)}else if(self.setImmediate!=null)return A.lS()
return A.lT()},
kI(a){self.scheduleImmediate(A.cE(new A.f9(t.M.a(a)),0))},
kJ(a){self.setImmediate(A.cE(new A.fa(t.M.a(a)),0))},
kK(a){A.hs(B.P,t.M.a(a))},
hs(a,b){return A.kV(0,b)},
kV(a,b){var s=new A.fA()
s.cl(a,b)
return s},
ah(a){return new A.cg(new A.q($.u,a.h("q<0>")),a.h("cg<0>"))},
ag(a,b){a.$2(0,null)
b.b=!0
return b.a},
aC(a,b){b.toString
A.le(a,b)},
af(a,b){b.a8(a)},
ae(a,b){b.b9(A.ao(a),A.aP(a))},
le(a,b){var s,r,q=new A.fK(b),p=new A.fL(b)
if(a instanceof A.q)a.bQ(q,p,t.z)
else{s=t.z
if(a instanceof A.q)a.aq(q,p,s)
else{r=new A.q($.u,t._)
r.a=8
r.c=a
r.bQ(q,p,s)}}},
ai(a){var s=function(b,c){return function(d,e){while(true){try{b(d,e)
break}catch(r){e=r
d=c}}}}(a,1)
return $.u.c0(new A.fQ(s),t.H,t.S,t.z)},
ha(a){var s
if(t.C.b(a)){s=a.gaa()
if(s!=null)return s}return B.p},
k4(a,b){var s
if(!b.b(null))throw A.d(A.dD(null,"computation","The type parameter is not nullable"))
s=new A.q($.u,b.h("q<0>"))
A.kF(a,new A.e_(null,s,b))
return s},
lu(a,b){if($.u===B.h)return null
return null},
lv(a,b){if($.u!==B.h)A.lu(a,b)
if(b==null)if(t.C.b(a)){b=a.gaa()
if(b==null){A.im(a,B.p)
b=B.p}}else b=B.p
else if(t.C.b(a))A.im(a,b)
return new A.a3(a,b)},
hz(a,b){var s=new A.q($.u,b.h("q<0>"))
b.a(a)
s.a=8
s.c=a
return s},
fo(a,b,c){var s,r,q,p,o={},n=o.a=a
for(s=t._;r=n.a,(r&4)!==0;n=a){a=s.a(n.c)
o.a=a}if(n===b){s=A.kC()
b.aX(new A.a3(new A.a8(!0,n,null,"Cannot complete a future with itself"),s))
return}q=b.a&1
s=n.a=r|q
if((s&24)===0){p=t.F.a(b.c)
b.a=b.a&1|4
b.c=n
n.bH(p)
return}if(!c)if(b.c==null)n=(s&16)===0||q!==0
else n=!1
else n=!0
if(n){p=b.aj()
b.az(o.a)
A.aY(b,p)
return}b.a^=2
A.dx(null,null,b.b,t.M.a(new A.fp(o,b)))},
aY(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d={},c=d.a=a
for(s=t.n,r=t.F;!0;){q={}
p=c.a
o=(p&16)===0
n=!o
if(b==null){if(n&&(p&1)===0){m=s.a(c.c)
A.hJ(m.a,m.b)}return}q.a=b
l=b.a
for(c=b;l!=null;c=l,l=k){c.a=null
A.aY(d.a,c)
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
A.hJ(j.a,j.b)
return}g=$.u
if(g!==h)$.u=h
else g=null
c=c.c
if((c&15)===8)new A.ft(q,d,n).$0()
else if(o){if((c&1)!==0)new A.fs(q,j).$0()}else if((c&2)!==0)new A.fr(d,q).$0()
if(g!=null)$.u=g
c=q.c
if(c instanceof A.q){p=q.a.$ti
p=p.h("M<2>").b(c)||!p.y[1].b(c)}else p=!1
if(p){f=q.a.b
if((c.a&24)!==0){e=r.a(f.c)
f.c=null
b=f.aE(e)
f.a=c.a&30|f.a&1
f.c=c.c
d.a=c
continue}else A.fo(c,f,!0)
return}}f=q.a.b
e=r.a(f.c)
f.c=null
b=f.aE(e)
c=q.b
p=q.c
if(!c){f.$ti.c.a(p)
f.a=8
f.c=p}else{s.a(p)
f.a=f.a&1|16
f.c=p}d.a=f
c=f}},
j2(a,b){var s
if(t.Q.b(a))return b.c0(a,t.z,t.K,t.l)
s=t.v
if(s.b(a))return s.a(a)
throw A.d(A.dD(a,"onError",u.c))},
lH(){var s,r
for(s=$.bn;s!=null;s=$.bn){$.cB=null
r=s.b
$.bn=r
if(r==null)$.cA=null
s.a.$0()}},
lM(){$.hI=!0
try{A.lH()}finally{$.cB=null
$.hI=!1
if($.bn!=null)$.hU().$1(A.j7())}},
j5(a){var s=new A.dl(a),r=$.cA
if(r==null){$.bn=$.cA=s
if(!$.hI)$.hU().$1(A.j7())}else $.cA=r.b=s},
lL(a){var s,r,q,p=$.bn
if(p==null){A.j5(a)
$.cB=$.cA
return}s=new A.dl(a)
r=$.cB
if(r==null){s.b=p
$.bn=$.cB=s}else{q=r.b
s.b=q
$.cB=r.b=s
if(q==null)$.cA=s}},
mk(a,b){A.cD(a,"stream",t.K)
return new A.ds(b.h("ds<0>"))},
kF(a,b){var s=$.u
if(s===B.h)return A.hs(a,t.M.a(b))
return A.hs(a,t.M.a(s.bU(b)))},
hJ(a,b){A.lL(new A.fP(a,b))},
j3(a,b,c,d,e){var s,r=$.u
if(r===c)return d.$0()
$.u=c
s=r
try{r=d.$0()
return r}finally{$.u=s}},
lK(a,b,c,d,e,f,g){var s,r=$.u
if(r===c)return d.$1(e)
$.u=c
s=r
try{r=d.$1(e)
return r}finally{$.u=s}},
lJ(a,b,c,d,e,f,g,h,i){var s,r=$.u
if(r===c)return d.$2(e,f)
$.u=c
s=r
try{r=d.$2(e,f)
return r}finally{$.u=s}},
dx(a,b,c,d){t.M.a(d)
if(B.h!==c)d=c.bU(d)
A.j5(d)},
f8:function f8(a){this.a=a},
f7:function f7(a,b,c){this.a=a
this.b=b
this.c=c},
f9:function f9(a){this.a=a},
fa:function fa(a){this.a=a},
fA:function fA(){},
fB:function fB(a,b){this.a=a
this.b=b},
cg:function cg(a,b){this.a=a
this.b=!1
this.$ti=b},
fK:function fK(a){this.a=a},
fL:function fL(a){this.a=a},
fQ:function fQ(a){this.a=a},
a3:function a3(a,b){this.a=a
this.b=b},
e_:function e_(a,b,c){this.a=a
this.b=b
this.c=c},
bk:function bk(){},
az:function az(a,b){this.a=a
this.$ti=b},
ct:function ct(a,b){this.a=a
this.$ti=b},
aA:function aA(a,b,c,d,e){var _=this
_.a=null
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
q:function q(a,b){var _=this
_.a=0
_.b=a
_.c=null
_.$ti=b},
fl:function fl(a,b){this.a=a
this.b=b},
fq:function fq(a,b){this.a=a
this.b=b},
fp:function fp(a,b){this.a=a
this.b=b},
fn:function fn(a,b){this.a=a
this.b=b},
fm:function fm(a,b){this.a=a
this.b=b},
ft:function ft(a,b,c){this.a=a
this.b=b
this.c=c},
fu:function fu(a,b){this.a=a
this.b=b},
fv:function fv(a){this.a=a},
fs:function fs(a,b){this.a=a
this.b=b},
fr:function fr(a,b){this.a=a
this.b=b},
dl:function dl(a){this.a=a
this.b=null},
ds:function ds(a){this.$ti=a},
cy:function cy(){},
fP:function fP(a,b){this.a=a
this.b=b},
dr:function dr(){},
fz:function fz(a,b){this.a=a
this.b=b},
iH(a,b){var s=a[b]
return s===a?null:s},
hB(a,b,c){if(c==null)a[b]=a
else a[b]=c},
hA(){var s=Object.create(null)
A.hB(s,"<non-identifier-key>",s)
delete s["<non-identifier-key>"]
return s},
z(a,b,c){return b.h("@<0>").u(c).h("hl<1,2>").a(A.j9(a,new A.as(b.h("@<0>").u(c).h("as<1,2>"))))},
d_(a,b){return new A.as(a.h("@<0>").u(b).h("as<1,2>"))},
hn(a){var s,r
if(A.hP(a))return"{...}"
s=new A.bi("")
try{r={}
B.a.m($.a2,a)
s.a+="{"
r.a=!0
a.am(0,new A.ez(r,s))
s.a+="}"}finally{if(0>=$.a2.length)return A.a($.a2,-1)
$.a2.pop()}r=s.a
return r.charCodeAt(0)==0?r:r},
ck:function ck(){},
bl:function bl(a){var _=this
_.a=0
_.e=_.d=_.c=_.b=null
_.$ti=a},
cl:function cl(a,b){this.a=a
this.$ti=b},
cm:function cm(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
p:function p(){},
aL:function aL(){},
ez:function ez(a,b){this.a=a
this.b=b},
l6(a,b,c){var s,r,q,p,o=c-b
if(o<=4096)s=$.jD()
else s=new Uint8Array(o)
for(r=0;r<o;++r){q=b+r
if(!(q<a.length))return A.a(a,q)
p=a[q]
if((p&255)!==p)p=255
s[r]=p}return s},
l5(a,b,c,d){var s=a?$.jC():$.jB()
if(s==null)return null
if(0===c&&d===b.length)return A.iS(s,b)
return A.iS(s,b.subarray(c,d))},
iS(a,b){var s,r
try{s=a.decode(b)
return s}catch(r){}return null},
l7(a){switch(a){case 65:return"Missing extension byte"
case 67:return"Unexpected extension byte"
case 69:return"Invalid UTF-8 byte"
case 71:return"Overlong encoding"
case 73:return"Out of unicode range"
case 75:return"Encoded surrogate"
case 77:return"Unfinished UTF-8 octet sequence"
default:return""}},
fH:function fH(){},
fG:function fG(){},
cG:function cG(){},
fD:function fD(){},
dF:function dF(){},
fC:function fC(){},
dE:function dE(a){this.a=a},
by:function by(){},
cO:function cO(){},
cS:function cS(){},
f2:function f2(){},
fI:function fI(a){this.b=0
this.c=a},
dk:function dk(a){this.a=a},
fF:function fF(a){this.a=a
this.b=16
this.c=0},
O(a,b){var s,r=b.length
while(!0){if(a>0){s=a-1
if(!(s<r))return A.a(b,s)
s=b[s]===0}else s=!1
if(!s)break;--a}return a},
hx(a,b,c,d){var s,r,q,p=new Uint16Array(d),o=c-b
for(s=a.length,r=0;r<o;++r){q=b+r
if(!(q>=0&&q<s))return A.a(a,q)
q=a[q]
if(!(r<d))return A.a(p,r)
p[r]=q}return p},
ch(a){var s
if(a===0)return $.P()
if(a===1)return $.aF()
if(a===2)return $.jA()
if(Math.abs(a)<4294967296)return A.dm(B.b.aN(a))
s=A.kL(a)
return s},
dm(a){var s,r,q,p,o=a<0
if(o){if(a===-9223372036854776e3){s=new Uint16Array(4)
s[3]=32768
r=A.O(4,s)
return new A.E(r!==0,s,r)}a=-a}if(a<65536){s=new Uint16Array(1)
s[0]=a
r=A.O(1,s)
return new A.E(r===0?!1:o,s,r)}if(a<=4294967295){s=new Uint16Array(2)
s[0]=a&65535
s[1]=B.b.a5(a,16)
r=A.O(2,s)
return new A.E(r===0?!1:o,s,r)}r=B.b.I(B.b.gak(a)-1,16)+1
s=new Uint16Array(r)
for(q=0;a!==0;q=p){p=q+1
if(!(q<r))return A.a(s,q)
s[q]=a&65535
a=B.b.I(a,65536)}r=A.O(r,s)
return new A.E(r===0?!1:o,s,r)},
kL(a){var s,r,q,p,o,n,m,l
if(isNaN(a)||a==1/0||a==-1/0)throw A.d(A.a_("Value must be finite: "+a,null))
s=a<0
if(s)a=-a
a=Math.floor(a)
if(a===0)return $.P()
r=$.jz()
for(q=r.$flags|0,p=0;p<8;++p){q&2&&A.x(r)
if(!(p<8))return A.a(r,p)
r[p]=0}q=J.jG(B.aC.gbV(r))
q.$flags&2&&A.x(q,13)
q.setFloat64(0,a,!0)
o=(r[7]<<4>>>0)+(r[6]>>>4)-1075
n=new Uint16Array(4)
n[0]=(r[1]<<8>>>0)+r[0]
n[1]=(r[3]<<8>>>0)+r[2]
n[2]=(r[5]<<8>>>0)+r[4]
n[3]=r[6]&15|16
m=new A.E(!1,n,4)
if(o<0)l=m.aS(0,-o)
else l=o>0?m.a1(0,o):m
if(s)return l.a0(0)
return l},
hy(a,b,c,d){var s,r,q,p,o
if(b===0)return 0
if(c===0&&d===a)return b
for(s=b-1,r=a.length,q=d.$flags|0;s>=0;--s){p=s+c
if(!(s<r))return A.a(a,s)
o=a[s]
q&2&&A.x(d)
if(!(p>=0&&p<d.length))return A.a(d,p)
d[p]=o}for(s=c-1;s>=0;--s){q&2&&A.x(d)
if(!(s<d.length))return A.a(d,s)
d[s]=0}return b+c},
iE(a,b,c,d){var s,r,q,p,o,n,m,l=B.b.I(c,16),k=B.b.a_(c,16),j=16-k,i=B.b.a1(1,j)-1
for(s=b-1,r=a.length,q=d.$flags|0,p=0;s>=0;--s){if(!(s<r))return A.a(a,s)
o=a[s]
n=s+l+1
m=B.b.b7(o,j)
q&2&&A.x(d)
if(!(n>=0&&n<d.length))return A.a(d,n)
d[n]=(m|p)>>>0
p=B.b.a1(o&i,k)}q&2&&A.x(d)
if(!(l>=0&&l<d.length))return A.a(d,l)
d[l]=p},
iz(a,b,c,d){var s,r,q,p=B.b.I(c,16)
if(B.b.a_(c,16)===0)return A.hy(a,b,p,d)
s=b+p+1
A.iE(a,b,c,d)
for(r=d.$flags|0,q=p;--q,q>=0;){r&2&&A.x(d)
if(!(q<d.length))return A.a(d,q)
d[q]=0}r=s-1
if(!(r>=0&&r<d.length))return A.a(d,r)
if(d[r]===0)s=r
return s},
kO(a,b,c,d){var s,r,q,p,o,n,m=B.b.I(c,16),l=B.b.a_(c,16),k=16-l,j=B.b.a1(1,l)-1,i=a.length
if(!(m>=0&&m<i))return A.a(a,m)
s=B.b.b7(a[m],l)
r=b-m-1
for(q=d.$flags|0,p=0;p<r;++p){o=p+m+1
if(!(o<i))return A.a(a,o)
n=a[o]
o=B.b.a1(n&j,k)
q&2&&A.x(d)
if(!(p<d.length))return A.a(d,p)
d[p]=(o|s)>>>0
s=B.b.b7(n,l)}q&2&&A.x(d)
if(!(r>=0&&r<d.length))return A.a(d,r)
d[r]=s},
fe(a,b,c,d){var s,r,q,p,o=b-d
if(o===0)for(s=b-1,r=a.length,q=c.length;s>=0;--s){if(!(s<r))return A.a(a,s)
p=a[s]
if(!(s<q))return A.a(c,s)
o=p-c[s]
if(o!==0)return o}return o},
kM(a,b,c,d,e){var s,r,q,p,o,n
for(s=a.length,r=c.length,q=e.$flags|0,p=0,o=0;o<d;++o){if(!(o<s))return A.a(a,o)
n=a[o]
if(!(o<r))return A.a(c,o)
p+=n+c[o]
q&2&&A.x(e)
if(!(o<e.length))return A.a(e,o)
e[o]=p&65535
p=p>>>16}for(o=d;o<b;++o){if(!(o>=0&&o<s))return A.a(a,o)
p+=a[o]
q&2&&A.x(e)
if(!(o<e.length))return A.a(e,o)
e[o]=p&65535
p=p>>>16}q&2&&A.x(e)
if(!(b>=0&&b<e.length))return A.a(e,b)
e[b]=p},
dn(a,b,c,d,e){var s,r,q,p,o,n
for(s=a.length,r=c.length,q=e.$flags|0,p=0,o=0;o<d;++o){if(!(o<s))return A.a(a,o)
n=a[o]
if(!(o<r))return A.a(c,o)
p+=n-c[o]
q&2&&A.x(e)
if(!(o<e.length))return A.a(e,o)
e[o]=p&65535
p=0-(B.b.a5(p,16)&1)}for(o=d;o<b;++o){if(!(o>=0&&o<s))return A.a(a,o)
p+=a[o]
q&2&&A.x(e)
if(!(o<e.length))return A.a(e,o)
e[o]=p&65535
p=0-(B.b.a5(p,16)&1)}},
iF(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k
if(a===0)return
for(s=b.length,r=d.length,q=d.$flags|0,p=0;--f,f>=0;e=l,c=o){o=c+1
if(!(c<s))return A.a(b,c)
n=b[c]
if(!(e>=0&&e<r))return A.a(d,e)
m=a*n+d[e]+p
l=e+1
q&2&&A.x(d)
d[e]=m&65535
p=B.b.I(m,65536)}for(;p!==0;e=l){if(!(e>=0&&e<r))return A.a(d,e)
k=d[e]+p
l=e+1
q&2&&A.x(d)
d[e]=k&65535
p=B.b.I(k,65536)}},
kN(a,b,c){var s,r,q,p=b.length
if(!(c>=0&&c<p))return A.a(b,c)
s=b[c]
if(s===a)return 65535
r=c-1
if(!(r>=0&&r<p))return A.a(b,r)
q=B.b.cj((s<<16|b[r])>>>0,a)
if(q>65535)return 65535
return q},
k1(a,b){a=A.K(a,new Error())
if(a==null)a=t.K.a(a)
a.stack=b.i(0)
throw a},
ab(a,b,c,d){var s,r=c?J.ia(a,d):J.i9(a,d)
if(a!==0&&b!=null)for(s=0;s<r.length;++s)r[s]=b
return r},
bQ(a,b,c){var s,r=A.b([],c.h("o<0>"))
for(s=J.aR(a);s.p();)B.a.m(r,c.a(s.gt()))
if(b)return r
r.$flags=1
return r},
a6(a,b){var s,r
if(Array.isArray(a))return A.b(a.slice(0),b.h("o<0>"))
s=A.b([],b.h("o<0>"))
for(r=J.aR(a);r.p();)B.a.m(s,r.gt())
return s},
kk(a,b,c){var s,r=J.ia(a,c)
for(s=0;s<a;++s)B.a.l(r,s,b.$1(s))
return r},
hm(a,b){var s=A.bQ(a,!1,b)
s.$flags=3
return s},
it(a,b,c){var s,r,q,p
A.dd(b,"start")
s=c-b
if(s<0)throw A.d(A.a1(c,b,null,"end",null))
if(s===0)return""
if(Array.isArray(a)){r=a
q=r.length
return A.il(b>0||c<q?r.slice(b,c):r)}if(t.bm.b(a))return A.kE(a,b,c)
a=J.jK(a,c)
if(b>0)a=J.jJ(a,b)
p=A.a6(a,t.S)
return A.il(p)},
kE(a,b,c){var s=a.length
if(b>=s)return""
return A.ky(a,b,c==null||c>s?s:c)},
kA(a){return new A.cY(a,A.kf(a,!1,!0,!1,!1,""))},
iq(a,b,c){var s=J.aR(b)
if(!s.p())return a
if(c.length===0){do a+=A.n(s.gt())
while(s.p())}else{a+=A.n(s.gt())
for(;s.p();)a=a+c+A.n(s.gt())}return a},
kC(){return A.aP(new Error())},
k_(a){var s=Math.abs(a),r=a<0?"-":""
if(s>=1000)return""+a
if(s>=100)return r+"0"+s
if(s>=10)return r+"00"+s
return r+"000"+s},
i5(a){if(a>=100)return""+a
if(a>=10)return"0"+a
return"00"+a},
cQ(a){if(a>=10)return""+a
return"0"+a},
dT(a){if(typeof a=="number"||A.fN(a)||a==null)return J.Z(a)
if(typeof a=="string")return JSON.stringify(a)
return A.kw(a)},
k2(a,b){A.cD(a,"error",t.K)
A.cD(b,"stackTrace",t.l)
A.k1(a,b)},
cI(a){return new A.cH(a)},
a_(a,b){return new A.a8(!1,null,b,a)},
dD(a,b,c){return new A.a8(!0,a,b,c)},
a1(a,b,c,d,e){return new A.bg(b,c,!0,a,d,"Invalid value")},
c0(a,b,c){if(0>a||a>c)throw A.d(A.a1(a,0,c,"start",null))
if(b!=null){if(a>b||b>c)throw A.d(A.a1(b,a,c,"end",null))
return b}return c},
dd(a,b){if(a<0)throw A.d(A.a1(a,0,null,b,null))
return a},
hf(a,b,c,d){return new A.cT(b,!0,a,d,"Index out of range")},
dj(a){return new A.cc(a)},
ht(a){return new A.dh(a)},
hp(a){return new A.bh(a)},
a9(a){return new A.cN(a)},
he(a,b,c){return new A.dW(a,b,c)},
k5(a,b,c){var s,r
if(A.hP(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}s=A.b([],t.s)
B.a.m($.a2,a)
try{A.lG(a,s)}finally{if(0>=$.a2.length)return A.a($.a2,-1)
$.a2.pop()}r=A.iq(b,t.R.a(s),", ")+c
return r.charCodeAt(0)==0?r:r},
i8(a,b,c){var s,r
if(A.hP(a))return b+"..."+c
s=new A.bi(b)
B.a.m($.a2,a)
try{r=s
r.a=A.iq(r.a,a,", ")}finally{if(0>=$.a2.length)return A.a($.a2,-1)
$.a2.pop()}s.a+=c
r=s.a
return r.charCodeAt(0)==0?r:r},
lG(a,b){var s,r,q,p,o,n,m,l=a.gC(a),k=0,j=0
while(!0){if(!(k<80||j<3))break
if(!l.p())return
s=A.n(l.gt())
B.a.m(b,s)
k+=s.length+2;++j}if(!l.p()){if(j<=5)return
if(0>=b.length)return A.a(b,-1)
r=b.pop()
if(0>=b.length)return A.a(b,-1)
q=b.pop()}else{p=l.gt();++j
if(!l.p()){if(j<=4){B.a.m(b,A.n(p))
return}r=A.n(p)
if(0>=b.length)return A.a(b,-1)
q=b.pop()
k+=r.length+2}else{o=l.gt();++j
for(;l.p();p=o,o=n){n=l.gt();++j
if(j>100){while(!0){if(!(k>75&&j>3))break
if(0>=b.length)return A.a(b,-1)
k-=b.pop().length+2;--j}B.a.m(b,"...")
return}}q=A.n(p)
r=A.n(o)
k+=r.length+q.length+4}}if(j>b.length+2){k+=5
m="..."}else m=null
while(!0){if(!(k>80&&b.length>3))break
if(0>=b.length)return A.a(b,-1)
k-=b.pop().length+2
if(m==null){k+=5
m="..."}}if(m!=null)B.a.m(b,m)
B.a.m(b,q)
B.a.m(b,r)},
kn(a,b,c,d){var s
if(B.o===c){s=B.b.gv(a)
b=J.ap(b)
return A.hr(A.aN(A.aN($.h6(),s),b))}if(B.o===d){s=B.b.gv(a)
b=J.ap(b)
c=J.ap(c)
return A.hr(A.aN(A.aN(A.aN($.h6(),s),b),c))}s=B.b.gv(a)
b=J.ap(b)
c=J.ap(c)
d=J.ap(d)
d=A.hr(A.aN(A.aN(A.aN(A.aN($.h6(),s),b),c),d))
return d},
E:function E(a,b,c){this.a=a
this.b=b
this.c=c},
ff:function ff(){},
fg:function fg(){},
cP:function cP(a,b,c){this.a=a
this.b=b
this.c=c},
cR:function cR(){},
fj:function fj(){},
y:function y(){},
cH:function cH(a){this.a=a},
ax:function ax(){},
a8:function a8(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
bg:function bg(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.a=c
_.b=d
_.c=e
_.d=f},
cT:function cT(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
cc:function cc(a){this.a=a},
dh:function dh(a){this.a=a},
bh:function bh(a){this.a=a},
cN:function cN(a){this.a=a},
d8:function d8(){},
c4:function c4(){},
fk:function fk(a){this.a=a},
dW:function dW(a,b,c){this.a=a
this.b=b
this.c=c},
cU:function cU(){},
i:function i(){},
T:function T(a,b,c){this.a=a
this.b=b
this.$ti=c},
I:function I(){},
e:function e(){},
dt:function dt(){},
bi:function bi(a){this.a=a},
kj(a,b){return a},
kd(a){return a},
k6(a,b){var s,r,q,p,o,n
if(b.length===0)return!1
s=b.split(".")
r=v.G
for(q=s.length,p=t.A,o=0;o<q;++o){n=s[o]
r=p.a(r[n])
if(r==null)return!1}return a instanceof t.g.a(r)},
k3(a){return t.m.a(new v.G.Promise(A.w(new A.dZ(a))))},
dZ:function dZ(a){this.a=a},
dX:function dX(a){this.a=a},
dY:function dY(a){this.a=a},
v(a){var s
if(typeof a=="function")throw A.d(A.a_("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(){return b(c)}}(A.lf,a)
s[$.bs()]=a
return s},
f(a){var s
if(typeof a=="function")throw A.d(A.a_("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d){return b(c,d,arguments.length)}}(A.lg,a)
s[$.bs()]=a
return s},
w(a){var s
if(typeof a=="function")throw A.d(A.a_("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d,e){return b(c,d,e,arguments.length)}}(A.lh,a)
s[$.bs()]=a
return s},
hF(a){var s
if(typeof a=="function")throw A.d(A.a_("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d,e,f){return b(c,d,e,f,arguments.length)}}(A.li,a)
s[$.bs()]=a
return s},
hG(a){var s
if(typeof a=="function")throw A.d(A.a_("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d,e,f,g){return b(c,d,e,f,g,arguments.length)}}(A.lj,a)
s[$.bs()]=a
return s},
lf(a){return t.Z.a(a).$0()},
lg(a,b,c){t.Z.a(a)
if(A.ad(c)>=1)return a.$1(b)
return a.$0()},
lh(a,b,c,d){t.Z.a(a)
A.ad(d)
if(d>=2)return a.$2(b,c)
if(d===1)return a.$1(b)
return a.$0()},
li(a,b,c,d,e){t.Z.a(a)
A.ad(e)
if(e>=3)return a.$3(b,c,d)
if(e===2)return a.$2(b,c)
if(e===1)return a.$1(b)
return a.$0()},
lj(a,b,c,d,e,f){t.Z.a(a)
A.ad(f)
if(f>=4)return a.$4(b,c,d,e)
if(f===3)return a.$3(b,c,d)
if(f===2)return a.$2(b,c)
if(f===1)return a.$1(b)
return a.$0()},
j1(a){return a==null||A.fN(a)||typeof a=="number"||typeof a=="string"||t.gj.b(a)||t.gc.b(a)||t.go.b(a)||t.dQ.b(a)||t.h7.b(a)||t.k.b(a)||t.bv.b(a)||t.E.b(a)||t.d.b(a)||t.B.b(a)||t.Y.b(a)},
h_(a){if(A.j1(a))return a
return new A.h0(new A.bl(t.J)).$1(a)},
m2(a,b,c){return c.a(a[b])},
fR(a,b,c){var s,r
if(b==null)return c.a(new a())
if(b instanceof Array)switch(b.length){case 0:return c.a(new a())
case 1:return c.a(new a(b[0]))
case 2:return c.a(new a(b[0],b[1]))
case 3:return c.a(new a(b[0],b[1],b[2]))
case 4:return c.a(new a(b[0],b[1],b[2],b[3]))}s=[null]
B.a.a7(s,b)
r=a.bind.apply(a,s)
String(r)
return c.a(new r())},
je(a,b){var s=new A.q($.u,b.h("q<0>")),r=new A.az(s,b.h("az<0>"))
a.then(A.cE(new A.h3(r,b),1),A.cE(new A.h4(r),1))
return s},
j0(a){return a==null||typeof a==="boolean"||typeof a==="number"||typeof a==="string"||a instanceof Int8Array||a instanceof Uint8Array||a instanceof Uint8ClampedArray||a instanceof Int16Array||a instanceof Uint16Array||a instanceof Int32Array||a instanceof Uint32Array||a instanceof Float32Array||a instanceof Float64Array||a instanceof ArrayBuffer||a instanceof DataView},
hM(a){if(A.j0(a))return a
return new A.fS(new A.bl(t.J)).$1(a)},
h0:function h0(a){this.a=a},
h3:function h3(a,b){this.a=a
this.b=b},
h4:function h4(a){this.a=a},
fS:function fS(a){this.a=a},
eB:function eB(a){this.a=a},
fx:function fx(a){this.a=a},
dR:function dR(){},
hZ(a,b){var s,r,q,p,o,n,m,l,k=B.a_.k(0,b)
k.toString
s=A.jO(a)
for(r=k.length,q="";s.aH(0,$.P())>0;s=o){p=A.ch(58)
if(p.c===0)A.X(B.x)
o=s.br(p)
p=A.ch(58)
if(p.c===0)A.X(B.x)
n=s.bI(p)
if(n.a)n=p.a?n.ar(0,p):n.aP(0,p)
p=n.aN(0)
if(!(p>=0&&p<r))return A.a(k,p)
q=k[p]+q}for(p=a.length,m=0,l=0;l<p;++l)if(a[l]===0)++m
else break
if(0>=r)return A.a(k,0)
return B.e.V(k[0],p-(p-m))+q},
hY(a,b){var s,r,q,p,o,n,m,l,k=B.a_.k(0,b)
k.toString
s=$.P()
for(r=a.length,q=r-1,p=0;p<r;++p){o=q-p
if(!(o>=0))return A.a(a,o)
n=B.e.ek(k,a[o])
if(n===-1)throw A.d(B.aA)
s=s.aP(0,A.ch(n).V(0,A.ch(58).er(p)))}m=A.jP(s,A.jN(s))
for(q=k.length,l=0,p=0;p<r;++p){o=a[p]
if(0>=q)return A.a(k,0)
if(o===k[0])++l
else break}k=t.S
r=A.a6(A.ab(l,0,!1,k),t.z)
B.a.a7(r,m)
return A.bQ(r,!0,k)},
bv:function bv(a){this.b=a},
dH:function dH(a,b){this.a=a
this.b=b},
ix(a){var s,r,q,p,o,n,m,l,k,j,i,h=A.br(a,"=",""),g=A.b([],t.t)
for(s=h.length,r=0;q=r+4,q<=s;r=q){p=$.h5()
if(!(r<s))return A.a(h,r)
o=J.b3(p)
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
B.a.m(g,j>>>16&255)
B.a.m(g,j>>>8&255)
B.a.m(g,j&255)}i=s-r
if(i===2){p=$.h5()
if(!(r<s))return A.a(h,r)
o=J.b3(p)
n=o.k(p,h.charCodeAt(r))
m=r+1
if(!(m<s))return A.a(h,m)
B.a.m(g,(n<<18|o.k(p,h.charCodeAt(m))<<12)>>>16&255)}else if(i===3){p=$.h5()
if(!(r<s))return A.a(h,r)
o=J.b3(p)
n=o.k(p,h.charCodeAt(r))
m=r+1
if(!(m<s))return A.a(h,m)
m=o.k(p,h.charCodeAt(m))
l=r+2
if(!(l<s))return A.a(h,l)
j=n<<18|m<<12|o.k(p,h.charCodeAt(l))<<6
B.a.m(g,j>>>16&255)
B.a.m(g,j>>>8&255)}return g},
jM(a,b,c){var s,r,q
a=a
r=B.b.a_(J.ak(a),4)
if(r!==0)throw A.d(A.jL("Invalid length, must be multiple of four"))
r=a
r=A.br(r,"-","+")
a=A.br(r,"_","/")
s=new A.fb(A.b([],t.t))
try{J.hW(s,a)
r=s
q=r.b
if(q.length!==0)B.a.a7(r.a,A.ix(B.e.ep(q,4,"=")))
r=A.ki(r.a,t.S)
return r}finally{r=s
B.a.bW(r.a)
r.b=""}},
fb:function fb(a){this.a=a
this.b=""},
fc:function fc(){},
iy(a){var s,r,q,p,o,n,m,l,k,j=u.n
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
hX(a,b,c){var s,r,q,p,o=new A.fd(new A.bi(""),A.b([],t.t))
try{A.hd(a)
J.hW(o,a)
r=o
q=r.b
if(q.length!==0){p=r.a
q=A.iy(q)
p.a+=q}r=r.a.a
s=r.charCodeAt(0)==0?r:r
if(c){r=s
r=A.br(r,"+","-")
s=A.br(r,"/","_")}r=s
return r}finally{r=o
r.a.a=""
B.a.bW(r.b)}},
fd:function fd(a,b){this.a=a
this.b=b},
jL(a){return new A.dG(a,null)},
dG:function dG(a,b){this.a=a
this.b=b},
dP:function dP(a,b){this.a=a
this.b=b},
eK(a){var s,r=t.S,q=A.ab(8,0,!1,r),p=A.ab(64,0,!1,r),o=A.ab(128,0,!1,r),n=new A.eJ(q,p,o,A.hm(B.av,r))
n.c1()
n.aO(a)
s=A.ab(32,0,!1,r)
n.eg(s)
A.ji(o)
A.ji(p)
n.c1()
return s},
eJ:function eJ(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.e=_.d=0
_.f=!1
_.r=d},
h9(a,b){return new A.b8(a,b)},
dI:function dI(){},
dJ:function dJ(){},
dK:function dK(){},
b8:function b8(a,b){this.a=a
this.b=b},
eA:function eA(a,b){this.a=a
this.b=b},
fw:function fw(){},
kD(a){if(B.e.bh(a.toLowerCase(),"0x"))return B.e.aT(a,2)
return a},
is(a){var s,r,q,p,o,n,m,l=!0,k=B.w,j=B.N,i=!0
try{switch(j){case B.N:r=B.al.al(a)
return r
case B.v:case B.a2:r=A.jM(a,l,i)
return r
case B.a3:r=A.hY(a,k)
return r
case B.a4:q=A.hY(a,k)
p=B.a.W(q,0,q.length-4)
o=B.a.bi(q,q.length-4)
n=B.a.W(A.eK(A.eK(p)),0,4)
if(!A.jS(o,n))A.X(new A.dH("Invalid checksum (expected "+A.hc(n)+", got "+A.hc(o)+")",null))
return p
case B.a5:r=A.i3(a)
return r
case B.a1:r=B.ac.al(a)
return r}}catch(m){s=A.ao(m)
throw A.d(A.h9("Failed to convert string as "+j.b+" bytes.",A.z(["error",J.Z(s)],t.N,t.z)))}},
ir(a,b){var s,r,q,p,o,n,m=!1,l=!1,k=B.w
a=a
r=a
A.hd(r)
a=r
try{switch(b){case B.N:r=t.L.a(a)
q=A.aB(m)
r=new A.fF((q===!0?B.aQ:B.aP).a).cL(r,0,null,!0)
return r
case B.v:r=A.hX(a,l,!1)
return r
case B.a2:r=A.hX(a,l,!0)
return r
case B.a3:r=A.hZ(a,k)
return r
case B.a4:r=a
A.hd(r)
q=t.S
p=A.hm(r,q)
o=B.a.W(A.eK(A.eK(p)),0,4)
r=A.a6(p,t.z)
B.a.a7(r,o)
r=A.hZ(A.bQ(r,!0,q),k)
return r
case B.a5:r=A.hc(a)
return r
case B.a1:r=B.ab.ed(a,m)
return r}}catch(n){s=A.ao(n)
r=A.h9("Failed to convert bytes as "+b.b,A.z(["error",J.Z(s)],t.N,t.z))
throw A.d(r)}},
aw:function aw(a){this.b=a},
kG(){var s,r,q,p=A.kk(16,new A.eX($.jk()),t.S)
B.a.l(p,6,p[6]&15|64)
B.a.l(p,8,p[8]&63|128)
s=A.V(p)
r=s.h("U<1,j>")
q=A.a6(new A.U(p,s.h("j(1)").a(new A.eY()),r),r.h("F.E"))
return B.a.T(B.a.W(q,0,4),"")+"-"+B.a.T(B.a.W(q,4,6),"")+"-"+B.a.T(B.a.W(q,6,8),"")+"-"+B.a.T(B.a.W(q,8,10),"")+"-"+B.a.T(B.a.bi(q,10),"")},
eX:function eX(a){this.a=a},
eY:function eY(){},
dS:function dS(){},
d0:function d0(a){this.b=a},
eR:function eR(a){this.a=a},
cd:function cd(a,b){this.a=a
this.b=b},
dw:function dw(){},
k9(a){var s,r,q,p,o,n
try{s=null
q=a.rawTransaction
r=q==null?null:J.Z(q)
if(r!=null){q=$.jm()
p=t.K
if(q.b.test(r)){q=A.i3(r)
s=p.a(v.G.Uint8Array.from(A.h_(q)))}else s=p.a(a.rawTransaction.bcsToBytes())
q=s
p=a.feePayerAddress
p=p==null?null:J.Z(p)
o=t.r.a(a.secondarySignerAddresses)
if(o==null)o=null
else{o=t.ew.b(o)?o:new A.aq(o,A.V(o).h("aq<1,e>"))
o=J.dz(o,new A.e8(),t.N)
o=A.a6(o,o.$ti.h("F.E"))}o={rawTransaction:q,feePayerAddress:p,secondarySignerAddresses:o}
return o}}catch(n){}throw A.d(new A.cd("Invalid method parameters: Invalid Aptos transaction. The transaction must be a valid Aptos transaction and include a method like bcsToBytes.",-32602))},
k7(a){return new A.e7(a)},
k8(a){return new A.e6(a)},
hg(a){a.bcsToBytes=A.v(new A.e3(a))
a.serialize=A.f(new A.e4(a))
a.bcsToHex=A.v(new A.e5(a))
a.toStringWithoutPrefix=A.v(A.k8(a))
a.toString=A.v(A.k7(a))},
hh(a){return B.a.a9(B.ay,new A.e9(a),new A.ea())},
hi(a,b){var s={}
s.status="Approved"
s.args=a
return s},
e8:function e8(){},
e7:function e7(a){this.a=a},
e6:function e6(a){this.a=a},
e3:function e3(a){this.a=a},
e4:function e4(a){this.a=a},
e5:function e5(a){this.a=a},
aH:function aH(a,b){this.c=a
this.b=b},
e9:function e9(a){this.a=a},
ea:function ea(){},
aM:function aM(a,b,c){this.a=a
this.b=b
this.$ti=c},
d9:function d9(a,b){this.a=a
this.b=b},
k0(a){var s=v.G,r=t.m,q=r.a(new s.CustomEvent("eip6963:announceProvider",{bubbles:!0,cancelable:!1,detail:t.K.a(s.Object.freeze({info:$.jj(),provider:a}))}))
r.a(s.window).addEventListener("eip6963:requestProvider",A.f(new A.dQ(q)))
r.a(s.window).dispatchEvent(q)},
dQ:function dQ(a){this.a=a},
Y(a,b){return t.m.a(new v.G.Promise(A.w(new A.f6(a))))},
a7(a,b){return A.fR(v.G.Proxy,[a,new A.eI(new A.aM(null,a,b.h("aM<0>"))).$0()],t.m)},
io(a){var s=A.V(a),r=s.h("U<1,j>")
s=A.a6(new A.U(a,s.h("j(1)").a(new A.eF()),r),r.h("F.E"))
return s},
f6:function f6(a){this.a=a},
f3:function f3(a){this.a=a},
f4:function f4(a){this.a=a},
f5:function f5(a,b){this.a=a
this.b=b},
eG:function eG(a){this.a=a},
eH:function eH(a){this.a=a},
eI:function eI(a){this.a=a},
eF:function eF(){},
hQ(a){return A.ma(a)},
ma(a){var s=0,r=A.ah(t.H),q,p,o
var $async$hQ=A.ai(function(b,c){if(b===1)return A.ae(c,r)
while(true)switch(s){case 0:p={}
o=new A.cX(new A.eR(A.d_(t.fs,t.W)),new A.az(new A.q($.u,t.U),t.h))
o.d3()
q=v.G
q.onChain={}
p.a=!1
t.m.a(q.window).addEventListener("WALLET_ACTIVATION",A.f(new A.h1(p,o)))
return A.af(null,r)}})
return A.ag($async$hQ,r)},
h1:function h1(a,b){this.a=a
this.b=b},
kg(a){return B.a.a9(B.aw,new A.er(a),new A.es())},
kc(a){return B.a.a9(B.ax,new A.ei(a),new A.ej())},
kb(a){return B.a.a9(B.Y,new A.eg(a),new A.eh())},
bH(a){return A.kz(B.Y,new A.ef(a),t.G)},
ie(a){return B.a.a9(B.az,new A.ew(a),new A.ex())},
ib(a){return B.a.a9(B.au,new A.ed(a),new A.ee())},
ii(a,b){var s=a==null?null:a.b
return{data:b,requestId:"event",client:s}},
be(a){return{type:"event",event:a.b,data:null,providerType:"walletStandard"}},
aI:function aI(a){this.b=a},
er:function er(a){this.a=a},
es:function es(){},
R:function R(a){this.b=a},
ei:function ei(a){this.a=a},
ej:function ej(){},
a4:function a4(a){this.b=a},
eg:function eg(a){this.a=a},
eh:function eh(){},
ef:function ef(a){this.a=a},
aJ:function aJ(a){this.b=a},
ew:function ew(a){this.a=a},
ex:function ex(){},
H:function H(a,b){this.c=a
this.b=b},
ed:function ed(a){this.a=a},
ee:function ee(){},
db:function db(a){this.b=a},
hC(a){var s
if(a!=null&&typeof a==="string"){s=A.k(a).length
if(s===64||s===66)throw A.d({message:"Please use static method `TronWeb.TRX.sign` for signing with own private key"})}},
eb:function eb(){},
ec:function ec(a){this.a=a},
cX:function cX(a,b){var _=this
_.b=_.a=$
_.c=a
_.d=b
_.e=null
_.f=$},
bL:function bL(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
en:function en(a,b){this.a=a
this.b=b},
ek:function ek(a,b){this.a=a
this.b=b},
el:function el(a){this.a=a},
em:function em(a){this.a=a},
J:function J(){},
da:function da(a,b){this.a=a
this.b=b},
bt:function bt(a,b,c){this.c=a
this.a=b
this.b=c},
dB:function dB(){},
dC:function dC(){},
dA:function dA(){},
bw:function bw(a,b){this.a=a
this.b=b},
bA:function bA(a,b){var _=this
_.d=_.c=null
_.a=a
_.b=b},
dN:function dN(a,b){this.a=a
this.b=b},
dO:function dO(a,b,c){this.a=a
this.b=b
this.c=c},
dL:function dL(a,b){this.a=a
this.b=b},
dM:function dM(a,b,c){this.a=a
this.b=b
this.c=c},
bD:function bD(a,b,c){var _=this
_.c=null
_.d=a
_.a=b
_.b=c},
bS:function bS(a,b){this.a=a
this.b=b},
c2:function c2(a,b){this.a=a
this.b=b},
c3:function c3(a,b){this.a=a
this.b=b},
c5:function c5(a,b){this.a=a
this.b=b},
c7:function c7(a,b,c){var _=this
_.c=a
_.e=_.d=null
_.a=b
_.b=c},
eO:function eO(a){this.a=a},
eP:function eP(a){this.a=a},
eQ:function eQ(a){this.a=a},
eM:function eM(){},
eN:function eN(a){this.a=a},
c8:function c8(a,b){this.a=a
this.b=b},
c9:function c9(a,b){this.a=a
this.b=b},
ca:function ca(a,b,c,d){var _=this
_.d=_.c=null
_.e=a
_.f=b
_.a=c
_.b=d},
eS:function eS(a){this.a=a},
eT:function eT(a){this.a=a},
eU:function eU(a){this.a=a},
a5(a){var s={}
s.on=a
s.version="1.0.0"
return s},
ar(a){var s={}
s.disconnect=a
s.version="1.0.0"
return s},
et(a){var s,r,q=t.c.a(a.types)
q=t.a.b(q)?q:new A.aq(q,A.V(q).h("aq<1,j>"))
q=J.dz(q,new A.eu(),t.N)
s=q.$ti
r=s.h("U<F.E,R>")
q=A.a6(new A.U(q,s.h("R(F.E)").a(new A.ev()),r),r.h("F.E"))
return q},
id(a){var s=t.c.a(a.accounts)
s=t.cl.b(s)?s:new A.aq(s,A.V(s).h("aq<1,h>"))
s=J.dz(s,new A.eq(),t.N)
s=A.a6(s,s.$ti.h("F.E"))
return s},
eu:function eu(){},
ev:function ev(){},
eq:function eq(){},
ki(a,b){return A.bQ(a,!0,b)},
hS(a,b,c){B.a.l(b,c,a>>>24&255)
B.a.l(b,c+1,a>>>16&255)
B.a.l(b,c+2,a>>>8&255)
B.a.l(b,c+3,a&255)},
ji(a){var s,r
for(s=a.length,r=0;r<s;++r)B.a.l(a,r,0)},
hc(a){var s=B.S.ef(a,!0)
return s},
i3(a){var s,r,q,p=!1
try{s=A.kD(a)
if(J.ak(s)===0){r=A.b([],t.t)
return r}if(p&&(J.ak(s)&1)===1)s="0"+A.n(s)
r=B.S.ec(s)
return r}catch(q){throw A.d(B.a6)}},
jT(a,b){var s,r,q
for(s=J.b4(a),r=0;r<a.length;++r){q=s.G(a,r)
if(q<0||q>255)throw A.d(A.h9(b+" at index "+r+" "+A.n(q),null))}},
hd(a){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(q<0||q>255)throw A.d(A.a_("Invalid bytes at index "+r+": "+q,null))}},
jS(a,b){var s,r,q=a.length,p=b.length
if(q!==p)return!1
if(a===b)return!0
for(s=0;s<q;++s){r=a[s]
if(!(s<p))return A.a(b,s)
if(r!==b[s])return!1}return!0},
jZ(a,b,c){var s,r,q
if(a===b)return!0
for(s=0;s<2;++s){r=a[s]
q=b[s]
if(r!==q)return!1}return!0},
i6(a){var s,r,q,p
for(s=J.aR(a),r=t.R,q=12;s.p();){p=s.gt()
q=r.b(p)?(q^A.i6(p))>>>0:(q^J.ap(p))>>>0}return q},
jN(a){var s=a.gak(0)
return B.b.I((a.a?s+1:s)+7,8)},
jP(a,b){var s,r,q,p=a.aH(0,$.P())
if(p===0)return A.ab(b,0,!1,t.S)
s=A.ch(255)
p=t.S
r=A.ab(b,0,!1,p)
for(q=0;q<b;++q){B.a.l(r,b-q-1,a.c6(0,s).aN(0))
a=a.aS(0,8)}return A.bQ(r,!0,p)},
jO(a){var s,r,q,p=$.P()
for(s=0;r=a.length,s<r;++s){q=r-s-1
if(!(q>=0))return A.a(a,q)
p=p.aP(0,A.ch(a[q]).a1(0,8*s))}r=p.aH(0,$.P())
if(r===0)return p
return p},
kz(a,b,c){var s,r,q=null
try{s=B.a.eh(a,b)
return s}catch(r){if(A.ao(r) instanceof A.bh){s=q
s=s==null?null:s.$0()
return s}else throw r}},
ic(a){var s={}
s.showBalanceChanges=A.aB(a.showBalanceChanges)
s.showEffects=A.aB(a.showEffects)
s.showEvents=A.aB(a.showEvents)
s.showInput=A.aB(a.showInput)
s.showObjectChanges=A.aB(a.showObjectChanges)
s.showRawEffects=A.aB(a.showRawEffects)
s.showRawInput=A.aB(a.showRawInput)
return s},
eo(a){return A.ke(a)},
ke(a){var s=0,r=A.ah(t.K),q,p=2,o=[],n,m,l,k,j,i,h,g
var $async$eo=A.ai(function(b,c){if(b===1){o.push(c)
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
return A.aC(A.je(t.m.a(a.transaction.toJSON()),t.N),$async$eo)
case 12:m=c
n=A.ir(A.is(m),B.v)
case 10:j={}
j.chain=A.B(a.chain)
k=a.account
if(k==null)k=a.address
j.account=k
j.transaction=n
j.requestType=A.B(a.requestType)
k=a.options
k=k==null?null:A.ic(k)
j.options=k
q=j
s=1
break
case 8:if(a.transactionBlock!=null){l=null
k=a.transactionBlock
if(k!=null&&typeof k==="string")l=A.k(a.transactionBlock)
else{k=a.transactionBlock
if(k==null)k=null
else{k=t.K.a(k.blockData)
k=k!=null&&typeof k==="string"}i=t.K
if(k===!0)l=A.k(i.a(a.transactionBlock.blockData))
else l=A.ir(A.is(A.k(t.m.a(v.G.JSON).stringify(i.a(a.transactionBlock.blockData)))),B.v)}j={}
j.chain=A.B(a.chain)
k=a.account
if(k==null)k=a.address
j.account=k
j.transaction=l
j.requestType=A.B(a.requestType)
k=a.options
k=k==null?null:A.ic(k)
j.options=k
q=j
s=1
break}p=2
s=6
break
case 4:p=3
g=o.pop()
s=6
break
case 3:s=2
break
case 6:throw A.d($.jn())
case 1:return A.af(q,r)
case 2:return A.ae(o.at(-1),r)}})
return A.ag($async$eo,r)},
iu(a){var s={}
s.signTransaction=a
s.version="1.0.0"
return s},
S(a){var s,r
if(a==null)return A.b([],t.f)
s=[]
r=A.k6(a,"Array")
if(r){t.c.a(a)
s=a}else s.push(a)
return A.bQ(s,!0,t.X)},
aa(a){if(a==null)return null
if(typeof a==="string")return a
return null}},B={}
var w=[A,J,B]
var $={}
A.hj.prototype={}
J.cV.prototype={
Z(a,b){return a===b},
gv(a){return A.c_(a)},
i(a){return"Instance of '"+A.eE(a)+"'"},
gD(a){return A.b1(A.hH(this))}}
J.bG.prototype={
i(a){return String(a)},
be(a,b){return b||a},
gv(a){return a?519018:218159},
gD(a){return A.b1(t.y)},
$it:1,
$iC:1}
J.bJ.prototype={
Z(a,b){return null==b},
i(a){return"null"},
gv(a){return 0},
$it:1}
J.A.prototype={$ih:1}
J.aK.prototype={
gv(a){return 0},
i(a){return String(a)}}
J.dc.prototype={}
J.cb.prototype={}
J.D.prototype={
i(a){var s=a[$.bs()]
if(s==null)return this.cg(a)
return"JavaScript function for "+J.Z(s)},
$iaT:1}
J.bb.prototype={
gv(a){return 0},
i(a){return String(a)}}
J.bc.prototype={
gv(a){return 0},
i(a){return String(a)}}
J.o.prototype={
m(a,b){A.V(a).c.a(b)
a.$flags&1&&A.x(a,29)
a.push(b)},
ap(a,b){var s
a.$flags&1&&A.x(a,"remove",1)
for(s=0;s<a.length;++s)if(J.h7(a[s],b)){a.splice(s,1)
return!0}return!1},
a7(a,b){var s
A.V(a).h("i<1>").a(b)
a.$flags&1&&A.x(a,"addAll",2)
if(Array.isArray(b)){this.cp(a,b)
return}for(s=J.aR(b);s.p();)a.push(s.gt())},
cp(a,b){var s,r
t.b.a(b)
s=b.length
if(s===0)return
if(a===b)throw A.d(A.a9(a))
for(r=0;r<s;++r)a.push(b[r])},
bW(a){a.$flags&1&&A.x(a,"clear","clear")
a.length=0},
ad(a,b,c){var s=A.V(a)
return new A.U(a,s.u(c).h("1(2)").a(b),s.h("@<1>").u(c).h("U<1,2>"))},
T(a,b){var s,r=A.ab(a.length,"",!1,t.N)
for(s=0;s<a.length;++s)this.l(r,s,A.n(a[s]))
return r.join(b)},
bb(a){return this.T(a,"")},
c2(a,b){return A.hq(a,0,A.cD(b,"count",t.S),A.V(a).c)},
a9(a,b,c){var s,r,q,p=A.V(a)
p.h("C(1)").a(b)
p.h("1()?").a(c)
s=a.length
for(r=0;r<s;++r){q=a[r]
if(b.$1(q))return q
if(a.length!==s)throw A.d(A.a9(a))}if(c!=null)return c.$0()
throw A.d(A.i7())},
eh(a,b){b.toString
return this.a9(a,b,null)},
G(a,b){if(!(b>=0&&b<a.length))return A.a(a,b)
return a[b]},
W(a,b,c){if(b<0||b>a.length)throw A.d(A.a1(b,0,a.length,"start",null))
if(c==null)c=a.length
else if(c<b||c>a.length)throw A.d(A.a1(c,b,a.length,"end",null))
if(b===c)return A.b([],A.V(a))
return A.b(a.slice(b,c),A.V(a))},
bi(a,b){return this.W(a,b,null)},
i(a){return A.i8(a,"[","]")},
gC(a){return new J.bu(a,a.length,A.V(a).h("bu<1>"))},
gv(a){return A.c_(a)},
gn(a){return a.length},
k(a,b){if(!(b>=0&&b<a.length))throw A.d(A.fT(a,b))
return a[b]},
l(a,b,c){A.V(a).c.a(c)
a.$flags&2&&A.x(a)
if(!(b>=0&&b<a.length))throw A.d(A.fT(a,b))
a[b]=c},
$il:1,
$ii:1,
$im:1}
J.ep.prototype={}
J.bu.prototype={
gt(){var s=this.d
return s==null?this.$ti.c.a(s):s},
p(){var s,r=this,q=r.a,p=q.length
if(r.b!==p){q=A.an(q)
throw A.d(q)}s=r.c
if(s>=p){r.d=null
return!1}r.d=q[s]
r.c=s+1
return!0},
$iN:1}
J.bK.prototype={
aN(a){var s
if(a>=-2147483648&&a<=2147483647)return a|0
if(isFinite(a)){s=a<0?Math.ceil(a):Math.floor(a)
return s+0}throw A.d(A.dj(""+a+".toInt()"))},
ew(a,b){var s,r,q,p,o
if(b<2||b>36)throw A.d(A.a1(b,2,36,"radix",null))
s=a.toString(b)
r=s.length
q=r-1
if(!(q>=0))return A.a(s,q)
if(s.charCodeAt(q)!==41)return s
p=/^([\da-z]+)(?:\.([\da-z]+))?\(e\+(\d+)\)$/.exec(s)
if(p==null)A.X(A.dj("Unexpected toString result: "+s))
r=p.length
if(1>=r)return A.a(p,1)
s=p[1]
if(3>=r)return A.a(p,3)
o=+p[3]
r=p[2]
if(r!=null){s+=r
o-=r.length}return s+B.e.V("0",o)},
i(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gv(a){var s,r,q,p,o=a|0
if(a===o)return o&536870911
s=Math.abs(a)
r=Math.log(s)/0.6931471805599453|0
q=Math.pow(2,r)
p=s<1?s/q:q/s
return((p*9007199254740992|0)+(p*3542243181176521|0))*599197+r*1259&536870911},
a_(a,b){var s=a%b
if(s===0)return 0
if(s>0)return s
return s+b},
cj(a,b){if((a|0)===a)if(b>=1)return a/b|0
return this.bP(a,b)},
I(a,b){return(a|0)===a?a/b|0:this.bP(a,b)},
bP(a,b){var s=a/b
if(s>=-2147483648&&s<=2147483647)return s|0
if(s>0){if(s!==1/0)return Math.floor(s)}else if(s>-1/0)return Math.ceil(s)
throw A.d(A.dj("Result of truncating division is "+A.n(s)+": "+A.n(a)+" ~/ "+b))},
a1(a,b){if(b<0)throw A.d(A.cC(b))
return b>31?0:a<<b>>>0},
a5(a,b){var s
if(a>0)s=this.bK(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
b7(a,b){if(0>b)throw A.d(A.cC(b))
return this.bK(a,b)},
bK(a,b){return b>31?0:a>>>b},
gD(a){return A.b1(t.o)},
$ir:1,
$ib7:1}
J.bI.prototype={
gak(a){var s,r=a<0?-a-1:a,q=r
for(s=32;q>=4294967296;){q=this.I(q,4294967296)
s+=32}return s-Math.clz32(q)},
gD(a){return A.b1(t.S)},
$it:1,
$ic:1}
J.cW.prototype={
gD(a){return A.b1(t.i)},
$it:1}
J.ba.prototype={
bh(a,b){var s=b.length
if(s>a.length)return!1
return b===a.substring(0,s)},
au(a,b,c){return a.substring(b,A.c0(b,c,a.length))},
aT(a,b){return this.au(a,b,null)},
V(a,b){var s,r
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw A.d(B.ak)
for(s=a,r="";!0;){if((b&1)===1)r=s+r
b=b>>>1
if(b===0)break
s+=s}return r},
bZ(a,b,c){var s=b-a.length
if(s<=0)return a
return this.V(c,s)+a},
ep(a,b,c){var s=b-a.length
if(s<=0)return a
return a+this.V(c,s)},
ek(a,b){var s=a.indexOf(b,0)
return s},
i(a){return a},
gv(a){var s,r,q
for(s=a.length,r=0,q=0;q<s;++q){r=r+a.charCodeAt(q)&536870911
r=r+((r&524287)<<10)&536870911
r^=r>>6}r=r+((r&67108863)<<3)&536870911
r^=r>>11
return r+((r&16383)<<15)&536870911},
gD(a){return A.b1(t.N)},
gn(a){return a.length},
$it:1,
$ieD:1,
$ij:1}
A.bj.prototype={
gC(a){return new A.bx(J.aR(this.gaF()),A.L(this).h("bx<1,2>"))},
gn(a){return J.ak(this.gaF())},
G(a,b){return A.L(this).y[1].a(J.h8(this.gaF(),b))},
i(a){return J.Z(this.gaF())}}
A.bx.prototype={
p(){return this.a.p()},
gt(){return this.$ti.y[1].a(this.a.gt())},
$iN:1}
A.cj.prototype={
k(a,b){return this.$ti.y[1].a(J.jF(this.a,b))},
$il:1,
$im:1}
A.aq.prototype={
gaF(){return this.a}}
A.bN.prototype={
i(a){return"LateInitializationError: "+this.a}}
A.eL.prototype={}
A.l.prototype={}
A.F.prototype={
gC(a){var s=this
return new A.aV(s,s.gn(s),A.L(s).h("aV<F.E>"))},
T(a,b){var s,r,q,p=this,o=p.gn(p)
if(b.length!==0){if(o===0)return""
s=A.n(p.G(0,0))
if(o!==p.gn(p))throw A.d(A.a9(p))
for(r=s,q=1;q<o;++q){r=r+b+A.n(p.G(0,q))
if(o!==p.gn(p))throw A.d(A.a9(p))}return r.charCodeAt(0)==0?r:r}else{for(q=0,r="";q<o;++q){r+=A.n(p.G(0,q))
if(o!==p.gn(p))throw A.d(A.a9(p))}return r.charCodeAt(0)==0?r:r}},
bb(a){return this.T(0,"")},
ad(a,b,c){var s=A.L(this)
return new A.U(this,s.u(c).h("1(F.E)").a(b),s.h("@<F.E>").u(c).h("U<1,2>"))}}
A.c6.prototype={
gcV(){var s=J.ak(this.a),r=this.c
if(r==null||r>s)return s
return r},
ge5(){var s=J.ak(this.a),r=this.b
if(r>s)return s
return r},
gn(a){var s,r=J.ak(this.a),q=this.b
if(q>=r)return 0
s=this.c
if(s==null||s>=r)return r-q
return s-q},
G(a,b){var s=this,r=s.ge5()+b
if(b<0||r>=s.gcV())throw A.d(A.hf(b,s.gn(0),s,"index"))
return J.h8(s.a,r)},
cf(a,b){var s,r,q=this
A.dd(b,"count")
s=q.b+b
r=q.c
if(r!=null&&s>=r)return new A.aS(q.$ti.h("aS<1>"))
return A.hq(q.a,s,r,q.$ti.c)}}
A.aV.prototype={
gt(){var s=this.d
return s==null?this.$ti.c.a(s):s},
p(){var s,r=this,q=r.a,p=J.b3(q),o=p.gn(q)
if(r.b!==o)throw A.d(A.a9(q))
s=r.c
if(s>=o){r.d=null
return!1}r.d=p.G(q,s);++r.c
return!0},
$iN:1}
A.av.prototype={
gC(a){var s=this.a
return new A.bR(s.gC(s),this.b,A.L(this).h("bR<1,2>"))},
gn(a){var s=this.a
return s.gn(s)},
G(a,b){var s=this.a
return this.b.$1(s.G(s,b))}}
A.bB.prototype={$il:1}
A.bR.prototype={
p(){var s=this,r=s.b
if(r.p()){s.a=s.c.$1(r.gt())
return!0}s.a=null
return!1},
gt(){var s=this.a
return s==null?this.$ti.y[1].a(s):s},
$iN:1}
A.U.prototype={
gn(a){return J.ak(this.a)},
G(a,b){return this.b.$1(J.h8(this.a,b))}}
A.ce.prototype={
gC(a){return new A.cf(J.aR(this.a),this.b,this.$ti.h("cf<1>"))},
ad(a,b,c){var s=this.$ti
return new A.av(this,s.u(c).h("1(2)").a(b),s.h("@<1>").u(c).h("av<1,2>"))}}
A.cf.prototype={
p(){var s,r
for(s=this.a,r=this.b;s.p();)if(r.$1(s.gt()))return!0
return!1},
gt(){return this.a.gt()},
$iN:1}
A.aS.prototype={
gC(a){return B.ad},
gn(a){return 0},
G(a,b){throw A.d(A.a1(b,0,0,"index",null))},
ad(a,b,c){this.$ti.u(c).h("1(2)").a(b)
return new A.aS(c.h("aS<0>"))}}
A.bC.prototype={
p(){return!1},
gt(){throw A.d(A.i7())},
$iN:1}
A.Q.prototype={}
A.c1.prototype={
gn(a){return J.ak(this.a)},
G(a,b){var s=this.a,r=J.b3(s)
return r.G(s,r.gn(s)-1-b)}}
A.cz.prototype={}
A.bz.prototype={
i(a){return A.hn(this)},
$iau:1}
A.bF.prototype={
aB(){var s=this,r=s.$map
if(r==null){r=new A.bM(s.$ti.h("bM<1,2>"))
A.j9(s.a,r)
s.$map=r}return r},
k(a,b){return this.aB().k(0,b)},
am(a,b){this.$ti.h("~(1,2)").a(b)
this.aB().am(0,b)},
gan(){var s=this.aB()
return new A.aU(s,A.L(s).h("aU<1>"))},
gn(a){return this.aB().a}}
A.eV.prototype={
U(a){var s,r,q=this,p=new RegExp(q.a).exec(a)
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
A.bZ.prototype={
i(a){return"Null check operator used on a null value"}}
A.cZ.prototype={
i(a){var s,r=this,q="NoSuchMethodError: method not found: '",p=r.b
if(p==null)return"NoSuchMethodError: "+r.a
s=r.c
if(s==null)return q+p+"' ("+r.a+")"
return q+p+"' on '"+s+"' ("+r.a+")"}}
A.di.prototype={
i(a){var s=this.a
return s.length===0?"Error":"Error: "+s}}
A.eC.prototype={
i(a){return"Throw of null ('"+(this.a===null?"null":"undefined")+"' from JavaScript)"}}
A.bE.prototype={}
A.cs.prototype={
i(a){var s,r=this.b
if(r!=null)return r
r=this.a
s=r!==null&&typeof r==="object"?r.stack:null
return this.b=s==null?"":s},
$ial:1}
A.aG.prototype={
i(a){var s=this.constructor,r=s==null?null:s.name
return"Closure '"+A.jh(r==null?"unknown":r)+"'"},
$iaT:1,
geD(){return this},
$C:"$1",
$R:1,
$D:null}
A.cK.prototype={$C:"$0",$R:0}
A.cL.prototype={$C:"$2",$R:2}
A.dg.prototype={}
A.df.prototype={
i(a){var s=this.$static_name
if(s==null)return"Closure of unknown static method"
return"Closure '"+A.jh(s)+"'"}}
A.b9.prototype={
Z(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof A.b9))return!1
return this.$_target===b.$_target&&this.a===b.a},
gv(a){return(A.dy(this.a)^A.c_(this.$_target))>>>0},
i(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.eE(this.a)+"'")}}
A.de.prototype={
i(a){return"RuntimeError: "+this.a}}
A.as.prototype={
gn(a){return this.a},
gan(){return new A.aU(this,A.L(this).h("aU<1>"))},
ac(a){var s=this.em(a)
return s},
em(a){var s=this.d
if(s==null)return!1
return this.aK(s[this.aJ(a)],a)>=0},
k(a,b){var s,r,q,p,o=null
if(typeof b=="string"){s=this.b
if(s==null)return o
r=s[b]
q=r==null?o:r.b
return q}else if(typeof b=="number"&&(b&0x3fffffff)===b){p=this.c
if(p==null)return o
r=p[b]
q=r==null?o:r.b
return q}else return this.en(b)},
en(a){var s,r,q=this.d
if(q==null)return null
s=q[this.aJ(a)]
r=this.aK(s,a)
if(r<0)return null
return s[r].b},
l(a,b,c){var s,r,q,p,o,n,m=this,l=A.L(m)
l.c.a(b)
l.y[1].a(c)
if(typeof b=="string"){s=m.b
m.bj(s==null?m.b=m.b3():s,b,c)}else if(typeof b=="number"&&(b&0x3fffffff)===b){r=m.c
m.bj(r==null?m.c=m.b3():r,b,c)}else{q=m.d
if(q==null)q=m.d=m.b3()
p=m.aJ(b)
o=q[p]
if(o==null)q[p]=[m.b4(b,c)]
else{n=m.aK(o,b)
if(n>=0)o[n].b=c
else o.push(m.b4(b,c))}}},
ap(a,b){var s=this.dr(this.b,b)
return s},
am(a,b){var s,r,q=this
A.L(q).h("~(1,2)").a(b)
s=q.e
r=q.r
for(;s!=null;){b.$2(s.a,s.b)
if(r!==q.r)throw A.d(A.a9(q))
s=s.c}},
bj(a,b,c){var s,r=A.L(this)
r.c.a(b)
r.y[1].a(c)
s=a[b]
if(s==null)a[b]=this.b4(b,c)
else s.b=c},
dr(a,b){var s
if(a==null)return null
s=a[b]
if(s==null)return null
this.e6(s)
delete a[b]
return s.b},
bE(){this.r=this.r+1&1073741823},
b4(a,b){var s=this,r=A.L(s),q=new A.ey(r.c.a(a),r.y[1].a(b))
if(s.e==null)s.e=s.f=q
else{r=s.f
r.toString
q.d=r
s.f=r.c=q}++s.a
s.bE()
return q},
e6(a){var s=this,r=a.d,q=a.c
if(r==null)s.e=q
else r.c=q
if(q==null)s.f=r
else q.d=r;--s.a
s.bE()},
aJ(a){return J.ap(a)&1073741823},
aK(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.h7(a[r].a,b))return r
return-1},
i(a){return A.hn(this)},
b3(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s},
$ihl:1}
A.ey.prototype={}
A.aU.prototype={
gn(a){return this.a.a},
gC(a){var s=this.a
return new A.bP(s,s.r,s.e,this.$ti.h("bP<1>"))}}
A.bP.prototype={
gt(){return this.d},
p(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.d(A.a9(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.a
r.c=s.c
return!0}},
$iN:1}
A.at.prototype={
gn(a){return this.a.a},
gC(a){var s=this.a
return new A.bO(s,s.r,s.e,this.$ti.h("bO<1,2>"))}}
A.bO.prototype={
gt(){var s=this.d
s.toString
return s},
p(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.d(A.a9(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=new A.T(s.a,s.b,r.$ti.h("T<1,2>"))
r.c=s.c
return!0}},
$iN:1}
A.bM.prototype={
aJ(a){return A.lV(a)&1073741823},
aK(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.h7(a[r].a,b))return r
return-1}}
A.fW.prototype={
$1(a){return this.a(a)},
$S:23}
A.fX.prototype={
$2(a,b){return this.a(a,b)},
$S:44}
A.fY.prototype={
$1(a){return this.a(A.k(a))},
$S:49}
A.cr.prototype={}
A.cY.prototype={
i(a){return"RegExp/"+this.a+"/"+this.b.flags},
$ieD:1}
A.fh.prototype={
R(){var s=this.b
if(s===this)throw A.d(new A.bN("Field '"+this.a+"' has not been initialized."))
return s}}
A.bT.prototype={
gD(a){return B.aD},
bT(a,b,c){var s
A.fM(a,b,c)
s=new Uint8Array(a,b,c)
return s},
e9(a,b,c){var s
A.fM(a,b,c)
s=new DataView(a,b)
return s},
bS(a){return this.e9(a,0,null)},
$it:1,
$ibT:1,
$icJ:1}
A.bX.prototype={
gbV(a){if(((a.$flags|0)&2)!==0)return new A.dv(a.buffer)
else return a.buffer}}
A.dv.prototype={
bT(a,b,c){var s=A.km(this.a,b,c)
s.$flags=3
return s},
bS(a){var s=A.kl(this.a,0,null)
s.$flags=3
return s},
$icJ:1}
A.bU.prototype={
gD(a){return B.aE},
$it:1,
$ihb:1}
A.bd.prototype={
gn(a){return a.length},
$ia0:1}
A.bV.prototype={
k(a,b){A.b_(b,a,a.length)
return a[b]},
$il:1,
$ii:1,
$im:1}
A.bW.prototype={$il:1,$ii:1,$im:1}
A.d1.prototype={
gD(a){return B.aF},
$it:1,
$idU:1}
A.d2.prototype={
gD(a){return B.aG},
$it:1,
$idV:1}
A.d3.prototype={
gD(a){return B.aH},
k(a,b){A.b_(b,a,a.length)
return a[b]},
$it:1,
$ie0:1}
A.d4.prototype={
gD(a){return B.aI},
k(a,b){A.b_(b,a,a.length)
return a[b]},
$it:1,
$ie1:1}
A.d5.prototype={
gD(a){return B.aJ},
k(a,b){A.b_(b,a,a.length)
return a[b]},
$it:1,
$ie2:1}
A.d6.prototype={
gD(a){return B.aL},
k(a,b){A.b_(b,a,a.length)
return a[b]},
$it:1,
$ieZ:1}
A.d7.prototype={
gD(a){return B.aM},
k(a,b){A.b_(b,a,a.length)
return a[b]},
$it:1,
$if_:1}
A.bY.prototype={
gD(a){return B.aN},
gn(a){return a.length},
k(a,b){A.b_(b,a,a.length)
return a[b]},
$it:1,
$if0:1}
A.aW.prototype={
gD(a){return B.aO},
gn(a){return a.length},
k(a,b){A.b_(b,a,a.length)
return a[b]},
$it:1,
$iaW:1,
$if1:1}
A.cn.prototype={}
A.co.prototype={}
A.cp.prototype={}
A.cq.prototype={}
A.ac.prototype={
h(a){return A.cx(v.typeUniverse,this,a)},
u(a){return A.iR(v.typeUniverse,this,a)}}
A.dq.prototype={}
A.du.prototype={
i(a){return A.W(this.a,null)}}
A.dp.prototype={
i(a){return this.a}}
A.bm.prototype={$iax:1}
A.f8.prototype={
$1(a){var s=this.a,r=s.a
s.a=null
r.$0()},
$S:24}
A.f7.prototype={
$1(a){var s,r
this.a.a=t.M.a(a)
s=this.b
r=this.c
s.firstChild?s.removeChild(r):s.appendChild(r)},
$S:32}
A.f9.prototype={
$0(){this.a.$0()},
$S:25}
A.fa.prototype={
$0(){this.a.$0()},
$S:25}
A.fA.prototype={
cl(a,b){if(self.setTimeout!=null)self.setTimeout(A.cE(new A.fB(this,b),0),a)
else throw A.d(A.dj("`setTimeout()` not found."))}}
A.fB.prototype={
$0(){this.b.$0()},
$S:2}
A.cg.prototype={
a8(a){var s,r=this,q=r.$ti
q.h("1/?").a(a)
if(a==null)a=q.c.a(a)
if(!r.b)r.a.bl(a)
else{s=r.a
if(q.h("M<1>").b(a))s.bm(a)
else s.bo(a)}},
b9(a,b){var s=this.a
if(this.b)s.a4(new A.a3(a,b))
else s.aX(new A.a3(a,b))},
$icM:1}
A.fK.prototype={
$1(a){return this.a.$2(0,a)},
$S:12}
A.fL.prototype={
$2(a,b){this.a.$2(1,new A.bE(a,t.l.a(b)))},
$S:46}
A.fQ.prototype={
$2(a,b){this.a(A.ad(a),b)},
$S:47}
A.a3.prototype={
i(a){return A.n(this.a)},
$iy:1,
gaa(){return this.b}}
A.e_.prototype={
$0(){this.c.a(null)
this.b.bn(null)},
$S:2}
A.bk.prototype={
b9(a,b){if((this.a.a&30)!==0)throw A.d(A.hp("Future already completed"))
this.a4(A.lv(a,b))},
bX(a){return this.b9(a,null)},
$icM:1}
A.az.prototype={
a8(a){var s,r=this.$ti
r.h("1/?").a(a)
s=this.a
if((s.a&30)!==0)throw A.d(A.hp("Future already completed"))
s.bl(r.h("1/").a(a))},
aI(){return this.a8(null)},
a4(a){this.a.aX(a)}}
A.ct.prototype={
a8(a){var s,r=this.$ti
r.h("1/?").a(a)
s=this.a
if((s.a&30)!==0)throw A.d(A.hp("Future already completed"))
s.bn(r.h("1/").a(a))},
aI(){return this.a8(null)},
a4(a){this.a.a4(a)}}
A.aA.prototype={
eo(a){if((this.c&15)!==6)return!0
return this.b.b.bd(t.al.a(this.d),a.a,t.y,t.K)},
ei(a){var s,r=this,q=r.e,p=null,o=t.z,n=t.K,m=a.a,l=r.b.b
if(t.Q.b(q))p=l.eu(q,m,a.b,o,n,t.l)
else p=l.bd(t.v.a(q),m,o,n)
try{o=r.$ti.h("2/").a(p)
return o}catch(s){if(t.eK.b(A.ao(s))){if((r.c&1)!==0)throw A.d(A.a_("The error handler of Future.then must return a value of the returned future's type","onError"))
throw A.d(A.a_("The error handler of Future.catchError must return a value of the future's type","onError"))}else throw s}}}
A.q.prototype={
aq(a,b,c){var s,r,q,p=this.$ti
p.u(c).h("1/(2)").a(a)
s=$.u
if(s===B.h){if(b!=null&&!t.Q.b(b)&&!t.v.b(b))throw A.d(A.dD(b,"onError",u.c))}else{c.h("@<0/>").u(p.c).h("1(2)").a(a)
if(b!=null)b=A.j2(b,s)}r=new A.q(s,c.h("q<0>"))
q=b==null?1:3
this.aw(new A.aA(r,q,a,b,p.h("@<1>").u(c).h("aA<1,2>")))
return r},
aM(a,b){a.toString
return this.aq(a,null,b)},
bQ(a,b,c){var s,r=this.$ti
r.u(c).h("1/(2)").a(a)
s=new A.q($.u,c.h("q<0>"))
this.aw(new A.aA(s,19,a,b,r.h("@<1>").u(c).h("aA<1,2>")))
return s},
dA(a){this.a=this.a&1|16
this.c=a},
az(a){this.a=a.a&30|this.a&1
this.c=a.c},
aw(a){var s,r=this,q=r.a
if(q<=3){a.a=t.F.a(r.c)
r.c=a}else{if((q&4)!==0){s=t._.a(r.c)
if((s.a&24)===0){s.aw(a)
return}r.az(s)}A.dx(null,null,r.b,t.M.a(new A.fl(r,a)))}},
bH(a){var s,r,q,p,o,n,m=this,l={}
l.a=a
if(a==null)return
s=m.a
if(s<=3){r=t.F.a(m.c)
m.c=a
if(r!=null){q=a.a
for(p=a;q!=null;p=q,q=o)o=q.a
p.a=r}}else{if((s&4)!==0){n=t._.a(m.c)
if((n.a&24)===0){n.bH(a)
return}m.az(n)}l.a=m.aE(a)
A.dx(null,null,m.b,t.M.a(new A.fq(l,m)))}},
aj(){var s=t.F.a(this.c)
this.c=null
return this.aE(s)},
aE(a){var s,r,q
for(s=a,r=null;s!=null;r=s,s=q){q=s.a
s.a=r}return r},
bn(a){var s,r=this,q=r.$ti
q.h("1/").a(a)
if(q.h("M<1>").b(a))A.fo(a,r,!0)
else{s=r.aj()
q.c.a(a)
r.a=8
r.c=a
A.aY(r,s)}},
bo(a){var s,r=this
r.$ti.c.a(a)
s=r.aj()
r.a=8
r.c=a
A.aY(r,s)},
cF(a){var s,r,q=this
if((a.a&16)!==0){s=q.b===a.b
s=!(s||s)}else s=!1
if(s)return
r=q.aj()
q.az(a)
A.aY(q,r)},
a4(a){var s=this.aj()
this.dA(a)
A.aY(this,s)},
bl(a){var s=this.$ti
s.h("1/").a(a)
if(s.h("M<1>").b(a)){this.bm(a)
return}this.cu(a)},
cu(a){var s=this
s.$ti.c.a(a)
s.a^=2
A.dx(null,null,s.b,t.M.a(new A.fn(s,a)))},
bm(a){A.fo(this.$ti.h("M<1>").a(a),this,!1)
return},
aX(a){this.a^=2
A.dx(null,null,this.b,t.M.a(new A.fm(this,a)))},
$iM:1}
A.fl.prototype={
$0(){A.aY(this.a,this.b)},
$S:2}
A.fq.prototype={
$0(){A.aY(this.b,this.a.a)},
$S:2}
A.fp.prototype={
$0(){A.fo(this.a.a,this.b,!0)},
$S:2}
A.fn.prototype={
$0(){this.a.bo(this.b)},
$S:2}
A.fm.prototype={
$0(){this.a.a4(this.b)},
$S:2}
A.ft.prototype={
$0(){var s,r,q,p,o,n,m,l,k=this,j=null
try{q=k.a.a
j=q.b.b.es(t.fO.a(q.d),t.z)}catch(p){s=A.ao(p)
r=A.aP(p)
if(k.c&&t.n.a(k.b.a.c).a===s){q=k.a
q.c=t.n.a(k.b.a.c)}else{q=s
o=r
if(o==null)o=A.ha(q)
n=k.a
n.c=new A.a3(q,o)
q=n}q.b=!0
return}if(j instanceof A.q&&(j.a&24)!==0){if((j.a&16)!==0){q=k.a
q.c=t.n.a(j.c)
q.b=!0}return}if(j instanceof A.q){m=k.b.a
l=new A.q(m.b,m.$ti)
j.aq(new A.fu(l,m),new A.fv(l),t.H)
q=k.a
q.c=l
q.b=!1}},
$S:2}
A.fu.prototype={
$1(a){this.a.cF(this.b)},
$S:24}
A.fv.prototype={
$2(a,b){t.K.a(a)
t.l.a(b)
this.a.a4(new A.a3(a,b))},
$S:26}
A.fs.prototype={
$0(){var s,r,q,p,o,n,m,l
try{q=this.a
p=q.a
o=p.$ti
n=o.c
m=n.a(this.b)
q.c=p.b.b.bd(o.h("2/(1)").a(p.d),m,o.h("2/"),n)}catch(l){s=A.ao(l)
r=A.aP(l)
q=s
p=r
if(p==null)p=A.ha(q)
o=this.a
o.c=new A.a3(q,p)
o.b=!0}},
$S:2}
A.fr.prototype={
$0(){var s,r,q,p,o,n,m,l=this
try{s=t.n.a(l.a.a.c)
p=l.b
if(p.a.eo(s)&&p.a.e!=null){p.c=p.a.ei(s)
p.b=!1}}catch(o){r=A.ao(o)
q=A.aP(o)
p=t.n.a(l.a.a.c)
if(p.a===r){n=l.b
n.c=p
p=n}else{p=r
n=q
if(n==null)n=A.ha(p)
m=l.b
m.c=new A.a3(p,n)
p=m}p.b=!0}},
$S:2}
A.dl.prototype={}
A.ds.prototype={}
A.cy.prototype={$iiw:1}
A.fP.prototype={
$0(){A.k2(this.a,this.b)},
$S:2}
A.dr.prototype={
ev(a){var s,r,q
t.M.a(a)
try{if(B.h===$.u){a.$0()
return}A.j3(null,null,this,a,t.H)}catch(q){s=A.ao(q)
r=A.aP(q)
A.hJ(t.K.a(s),t.l.a(r))}},
bU(a){return new A.fz(this,t.M.a(a))},
es(a,b){b.h("0()").a(a)
if($.u===B.h)return a.$0()
return A.j3(null,null,this,a,b)},
bd(a,b,c,d){c.h("@<0>").u(d).h("1(2)").a(a)
d.a(b)
if($.u===B.h)return a.$1(b)
return A.lK(null,null,this,a,b,c,d)},
eu(a,b,c,d,e,f){d.h("@<0>").u(e).u(f).h("1(2,3)").a(a)
e.a(b)
f.a(c)
if($.u===B.h)return a.$2(b,c)
return A.lJ(null,null,this,a,b,c,d,e,f)},
c0(a,b,c,d){return b.h("@<0>").u(c).u(d).h("1(2,3)").a(a)}}
A.fz.prototype={
$0(){return this.a.ev(this.b)},
$S:2}
A.ck.prototype={
gn(a){return this.a},
gan(){return new A.cl(this,this.$ti.h("cl<1>"))},
ac(a){var s,r
if(typeof a=="string"&&a!=="__proto__"){s=this.b
return s==null?!1:s[a]!=null}else if(typeof a=="number"&&(a&1073741823)===a){r=this.c
return r==null?!1:r[a]!=null}else return this.cK(a)},
cK(a){var s=this.d
if(s==null)return!1
return this.b1(this.bu(s,a),a)>=0},
k(a,b){var s,r,q
if(typeof b=="string"&&b!=="__proto__"){s=this.b
r=s==null?null:A.iH(s,b)
return r}else if(typeof b=="number"&&(b&1073741823)===b){q=this.c
r=q==null?null:A.iH(q,b)
return r}else return this.cZ(b)},
cZ(a){var s,r,q=this.d
if(q==null)return null
s=this.bu(q,a)
r=this.b1(s,a)
return r<0?null:s[r+1]},
l(a,b,c){var s,r,q,p,o,n,m=this,l=m.$ti
l.c.a(b)
l.y[1].a(c)
if(typeof b=="string"&&b!=="__proto__"){s=m.b
m.bk(s==null?m.b=A.hA():s,b,c)}else if(typeof b=="number"&&(b&1073741823)===b){r=m.c
m.bk(r==null?m.c=A.hA():r,b,c)}else{q=m.d
if(q==null)q=m.d=A.hA()
p=A.dy(b)&1073741823
o=q[p]
if(o==null){A.hB(q,p,[b,c]);++m.a
m.e=null}else{n=m.b1(o,b)
if(n>=0)o[n+1]=c
else{o.push(b,c);++m.a
m.e=null}}}},
am(a,b){var s,r,q,p,o,n,m=this,l=m.$ti
l.h("~(1,2)").a(b)
s=m.bp()
for(r=s.length,q=l.c,l=l.y[1],p=0;p<r;++p){o=s[p]
q.a(o)
n=m.k(0,o)
b.$2(o,n==null?l.a(n):n)
if(s!==m.e)throw A.d(A.a9(m))}},
bp(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.e
if(h!=null)return h
h=A.ab(i.a,null,!1,t.z)
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
bk(a,b,c){var s=this.$ti
s.c.a(b)
s.y[1].a(c)
if(a[b]==null){++this.a
this.e=null}A.hB(a,b,c)},
bu(a,b){return a[A.dy(b)&1073741823]}}
A.bl.prototype={
b1(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=0;r<s;r+=2){q=a[r]
if(q==null?b==null:q===b)return r}return-1}}
A.cl.prototype={
gn(a){return this.a.a},
gC(a){var s=this.a
return new A.cm(s,s.bp(),this.$ti.h("cm<1>"))}}
A.cm.prototype={
gt(){var s=this.d
return s==null?this.$ti.c.a(s):s},
p(){var s=this,r=s.b,q=s.c,p=s.a
if(r!==p.e)throw A.d(A.a9(p))
else if(q>=r.length){s.d=null
return!1}else{s.d=r[q]
s.c=q+1
return!0}},
$iN:1}
A.p.prototype={
gC(a){return new A.aV(a,this.gn(a),A.b5(a).h("aV<p.E>"))},
G(a,b){return this.k(a,b)},
ad(a,b,c){var s=A.b5(a)
return new A.U(a,s.u(c).h("1(p.E)").a(b),s.h("@<p.E>").u(c).h("U<1,2>"))},
c2(a,b){return A.hq(a,0,A.cD(b,"count",t.S),A.b5(a).h("p.E"))},
i(a){return A.i8(a,"[","]")}}
A.aL.prototype={
am(a,b){var s,r,q,p=A.L(this)
p.h("~(1,2)").a(b)
for(s=this.gan(),s=s.gC(s),p=p.y[1];s.p();){r=s.gt()
q=this.k(0,r)
b.$2(r,q==null?p.a(q):q)}},
e8(a){var s,r
for(s=J.aR(A.L(this).h("i<T<1,2>>").a(a));s.p();){r=s.gt()
this.l(0,r.a,r.b)}},
gn(a){var s=this.gan()
return s.gn(s)},
i(a){return A.hn(this)},
$iau:1}
A.ez.prototype={
$2(a,b){var s,r=this.a
if(!r.a)this.b.a+=", "
r.a=!1
r=this.b
s=A.n(a)
r.a=(r.a+=s)+": "
s=A.n(b)
r.a+=s},
$S:34}
A.fH.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:true})
return s}catch(r){}return null},
$S:20}
A.fG.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:false})
return s}catch(r){}return null},
$S:20}
A.cG.prototype={
ed(a,b){var s
t.L.a(a)
s=B.a9.al(a)
return s}}
A.fD.prototype={
al(a){var s,r,q=a.length,p=A.c0(0,null,q),o=new Uint8Array(p)
for(s=0;s<p;++s){if(!(s<q))return A.a(a,s)
r=a.charCodeAt(s)
if((r&4294967168)!==0)throw A.d(A.dD(a,"string","Contains invalid characters."))
if(!(s<p))return A.a(o,s)
o[s]=r}return o}}
A.dF.prototype={}
A.fC.prototype={
al(a){var s,r,q,p
t.L.a(a)
s=a.length
r=A.c0(0,null,s)
for(q=0;q<r;++q){if(!(q<s))return A.a(a,q)
p=a[q]
if((p&4294967168)>>>0!==0){if(!this.a)throw A.d(A.he("Invalid value in input: "+p,null,null))
return this.cM(a,0,r)}}return A.it(a,0,r)},
cM(a,b,c){var s,r,q
t.L.a(a)
for(s=b,r="";s<c;++s){if(!(s<a.length))return A.a(a,s)
q=a[s]
r+=A.aX((q&4294967168)>>>0!==0?65533:q)}return r.charCodeAt(0)==0?r:r}}
A.dE.prototype={}
A.by.prototype={}
A.cO.prototype={}
A.cS.prototype={}
A.f2.prototype={
al(a){var s,r,q,p,o=a.length,n=A.c0(0,null,o)
if(n===0)return new Uint8Array(0)
s=n*3
r=new Uint8Array(s)
q=new A.fI(r)
if(q.cY(a,0,n)!==n){p=n-1
if(!(p>=0&&p<o))return A.a(a,p)
q.b8()}return new Uint8Array(r.subarray(0,A.ll(0,q.b,s)))}}
A.fI.prototype={
b8(){var s,r=this,q=r.c,p=r.b,o=r.b=p+1
q.$flags&2&&A.x(q)
s=q.length
if(!(p<s))return A.a(q,p)
q[p]=239
p=r.b=o+1
if(!(o<s))return A.a(q,o)
q[o]=191
r.b=p+1
if(!(p<s))return A.a(q,p)
q[p]=189},
e7(a,b){var s,r,q,p,o,n=this
if((b&64512)===56320){s=65536+((a&1023)<<10)|b&1023
r=n.c
q=n.b
p=n.b=q+1
r.$flags&2&&A.x(r)
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
return!0}else{n.b8()
return!1}},
cY(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(b!==c){s=c-1
if(!(s>=0&&s<a.length))return A.a(a,s)
s=(a.charCodeAt(s)&64512)===55296}else s=!1
if(s)--c
for(s=k.c,r=s.$flags|0,q=s.length,p=a.length,o=b;o<c;++o){if(!(o<p))return A.a(a,o)
n=a.charCodeAt(o)
if(n<=127){m=k.b
if(m>=q)break
k.b=m+1
r&2&&A.x(s)
s[m]=n}else{m=n&64512
if(m===55296){if(k.b+4>q)break
m=o+1
if(!(m<p))return A.a(a,m)
if(k.e7(n,a.charCodeAt(m)))o=m}else if(m===56320){if(k.b+3>q)break
k.b8()}else if(n<=2047){m=k.b
l=m+1
if(l>=q)break
k.b=l
r&2&&A.x(s)
if(!(m<q))return A.a(s,m)
s[m]=n>>>6|192
k.b=l+1
s[l]=n&63|128}else{m=k.b
if(m+2>=q)break
l=k.b=m+1
r&2&&A.x(s)
if(!(m<q))return A.a(s,m)
s[m]=n>>>12|224
m=k.b=l+1
if(!(l<q))return A.a(s,l)
s[l]=n>>>6&63|128
k.b=m+1
if(!(m<q))return A.a(s,m)
s[m]=n&63|128}}}return o}}
A.dk.prototype={}
A.fF.prototype={
cL(a,b,c,d){var s,r,q,p,o,n,m,l=this
t.L.a(a)
s=A.c0(b,c,a.length)
if(b===s)return""
if(a instanceof Uint8Array){r=a
q=r
p=0}else{q=A.l6(a,b,s)
s-=b
p=b
b=0}if(s-b>=15){o=l.a
n=A.l5(o,q,b,s)
if(n!=null){if(!o)return n
if(n.indexOf("\ufffd")<0)return n}}n=l.aY(q,b,s,!0)
o=l.b
if((o&1)!==0){m=A.l7(o)
l.b=0
throw A.d(A.he(m,a,p+l.c))}return n},
aY(a,b,c,d){var s,r,q=this
if(c-b>1000){s=B.b.I(b+c,2)
r=q.aY(a,b,s,!1)
if((q.b&1)!==0)return r
return r+q.aY(a,s,c,d)}return q.ee(a,b,c,d)},
ee(a,b,a0,a1){var s,r,q,p,o,n,m,l,k=this,j="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFFFFFFFFFFFFFFFFGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHHHHHHHHHHIHHHJEEBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBKCCCCCCCCCCCCDCLONNNMEEEEEEEEEEE",i=" \x000:XECCCCCN:lDb \x000:XECCCCCNvlDb \x000:XECCCCCN:lDb AAAAA\x00\x00\x00\x00\x00AAAAA00000AAAAA:::::AAAAAGG000AAAAA00KKKAAAAAG::::AAAAA:IIIIAAAAA000\x800AAAAA\x00\x00\x00\x00 AAAAA",h=65533,g=k.b,f=k.c,e=new A.bi(""),d=b+1,c=a.length
if(!(b>=0&&b<c))return A.a(a,b)
s=a[b]
$label0$0:for(r=k.a;!0;){for(;!0;d=o){if(!(s>=0&&s<256))return A.a(j,s)
q=j.charCodeAt(s)&31
f=g<=32?s&61694>>>q:(s&63|f<<6)>>>0
p=g+q
if(!(p>=0&&p<144))return A.a(i,p)
g=i.charCodeAt(p)
if(g===0){p=A.aX(f)
e.a+=p
if(d===a0)break $label0$0
break}else if((g&1)!==0){if(r)switch(g){case 69:case 67:p=A.aX(h)
e.a+=p
break
case 65:p=A.aX(h)
e.a+=p;--d
break
default:p=A.aX(h)
e.a=(e.a+=p)+A.aX(h)
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
p=A.aX(a[l])
e.a+=p}else{p=A.it(a,d,n)
e.a+=p}if(n===a0)break $label0$0
d=o}else d=o}if(a1&&g>32)if(r){c=A.aX(h)
e.a+=c}else{k.b=77
k.c=a0
return""}k.b=g
k.c=f
c=e.a
return c.charCodeAt(0)==0?c:c}}
A.E.prototype={
a0(a){var s,r,q=this,p=q.c
if(p===0)return q
s=!q.a
r=q.b
p=A.O(p,r)
return new A.E(p===0?!1:s,r,p)},
cQ(a){var s,r,q,p,o,n,m,l=this.c
if(l===0)return $.P()
s=l+a
r=this.b
q=new Uint16Array(s)
for(p=l-1,o=r.length;p>=0;--p){n=p+a
if(!(p<o))return A.a(r,p)
m=r[p]
if(!(n>=0&&n<s))return A.a(q,n)
q[n]=m}o=this.a
n=A.O(s,q)
return new A.E(n===0?!1:o,q,n)},
cR(a){var s,r,q,p,o,n,m,l,k=this,j=k.c
if(j===0)return $.P()
s=j-a
if(s<=0)return k.a?$.hV():$.P()
r=k.b
q=new Uint16Array(s)
for(p=r.length,o=a;o<j;++o){n=o-a
if(!(o>=0&&o<p))return A.a(r,o)
m=r[o]
if(!(n<s))return A.a(q,n)
q[n]=m}n=k.a
m=A.O(s,q)
l=new A.E(m===0?!1:n,q,m)
if(n)for(o=0;o<a;++o){if(!(o<p))return A.a(r,o)
if(r[o]!==0)return l.ar(0,$.aF())}return l},
a1(a,b){var s,r,q,p,o,n=this
if(b<0)throw A.d(A.a_("shift-amount must be posititve "+b,null))
s=n.c
if(s===0)return n
r=B.b.I(b,16)
if(B.b.a_(b,16)===0)return n.cQ(r)
q=s+r+1
p=new Uint16Array(q)
A.iE(n.b,s,b,p)
s=n.a
o=A.O(q,p)
return new A.E(o===0?!1:s,p,o)},
aS(a,b){var s,r,q,p,o,n,m,l,k,j=this
if(b<0)throw A.d(A.a_("shift-amount must be posititve "+b,null))
s=j.c
if(s===0)return j
r=B.b.I(b,16)
q=B.b.a_(b,16)
if(q===0)return j.cR(r)
p=s-r
if(p<=0)return j.a?$.hV():$.P()
o=j.b
n=new Uint16Array(p)
A.kO(o,s,b,n)
s=j.a
m=A.O(p,n)
l=new A.E(m===0?!1:s,n,m)
if(s){s=o.length
if(!(r>=0&&r<s))return A.a(o,r)
if((o[r]&B.b.a1(1,q)-1)!==0)return l.ar(0,$.aF())
for(k=0;k<r;++k){if(!(k<s))return A.a(o,k)
if(o[k]!==0)return l.ar(0,$.aF())}}return l},
aH(a,b){var s,r=this.a
if(r===b.a){s=A.fe(this.b,this.c,b.b,b.c)
return r?0-s:s}return r?-1:1},
av(a,b){var s,r,q,p=this,o=p.c,n=a.c
if(o<n)return a.av(p,b)
if(o===0)return $.P()
if(n===0)return p.a===b?p:p.a0(0)
s=o+1
r=new Uint16Array(s)
A.kM(p.b,o,a.b,n,r)
q=A.O(s,r)
return new A.E(q===0?!1:b,r,q)},
a3(a,b){var s,r,q,p=this,o=p.c
if(o===0)return $.P()
s=a.c
if(s===0)return p.a===b?p:p.a0(0)
r=new Uint16Array(o)
A.dn(p.b,o,a.b,s,r)
q=A.O(o,r)
return new A.E(q===0?!1:b,r,q)},
cn(a,b){var s,r,q,p,o,n,m,l,k=this.c,j=a.c
k=k<j?k:j
s=this.b
r=a.b
q=new Uint16Array(k)
for(p=s.length,o=r.length,n=0;n<k;++n){if(!(n<p))return A.a(s,n)
m=s[n]
if(!(n<o))return A.a(r,n)
l=r[n]
if(!(n<k))return A.a(q,n)
q[n]=m&l}p=A.O(k,q)
return new A.E(!1,q,p)},
cm(a,b){var s,r,q,p,o,n=this.c,m=this.b,l=a.b,k=new Uint16Array(n),j=a.c
if(n<j)j=n
for(s=m.length,r=l.length,q=0;q<j;++q){if(!(q<s))return A.a(m,q)
p=m[q]
if(!(q<r))return A.a(l,q)
o=l[q]
if(!(q<n))return A.a(k,q)
k[q]=p&~o}for(q=j;q<n;++q){if(!(q>=0&&q<s))return A.a(m,q)
r=m[q]
if(!(q<n))return A.a(k,q)
k[q]=r}s=A.O(n,k)
return new A.E(!1,k,s)},
co(a,b){var s,r,q,p,o,n,m,l,k=this.c,j=a.c,i=k>j?k:j,h=this.b,g=a.b,f=new Uint16Array(i)
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
f[o]=p}q=A.O(i,f)
return new A.E(q!==0,f,q)},
c6(a,b){var s,r,q,p=this
t.ev.a(b)
if(p.c===0||b.c===0)return $.P()
s=p.a
if(s===b.a){if(s){s=$.aF()
return p.a3(s,!0).co(b.a3(s,!0),!0).av(s,!0)}return p.cn(b,!1)}if(s){r=p
q=b}else{r=b
q=p}return q.cm(r.a3($.aF(),!1),!1)},
aP(a,b){var s,r,q=this,p=q.c
if(p===0)return b
s=b.c
if(s===0)return q
r=q.a
if(r===b.a)return q.av(b,r)
if(A.fe(q.b,p,b.b,s)>=0)return q.a3(b,r)
return b.a3(q,!r)},
ar(a,b){var s,r,q=this,p=q.c
if(p===0)return b.a0(0)
s=b.c
if(s===0)return q
r=q.a
if(r!==b.a)return q.av(b,r)
if(A.fe(q.b,p,b.b,s)>=0)return q.a3(b,r)
return b.a3(q,!r)},
V(a,b){var s,r,q,p,o,n,m,l=this.c,k=b.c
if(l===0||k===0)return $.P()
s=l+k
r=this.b
q=b.b
p=new Uint16Array(s)
for(o=q.length,n=0;n<k;){if(!(n<o))return A.a(q,n)
A.iF(q[n],r,0,p,n,l);++n}o=this.a!==b.a
m=A.O(s,p)
return new A.E(m===0?!1:o,p,m)},
br(a){var s,r,q,p
if(this.c<a.c)return $.P()
this.bs(a)
s=$.hv.R()-$.ci.R()
r=A.hx($.hu.R(),$.ci.R(),$.hv.R(),s)
q=A.O(s,r)
p=new A.E(!1,r,q)
return this.a!==a.a&&q>0?p.a0(0):p},
bI(a){var s,r,q,p=this
if(p.c<a.c)return p
p.bs(a)
s=A.hx($.hu.R(),0,$.ci.R(),$.ci.R())
r=A.O($.ci.R(),s)
q=new A.E(!1,s,r)
if($.hw.R()>0)q=q.aS(0,$.hw.R())
return p.a&&q.c>0?q.a0(0):q},
bs(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=c.c
if(b===$.iB&&a.c===$.iD&&c.b===$.iA&&a.b===$.iC)return
s=a.b
r=a.c
q=r-1
if(!(q>=0&&q<s.length))return A.a(s,q)
p=16-B.b.gak(s[q])
if(p>0){o=new Uint16Array(r+5)
n=A.iz(s,r,p,o)
m=new Uint16Array(b+5)
l=A.iz(c.b,b,p,m)}else{m=A.hx(c.b,0,b,b+2)
n=r
o=s
l=b}q=n-1
if(!(q>=0&&q<o.length))return A.a(o,q)
k=o[q]
j=l-n
i=new Uint16Array(l)
h=A.hy(o,n,j,i)
g=l+1
q=m.$flags|0
if(A.fe(m,l,i,h)>=0){q&2&&A.x(m)
if(!(l>=0&&l<m.length))return A.a(m,l)
m[l]=1
A.dn(m,g,i,h,m)}else{q&2&&A.x(m)
if(!(l>=0&&l<m.length))return A.a(m,l)
m[l]=0}q=n+2
f=new Uint16Array(q)
if(!(n>=0&&n<q))return A.a(f,n)
f[n]=1
A.dn(f,n+1,o,n,f)
e=l-1
for(q=m.length;j>0;){d=A.kN(k,m,e);--j
A.iF(d,f,0,m,j,n)
if(!(e>=0&&e<q))return A.a(m,e)
if(m[e]<d){h=A.hy(f,n,j,i)
A.dn(m,g,i,h,m)
for(;--d,m[e]<d;)A.dn(m,g,i,h,m)}--e}$.iA=c.b
$.iB=b
$.iC=s
$.iD=r
$.hu.b=m
$.hv.b=g
$.ci.b=n
$.hw.b=p},
gv(a){var s,r,q,p,o=new A.ff(),n=this.c
if(n===0)return 6707
s=this.a?83585:429689
for(r=this.b,q=r.length,p=0;p<n;++p){if(!(p<q))return A.a(r,p)
s=o.$2(s,r[p])}return new A.fg().$1(s)},
Z(a,b){if(b==null)return!1
return b instanceof A.E&&this.aH(0,b)===0},
gak(a){var s,r,q,p,o,n,m=this.c
if(m===0)return 0
s=this.b
r=m-1
q=s.length
if(!(r>=0&&r<q))return A.a(s,r)
p=s[r]
o=16*r+B.b.gak(p)
if(!this.a)return o
if((p&p-1)!==0)return o
for(n=m-2;n>=0;--n){if(!(n<q))return A.a(s,n)
if(s[n]!==0)return o}return o-1},
er(a){var s,r
if(a===0)return $.aF()
s=$.aF()
for(r=this;a!==0;){if((a&1)===1)s=s.V(0,r)
a=a>>>1
if(a!==0)r=r.V(0,r)}return s},
aN(a){var s,r,q,p
for(s=this.c-1,r=this.b,q=r.length,p=0;s>=0;--s){if(!(s<q))return A.a(r,s)
p=p*65536+r[s]}return this.a?-p:p},
i(a){var s,r,q,p,o,n=this,m=n.c
if(m===0)return"0"
if(m===1){if(n.a){m=n.b
if(0>=m.length)return A.a(m,0)
return B.b.i(-m[0])}m=n.b
if(0>=m.length)return A.a(m,0)
return B.b.i(m[0])}s=A.b([],t.s)
m=n.a
r=m?n.a0(0):n
for(;r.c>1;){q=$.jy()
if(q.c===0)A.X(B.x)
p=r.bI(q).i(0)
B.a.m(s,p)
o=p.length
if(o===1)B.a.m(s,"000")
if(o===2)B.a.m(s,"00")
if(o===3)B.a.m(s,"0")
r=r.br(q)}q=r.b
if(0>=q.length)return A.a(q,0)
B.a.m(s,B.b.i(q[0]))
if(m)B.a.m(s,"-")
return new A.c1(s,t.bJ).bb(0)}}
A.ff.prototype={
$2(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
$S:42}
A.fg.prototype={
$1(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
$S:21}
A.cP.prototype={
Z(a,b){var s
if(b==null)return!1
s=!1
if(b instanceof A.cP)if(this.a===b.a)s=this.b===b.b
return s},
gv(a){return A.kn(this.a,this.b,B.o,B.o)},
i(a){var s=this,r=A.k_(A.kv(s)),q=A.cQ(A.kt(s)),p=A.cQ(A.kp(s)),o=A.cQ(A.kq(s)),n=A.cQ(A.ks(s)),m=A.cQ(A.ku(s)),l=A.i5(A.kr(s)),k=s.b,j=k===0?"":A.i5(k)
return r+"-"+q+"-"+p+" "+o+":"+n+":"+m+"."+l+j+"Z"}}
A.cR.prototype={
Z(a,b){if(b==null)return!1
return b instanceof A.cR},
gv(a){return B.b.gv(0)},
i(a){return"0:00:00."+B.e.bZ(B.b.i(0),6,"0")}}
A.fj.prototype={
i(a){return this.S()}}
A.y.prototype={
gaa(){return A.ko(this)}}
A.cH.prototype={
i(a){var s=this.a
if(s!=null)return"Assertion failed: "+A.dT(s)
return"Assertion failed"}}
A.ax.prototype={}
A.a8.prototype={
gb0(){return"Invalid argument"+(!this.a?"(s)":"")},
gb_(){return""},
i(a){var s=this,r=s.c,q=r==null?"":" ("+r+")",p=s.d,o=p==null?"":": "+p,n=s.gb0()+q+o
if(!s.a)return n
return n+s.gb_()+": "+A.dT(s.gba())},
gba(){return this.b}}
A.bg.prototype={
gba(){return A.iW(this.b)},
gb0(){return"RangeError"},
gb_(){var s,r=this.e,q=this.f
if(r==null)s=q!=null?": Not less than or equal to "+A.n(q):""
else if(q==null)s=": Not greater than or equal to "+A.n(r)
else if(q>r)s=": Not in inclusive range "+A.n(r)+".."+A.n(q)
else s=q<r?": Valid value range is empty":": Only valid value is "+A.n(r)
return s}}
A.cT.prototype={
gba(){return A.ad(this.b)},
gb0(){return"RangeError"},
gb_(){if(A.ad(this.b)<0)return": index must not be negative"
var s=this.f
if(s===0)return": no indices are valid"
return": index should be less than "+s},
gn(a){return this.f}}
A.cc.prototype={
i(a){return"Unsupported operation: "+this.a}}
A.dh.prototype={
i(a){var s=this.a
return s!=null?"UnimplementedError: "+s:"UnimplementedError"}}
A.bh.prototype={
i(a){return"Bad state: "+this.a}}
A.cN.prototype={
i(a){var s=this.a
if(s==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.dT(s)+"."}}
A.d8.prototype={
i(a){return"Out of Memory"},
gaa(){return null},
$iy:1}
A.c4.prototype={
i(a){return"Stack Overflow"},
gaa(){return null},
$iy:1}
A.fk.prototype={
i(a){return"Exception: "+this.a}}
A.dW.prototype={
i(a){var s,r,q,p,o,n,m,l,k,j,i,h=this.a,g=""!==h?"FormatException: "+h:"FormatException",f=this.c,e=this.b
if(typeof e=="string"){if(f!=null)s=f<0||f>e.length
else s=!1
if(s)f=null
if(f==null){if(e.length>78)e=B.e.au(e,0,75)+"..."
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
k=""}return g+l+B.e.au(e,i,j)+k+"\n"+B.e.V(" ",f-i+l.length)+"^\n"}else return f!=null?g+(" (at offset "+A.n(f)+")"):g}}
A.cU.prototype={
gaa(){return null},
i(a){return"IntegerDivisionByZeroException"},
$iy:1}
A.i.prototype={
ad(a,b,c){var s=A.L(this)
return A.ig(this,s.u(c).h("1(i.E)").a(b),s.h("i.E"),c)},
T(a,b){var s,r,q=this.gC(this)
if(!q.p())return""
s=J.Z(q.gt())
if(!q.p())return s
if(b.length===0){r=s
do r+=J.Z(q.gt())
while(q.p())}else{r=s
do r=r+b+J.Z(q.gt())
while(q.p())}return r.charCodeAt(0)==0?r:r},
gn(a){var s,r=this.gC(this)
for(s=0;r.p();)++s
return s},
G(a,b){var s,r
A.dd(b,"index")
s=this.gC(this)
for(r=b;s.p();){if(r===0)return s.gt();--r}throw A.d(A.hf(b,b-r,this,"index"))},
i(a){return A.k5(this,"(",")")}}
A.T.prototype={
i(a){return"MapEntry("+A.n(this.a)+": "+A.n(this.b)+")"}}
A.I.prototype={
gv(a){return A.e.prototype.gv.call(this,0)},
i(a){return"null"}}
A.e.prototype={$ie:1,
Z(a,b){return this===b},
gv(a){return A.c_(this)},
i(a){return"Instance of '"+A.eE(this)+"'"},
gD(a){return A.hN(this)},
toString(){return this.i(this)}}
A.dt.prototype={
i(a){return""},
$ial:1}
A.bi.prototype={
gn(a){return this.a.length},
i(a){var s=this.a
return s.charCodeAt(0)==0?s:s}}
A.dZ.prototype={
$2(a,b){var s=t.g
this.a.aq(new A.dX(s.a(a)),new A.dY(s.a(b)),t.X)},
$S:22}
A.dX.prototype={
$1(a){var s=this.a
return s.call(s)},
$S:33}
A.dY.prototype={
$2(a,b){var s,r,q,p
t.K.a(a)
t.l.a(b)
s=t.g.a(v.G.Error)
r=["Dart exception thrown from converted Future. Use the properties 'error' to fetch the boxed error and 'stack' to recover the stack trace."]
r=A.fR(s,r,t.m)
if(t.e.b(a))A.X("Attempting to box non-Dart object.")
q={}
q[$.jE()]=a
r.error=q
r.stack=b.i(0)
p=this.a
p.call(p,r)},
$S:26}
A.h0.prototype={
$1(a){var s,r,q,p
if(A.j1(a))return a
s=this.a
if(s.ac(a))return s.k(0,a)
if(t.eO.b(a)){r={}
s.l(0,a,r)
for(s=a.gan(),s=s.gC(s);s.p();){q=s.gt()
r[q]=this.$1(a.k(0,q))}return r}else if(t.R.b(a)){p=[]
s.l(0,a,p)
B.a.a7(p,J.dz(a,this,t.z))
return p}else return a},
$S:11}
A.h3.prototype={
$1(a){return this.a.a8(this.b.h("0/?").a(a))},
$S:12}
A.h4.prototype={
$1(a){if(a==null)return this.a.bX(new A.eB(a===undefined))
return this.a.bX(a)},
$S:12}
A.fS.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j,i,h
if(A.j0(a))return a
s=this.a
a.toString
if(s.ac(a))return s.k(0,a)
if(a instanceof Date){r=a.getTime()
if(r<-864e13||r>864e13)A.X(A.a1(r,-864e13,864e13,"millisecondsSinceEpoch",null))
A.cD(!0,"isUtc",t.y)
return new A.cP(r,0,!0)}if(a instanceof RegExp)throw A.d(A.a_("structured clone of RegExp",null))
if(typeof Promise!="undefined"&&a instanceof Promise)return A.je(a,t.X)
q=Object.getPrototypeOf(a)
if(q===Object.prototype||q===null){p=t.X
o=A.d_(p,p)
s.l(0,a,o)
n=Object.keys(a)
m=[]
for(s=J.b4(n),p=s.gC(n);p.p();)m.push(A.hM(p.gt()))
for(l=0;l<s.gn(n);++l){k=s.k(n,l)
if(!(l<m.length))return A.a(m,l)
j=m[l]
if(k!=null)o.l(0,j,this.$1(a[k]))}return o}if(a instanceof Array){i=a
o=[]
s.l(0,a,o)
h=A.ad(a.length)
for(s=J.b3(i),l=0;l<h;++l)o.push(this.$1(s.k(i,l)))
return o}return a},
$S:11}
A.eB.prototype={
i(a){return"Promise was rejected with a value of `"+(this.a?"undefined":"null")+"`."}}
A.fx.prototype={
ck(){var s=self.crypto
if(s!=null)if(s.getRandomValues!=null)return
throw A.d(A.dj("No source of cryptographically secure random numbers available."))},
bc(a){var s,r,q,p,o,n,m,l,k=null
if(a<=0||a>4294967296)throw A.d(new A.bg(k,k,!1,k,k,"max must be in range 0 < max \u2264 2^32, was "+a))
if(a>255)if(a>65535)s=a>16777215?4:3
else s=2
else s=1
r=this.a
r.$flags&2&&A.x(r,11)
r.setUint32(0,0,!1)
q=4-s
p=A.ad(Math.pow(256,s))
for(o=a-1,n=(a&o)===0;!0;){crypto.getRandomValues(J.jH(B.aB.gbV(r),q,s))
m=r.getUint32(0,!1)
if(n)return(m&o)>>>0
l=m%a
if(m-l+a<p)return l}}}
A.dR.prototype={}
A.bv.prototype={
S(){return"Base58Alphabets."+this.b}}
A.dH.prototype={}
A.fb.prototype={
m(a,b){var s=this,r=s.b,q=A.br(b,"\n","")
r=s.b=r+A.br(q,"\r","")
for(q=s.a;r.length>=4;){B.a.a7(q,A.ix(B.e.au(r,0,4)))
r=B.e.aT(s.b,4)
s.b=r}}}
A.fc.prototype={
$0(){var s,r=t.S,q=A.ab(256,-1,!1,r)
for(s=0;s<64;++s)B.a.l(q,u.n.charCodeAt(s),s)
return A.hm(q,r)},
$S:37}
A.fd.prototype={
m(a,b){var s,r,q,p=this.b
B.a.a7(p,t.L.a(b))
for(s=this.a,r=p.$flags|0;p.length>=3;){q=A.iy(B.a.W(p,0,3))
s.a+=q
r&1&&A.x(p,18)
A.c0(0,3,p.length)
p.splice(0,3)}}}
A.dG.prototype={}
A.dP.prototype={
i(a){return this.a}}
A.eJ.prototype={
aO(a){var s,r,q,p,o,n=this
t.L.a(a)
if(n.f)throw A.d(B.am)
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
r=o}if(p===64){n.b2(n.b,n.a,q,0,64)
n.d=0}}if(s>=64){r=n.b2(n.b,n.a,a,r,s)
s=B.b.a_(s,64)}for(q=n.c;s>0;r=o){p=n.d++
o=r+1
if(!(r<a.length))return A.a(a,r)
B.a.l(q,p,a[r]&255);--s}return n},
eg(a){var s,r,q,p,o,n,m,l=this
t.L.a(a)
if(!l.f){s=l.e
r=l.d
q=B.b.I(s,536870912)
p=B.b.a_(s,64)<56?64:128
o=l.c
B.a.l(o,r,128)
for(n=r+1,m=p-8;n<m;++n)B.a.l(o,n,0)
A.hS(q>>>0,o,m)
A.hS(s<<3>>>0,o,p-4)
l.b2(l.b,l.a,o,0,p)
l.f=!0}for(q=l.a,n=0;n<8;++n)A.hS(q[n],a,n*4)
return l},
c1(){var s=this,r=s.a
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
b2(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=t.L
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
A.dI.prototype={
i(a){var s,r,q=this.b
if(q==null)q=null
else{s=A.L(q).h("at<1,2>")
s=new A.ce(new A.at(q,s),s.h("C(i.E)").a(new A.dJ()),s.h("ce<i.E>"))
q=s}if(q==null)q=A.b([],t.ao)
s=t.N
r=A.d_(s,t.z)
r.e8(q)
if(r.a===0)return this.a
q=r.$ti.h("at<1,2>")
return this.a+" "+A.ig(new A.at(r,q),q.h("j(i.E)").a(new A.dK()),q.h("i.E"),s).T(0,", ")}}
A.dJ.prototype={
$1(a){return t.w.a(a).b!=null},
$S:63}
A.dK.prototype={
$1(a){t.w.a(a)
return A.n(a.a)+": "+A.n(a.b)},
$S:53}
A.b8.prototype={}
A.eA.prototype={}
A.fw.prototype={
ef(a,b){var s,r,q,p,o,n
t.L.a(a)
A.jT(a,"Invalid hex bytes")
s=a.length
r=A.ab(s*2,"",!1,t.N)
for(q=0;q<s;++q){if(!(q<a.length))return A.a(a,q)
p=a[q]
o=q*2
n=B.b.a5(p,4)
if(!(n<16))return A.a(B.u,n)
B.a.l(r,o,B.u[n])
n=p&15
if(!(n<16))return A.a(B.u,n)
B.a.l(r,o+1,B.u[n])}return B.a.bb(r)},
ec(a){var s,r,q,p,o,n,m=a.length
if(m===0){m=J.i9(0,t.S)
return m}if((m&1)!==0)throw A.d(B.a7)
s=A.ab(B.b.I(m,2),0,!1,t.S)
for(r=!1,q=0;q<m;q+=2){p=a.charCodeAt(q)
o=p<128?B.X[p]:256
p=q+1
if(!(p<m))return A.a(a,p)
p=a.charCodeAt(p)
n=p<128?B.X[p]:256
B.a.l(s,B.b.I(q,2),(o<<4|n)&255)
r=B.T.be(r,B.T.be(o===256,n===256))}if(r)throw A.d(B.a8)
return s}}
A.aw.prototype={
S(){return"StringEncoding."+this.b}}
A.eX.prototype={
$1(a){var s
if(a===6)return this.a.bc(16)&15|64
else{s=this.a
if(a===8)return s.bc(4)&3|8
else return s.bc(256)}},
$S:21}
A.eY.prototype={
$1(a){return B.e.bZ(B.b.ew(A.ad(a),16),2,"0")},
$S:61}
A.dS.prototype={
Z(a,b){var s=this
if(b==null)return!1
if(s===b)return!0
if(!(b instanceof A.cd))return!1
if(A.hN(b)!==A.hN(s))return!1
return A.jZ([s.b,s.a],[b.b,b.a],t.z)},
gv(a){return A.i6([this.b,this.a])}}
A.d0.prototype={
S(){return"LockId."+this.b}}
A.eR.prototype={
af(a,b){var s=B.Z
return this.ci(b.h("0/()").a(a),b,b)},
ci(a,b,c){var s=0,r=A.ah(c),q,p=2,o=[],n=[],m=this,l,k,j,i,h
var $async$af=A.ai(function(d,e){if(d===1){o.push(e)
s=p}while(true)switch(s){case 0:k=B.Z
j=m.a
i=j.k(0,k)
h=new A.ct(new A.q($.u,t.U),t.aj)
j.l(0,k,h.a)
p=3
s=i!=null?6:7
break
case 6:s=8
return A.aC(i,$async$af)
case 8:case 7:l=a.$0()
s=l instanceof A.q?9:11
break
case 9:j=l
s=12
return A.aC(b.h("M<0>").b(j)?j:A.hz(b.a(j),b),$async$af)
case 12:j=e
q=j
n=[1]
s=4
break
s=10
break
case 11:q=l
n=[1]
s=4
break
case 10:n.push(5)
s=4
break
case 3:n=[2]
case 4:p=2
h.toString
h.aI()
s=n.pop()
break
case 5:case 1:return A.af(q,r)
case 2:return A.ae(o.at(-1),r)}})
return A.ag($async$af,r)}}
A.cd.prototype={
i(a){return this.a}}
A.dw.prototype={}
A.e8.prototype={
$1(a){return J.Z(t.K.a(a))},
$S:64}
A.e7.prototype={
$0(){return A.k(this.a.dataHex)},
$S:13}
A.e6.prototype={
$0(){return B.e.aT(A.k(this.a.dataHex),2)},
$S:13}
A.e3.prototype={
$0(){return t.K.a(this.a.data)},
$S:7}
A.e4.prototype={
$1(a){var s=t.K
s.a(a).serializeFixedBytes(s.a(this.a.data))},
$S:14}
A.e5.prototype={
$0(){return A.k(this.a.dataHex)},
$S:13}
A.aH.prototype={
S(){return"JSAptosWalletStandardUserResponseStatus."+this.b}}
A.e9.prototype={
$1(a){return t.c_.a(a).c===this.a},
$S:48}
A.ea.prototype={
$0(){return A.X(B.l)},
$S:4}
A.aM.prototype={
c8(a,b,c,d){var s,r,q
t.K.a(a)
try{r=v.G
s=r.Reflect.get(a,b,d)
if(typeof s==="undefined"){r=A.iV(r.Reflect.set(a,b,c,d))
return r}return!1}catch(q){return!1}},
c7(a,b,c){var s,r,q
t.K.a(a)
s=b==null
r=!s||null
if(r===!0)if(!s&&typeof b==="string")if(B.e.bh(A.k(A.hM(b)),"is")){q=v.G.Reflect.get(a,b,c)
if(q!=null)return q
return!0}return v.G.Reflect.get(a,b,c)}}
A.d9.prototype={}
A.dQ.prototype={
$1(a){var s,r=t.m
r.a(a)
s=v.G
r.a(s.window).dispatchEvent(this.a)
r.a(s.window).removeEventListener("eip6963:requestProvider",A.f(this))},
$S:8}
A.f6.prototype={
$2(a,b){var s,r,q,p=t.g
p.a(a)
p.a(b)
p=this.a.aq(new A.f3(a),new A.f4(b),t.X)
s=new A.f5(b,a)
r=p.$ti
q=$.u
if(q!==B.h)s=A.j2(s,q)
p.aw(new A.aA(new A.q(q,r),2,null,s,r.h("aA<1,1>")))},
$S:22}
A.f3.prototype={
$1(a){var s=this.a
s.call(s,a)
return a},
$S:11}
A.f4.prototype={
$2(a,b){var s
t.K.a(a)
t.l.a(b)
s=this.a
s.call(s,a)
return a},
$S:57}
A.f5.prototype={
$1(a){this.a.call(this.b,a)
return a},
$S:23}
A.eG.prototype={
$0(){return this.a.a},
$S:9}
A.eH.prototype={
$0(){return this.a.b},
$S:15}
A.eI.prototype={
$0(){var s,r,q=this.a,p=v.G,o=t.m,n=o.a(p.Object),m=o.a(n.create.apply(n,[null]))
m.set=A.hG(q.gaR())
m.get=A.hF(q.gaQ())
n=o.a(p.Object)
s=o.a(n.create.apply(n,[null]))
s.get=A.v(new A.eG(q))
n=o.a(p.Object)
n.defineProperty.apply(n,[m,"debugKey",s])
n=o.a(p.Object)
r=o.a(n.create.apply(n,[null]))
r.get=A.v(new A.eH(q))
p=o.a(p.Object)
p.defineProperty.apply(p,[m,"object",r])
return m},
$S:7}
A.eF.prototype={
$1(a){return A.k(a)},
$S:27}
A.h1.prototype={
$1(a){var s,r,q=this,p=t.m
p.a(a)
s=q.a
if(s.a)return
r=p.a(p.a(a.detail).data)
if(A.ie(A.k(r.status))===B.M){s=r.data
if(s==null)s=t.K.a(s)
if(A.B(s.message)!=null)p.a(v.G.console).error(A.B(s.message))
p=q.b.d
if(p!=null)p.aI()
return}s.a=!0
p.a(v.G.window).addEventListener("WALLET_ACTIVATION",A.f(q))
p=r.data
q.b.el(A.k(p==null?null:A.hM(p)))},
$S:8}
A.aI.prototype={
S(){return"JSWalletMessageType."+this.b}}
A.er.prototype={
$1(a){return t.fr.a(a).b===this.a},
$S:35}
A.es.prototype={
$0(){return A.X(B.l)},
$S:4}
A.R.prototype={
S(){return"JSNetworkEventType."+this.b}}
A.ei.prototype={
$1(a){return t.bs.a(a).b===this.a},
$S:36}
A.ej.prototype={
$0(){return A.X(B.l)},
$S:4}
A.a4.prototype={
S(){return"JSEventType."+this.b}}
A.eg.prototype={
$1(a){return t.G.a(a).b===this.a},
$S:28}
A.eh.prototype={
$0(){return A.X(B.l)},
$S:4}
A.ef.prototype={
$1(a){return t.G.a(a).b===this.a},
$S:28}
A.aJ.prototype={
S(){return"JSWalletResponseType."+this.b}}
A.ew.prototype={
$1(a){return t.e5.a(a).b===this.a},
$S:38}
A.ex.prototype={
$0(){return A.X(B.l)},
$S:4}
A.H.prototype={
S(){return"JSClientType."+this.b}}
A.ed.prototype={
$1(a){return t.D.a(a).b===this.a},
$S:39}
A.ee.prototype={
$0(){return A.X(B.l)},
$S:4}
A.db.prototype={
S(){return"PageRequestType."+this.b}}
A.eb.prototype={
gL(){var s=this.a
if(s===$){s!==$&&A.cF("requestController")
s=this.a=new A.da(this.gc_(),A.d_(t.N,t.p))}return s},
gbR(){var s,r,q=this,p=q.b
if(p===$){s=q.gL()
r=A.b([],t.I)
q.b!==$&&A.cF("_walletStandardController")
p=q.b=new A.bL(s,{},{},r)}return p},
aG(){var s=0,r=A.ah(t.H),q,p=this,o
var $async$aG=A.ai(function(a,b){if(a===1)return A.ae(b,r)
while(true)switch(s){case 0:o=p.c
o=o==null?null:o.af(new A.ec(p),t.H)
s=3
return A.aC(o instanceof A.q?o:A.hz(o,t.H),$async$aG)
case 3:q=b
s=1
break
case 1:return A.af(q,r)}})
return A.ag($async$aG,r)},
gbG(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=this,a3=a2.f
if(a3===$){s=a2.gL()
r=t.I
q=t.G
p=t.u
o=A.z([B.f,A.b([],r),B.i,A.b([],r),B.k,A.b([],r),B.c,A.b([],r),B.m,A.b([],r)],q,p)
n=A.z([B.d,A.b([],r),B.c,A.b([],r)],q,p)
m=a2.gL()
l={base58:!1,hex:!1}
k=A.z([B.f,A.b([],r),B.i,A.b([],r),B.k,A.b([],r),B.m,A.b([],r)],q,p)
j=A.z([B.d,A.b([],r),B.c,A.b([],r)],q,p)
i=a2.gL()
h=A.z([B.d,A.b([],r),B.c,A.b([],r)],q,p)
g=a2.gL()
f=A.z([B.d,A.b([],r),B.c,A.b([],r)],q,p)
e=a2.gL()
d=A.z([B.d,A.b([],r),B.c,A.b([],r)],q,p)
c=a2.gL()
b=A.z([B.f,A.b([],r)],q,p)
a=A.z([B.d,A.b([],r),B.c,A.b([],r)],q,p)
a0=a2.gL()
a1=A.z([B.B,new A.bD(o,s,n),B.I,new A.ca(l,k,m,j),B.D,new A.c3(i,h),B.H,new A.c9(g,f),B.E,new A.c5(e,d),B.F,new A.c7(b,c,a),B.y,new A.bt(A.z([B.f,A.b([],r),B.i,A.b([],r)],q,p),a0,A.z([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.G,new A.c8(a2.gL(),A.z([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.A,new A.bA(a2.gL(),A.z([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.z,new A.bw(a2.gL(),A.z([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.J,new A.c2(a2.gL(),A.z([B.d,A.b([],r),B.c,A.b([],r)],q,p)),B.C,new A.bS(a2.gL(),A.z([B.d,A.b([],r),B.c,A.b([],r)],q,p))],t.D,t.aQ)
a2.f!==$&&A.cF("_networks")
a2.f=a1
a3=a1}return a3},
d3(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b="Initializing wallet failed: "
try{for(m=c.gbG(),m=new A.at(m,A.L(m).h("at<1,2>")).gC(0),l=t.m,k=v.G,j=t.I,i=c.gc_(),h=t.N,g=t.p;m.p();){f=m.d
f.toString
s=f
try{r=s.b
e=c.b
if(e===$){e=c.a
if(e===$){e!==$&&A.cF("requestController")
e=c.a=new A.da(i,A.d_(h,g))}f=A.b([],j)
c.b!==$&&A.cF("_walletStandardController")
e=c.b=new A.bL(e,{},{},f)}r.P(e.c)}catch(d){q=A.ao(d)
p=A.aP(d)
l.a(k.console).error(b+s.a.c+" "+A.n(q)+" "+A.n(p))}}c.gbR().ai()}catch(d){o=A.ao(d)
n=A.aP(d)
t.m.a(v.G.console).error(b+A.n(o)+" "+A.n(n))}},
ej(a){var s,r,q,p,o=t.m
if(A.kg(A.k(o.a(a.data).type))===B.V){s=this.gL().b.k(0,A.k(a.requestId))
if(s!=null){o=o.a(a.data)
s.b.a8(o)}return}r=o.a(a.data)
if((A.B(a.client)==null?null:A.ib(A.B(a.client)))==null){s=this.gbR()
r=o.a(r.data)
o=t.r
if(o.a(r.accounts)!=null){q=o.a(r.accounts)
q.toString
s.b.accounts=q}if(o.a(r.chains)!=null){q=o.a(r.chains)
q.toString
s.b.chains=q}p={}
p.change=r
p.accounts=o.a(r.accounts)
p.chains=o.a(r.chains)
s.cS(p)
return}o=this.gbG()
o=o.k(0,A.B(a.client)==null?null:A.ib(A.B(a.client)))
if(o!=null)o.ao(r)}}
A.ec.prototype={
$0(){var s=0,r=A.ah(t.H),q,p=2,o=[],n=[],m=this,l
var $async$$0=A.ai(function(a,b){if(a===1){o.push(b)
s=p}while(true)switch(s){case 0:p=3
l=m.a.d
l=l==null?null:l.a
s=6
return A.aC(l instanceof A.q?l:A.hz(l,t.H),$async$$0)
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
case 5:case 1:return A.af(q,r)
case 2:return A.ae(o.at(-1),r)}})
return A.ag($async$$0,r)},
$S:40}
A.cX.prototype={
aL(a){return this.eq(a)},
eq(a){var s=0,r=A.ah(t.H),q=this,p,o,n
var $async$aL=A.ai(function(b,c){if(b===1)return A.ae(c,r)
while(true)switch(s){case 0:s=2
return A.aC(q.aG(),$async$aL)
case 2:p=q.e
o=v.G
n=t.m
p=n.a(new o.CustomEvent(p,{bubbles:!0,cancelable:!1,detail:a,data:null}))
n.a(o.window).dispatchEvent(p)
return A.af(null,r)}})
return A.ag($async$aL,r)},
dk(a){var s=t.m
this.ej(s.a(s.a(a).detail))},
el(a){var s,r=this
if(r.e!=null)return
r.e="WALLET_"+a
t.m.a(v.G.window).addEventListener("ETH_"+a,A.f(r.gdj()))
s=r.d
if(s!=null)s.aI()}}
A.bL.prototype={
b5(a,b){var s
A.k(a)
t.g.a(b)
s=A.bH(a)
if(s!==B.d)return null
if(s!=null)B.a.m(this.d,b)
this.a.a.$1(A.ii(null,A.be(B.d)))
return A.v(new A.en(this,b))},
cS(a){var s,r,q,p=A.a6(this.d,t.g)
for(s=p.length,r=0;r<p.length;p.length===s||(0,A.an)(p),++r){q=p[r]
q.call(q,a)}},
q(a){return A.Y(new A.ek(this,t.A.a(a)).$0(),t.m)},
B(){return this.q(null)},
ai(){var s,r,q,p=this,o=p.c
o["standard:events"]=A.a5(A.w(p.gK()))
s={}
s.connect=A.f(p.gA())
s.version="1.0.0"
o["standard:connect"]=s
r=p.b
r.features=o
r.name="OnChain"
r.version="1.0.0"
r.icon=u.f
r.accounts=A.b([],t.O)
r=v.G
o=t.m
q=o.a(new r.CustomEvent("wallet-standard:register-wallet",{bubbles:!1,cancelable:!1,detail:A.f(new A.el(p))}))
o.a(r.window).addEventListener("wallet-standard:app-ready",A.f(new A.em(q)))
o.a(r.window).dispatchEvent(q)}}
A.en.prototype={
$0(){B.a.ap(this.a.d,this.b)},
$S:2}
A.ek.prototype={
$0(){var s=0,r=A.ah(t.m),q,p=this,o,n,m
var $async$$0=A.ai(function(a,b){if(a===1)return A.ae(b,r)
while(true)switch(s){case 0:n=p.a
m=p.b
m=m!=null?A.b([m],t.O):null
s=3
return A.aC(n.a.O("connect",m,t.m),$async$$0)
case 3:o=b
n.b.accounts=t.c.a(o.accounts)
q=o
s=1
break
case 1:return A.af(q,r)}})
return A.ag($async$$0,r)},
$S:43}
A.el.prototype={
$1(a){t.K.a(a).register(this.a.b)},
$S:14}
A.em.prototype={
$1(a){t.K.a(a)
t.m.a(v.G.window).dispatchEvent(this.a)},
$S:14}
A.J.prototype={
a2(a,b,c,d){return this.a.c5(this.gH(),a,b,c,d)},
j(a,b,c){return this.a2(a,b,B.n,c)},
c3(a,b){return this.a2(a,null,B.n,b)},
c4(a,b,c){return this.a2(a,null,b,c)},
O(a,b,c){return this.eB(a,b,c,c)},
ez(a,b){return this.O(a,null,b)},
eB(a,b,c,d){var s=0,r=A.ah(d),q,p=this
var $async$O=A.ai(function(e,f){if(e===1)return A.ae(f,r)
while(true)switch(s){case 0:q=p.a.ae(p.gH(),a,b,B.n,c)
s=1
break
case 1:return A.af(q,r)}})
return A.ag($async$O,r)},
cP(){return this.a.eC(this.gH(),"disconnect",t.X)},
ab(a){var s=A.kb(A.k(a.event))
if(!(s===B.f||s===B.i||s===B.k||s===B.d))return
this.a.a.$1(A.ii(this.gH(),a))},
b5(a,b){var s,r
A.k(a)
t.g.a(b)
s=A.bH(a)
r=this.b
if(r.k(0,s)==null)throw A.d({message:"Unsuported "+A.kd(a)+" event."})
if(s!=null){r=r.k(0,s)
r.toString
B.a.m(r,b)
this.ab(A.be(s))}},
aA(a,b){var s,r,q,p=A.a6(t.u.a(a),t.g)
for(s=p.length,r=0;r<p.length;p.length===s||(0,A.an)(p),++r){q=p[r]
q.call(q,b)}},
bt(a,b){var s=this.b
if(!s.ac(a))return
s=s.k(0,a)
s.toString
this.aA(s,b)},
ao(a){var s,r,q,p=t.m.a(a.data),o=A.et(p)
for(s=o.length,r=t.A,q=0;q<o.length;o.length===s||(0,A.an)(o),++q)switch(o[q]){case B.U:this.bt(B.d,r.a(p.change))
break}}}
A.da.prototype={
aC(a,b){return this.d2(a,b)},
d2(a,b){var s=0,r=A.ah(t.m),q,p=2,o=[],n=[],m=this,l,k,j,i
var $async$aC=A.ai(function(c,d){if(c===1){o.push(d)
s=p}while(true)switch(s){case 0:i=new A.d9(A.kG(),new A.az(new A.q($.u,t.et),t.x))
p=3
k=i.a
j=a==null?null:a.b
l={data:b,requestId:k,client:j}
m.a.$1(l)
j=m.b
k=i.a
if(j.k(0,k)==null)j.l(0,k,i)
s=6
return A.aC(i.b.a,$async$aC)
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
m.b.ap(0,i.a)
s=n.pop()
break
case 5:case 1:return A.af(q,r)
case 2:return A.ae(o.at(-1),r)}})
return A.ag($async$aC,r)},
c5(a,b,c,d,e){return A.Y(this.ae(a,b,c,d,e),e)},
eC(a,b,c){return this.c5(a,b,null,B.n,c)},
ae(a,b,c,d,e){return this.eA(a,b,c,d,e,e)},
O(a,b,c){return this.ae(null,a,b,B.n,c)},
eA(a,b,c,d,e,f){var s=0,r=A.ah(f),q,p=this,o,n
var $async$ae=A.ai(function(g,h){if(g===1)return A.ae(h,r)
while(true)$async$outer:switch(s){case 0:s=3
return A.aC(p.aC(a,{type:"request",method:b,params:c,providerType:d.b}),$async$ae)
case 3:n=h
switch(A.ie(A.k(n.status))){case B.W:q=e.a(n.data)
s=1
break $async$outer
case B.M:o=A.m2(n,"data",t.X)
throw A.d(o==null?t.K.a(o):o)}case 1:return A.af(q,r)}})
return A.ag($async$ae,r)}}
A.bt.prototype={
cE(a){var s=t.K
return this.j("wallet_switchAptosChain",A.b([s.a(a)],t.f),s)},
F(a){var s=t.K
return A.Y(this.O("aptos_signMessage",A.b([s.a(a)],t.f),s).aM(new A.dB(),s),s)},
N(a){var s=t.K
return A.Y(this.O("aptos_signTransaction",A.b([A.k9(s.a(a))],t.f),s).aM(new A.dC(),s),s)},
bJ(a){var s,r,q
A.B(a)
s=a!=null?A.aa(a):null
r=A.b([],t.s)
if(s!=null)r.push(s)
q=t.K
return A.Y(this.O("aptos_requestAccounts",r,q).aM(new A.dA(),q),q)},
dz(){return this.bJ(null)},
de(){return this.c3("aptos_network",t.K)},
dg(a){var s
t.g.a(a)
s=this.c.k(0,B.f)
s.toString
B.a.m(s,a)
this.ab(A.be(B.f))},
di(a){var s
t.g.a(a)
s=this.c.k(0,B.i)
s.toString
B.a.m(s,a)
this.ab(A.be(B.i))},
aA(a,b){var s,r,q=A.a6(t.u.a(a),t.g)
for(s=q.length,r=0;r<q.length;q.length===s||(0,A.an)(q),++r)q[r].call(null,b)},
ao(a){var s,r,q,p,o,n,m,l,k=this
k.aU(a)
s=t.m.a(a.data)
r=A.et(s)
for(q=r.length,p=k.c,o=t.A,n=0;n<r.length;r.length===q||(0,A.an)(r),++n)switch(r[n]){case B.t:m=p.k(0,B.f)
m.toString
k.aA(m,o.a(s.account))
break
case B.r:l=s.chainChanged
if(l!=null){m=p.k(0,B.i)
m.toString
k.aA(m,l)}break}},
gH(){return B.y},
P(a){var s=this,r=s.gdw(),q={}
q.connect=A.f(r)
q.version="1.0.0"
a["aptos:connect"]=q
q={}
q.signTransaction=A.f(s.gM())
q.version="1.0.0"
a["aptos:signTransaction"]=q
q={}
q.signMessage=A.f(s.gE())
q.version="1.0.0"
a["aptos:signMessage"]=q
q={}
q.account=A.f(r)
q.version="1.0.0"
a["aptos:account"]=q
q={}
q.onNetworkChange=A.f(s.gdh())
q.version="1.0.0"
a["aptos:onNetworkChange"]=q
q={}
q.network=A.v(s.gdd())
q.version="1.0.0"
a["aptos:network"]=q
q={}
q.onAccountChange=A.f(s.gdf())
q.version="1.0.0"
a["aptos:onAccountChange"]=q
q={}
q.disconnect=A.v(s.gJ())
q.version="1.0.0"
a["aptos:disconnect"]=q
q={}
q.changeNetwork=A.f(s.gcD())
q.version="1.0.0"
a["aptos:changeNetwork"]=q
a["aptos:events"]=A.a5(A.w(s.gK()))}}
A.dB.prototype={
$1(a){var s,r=t.K
r.a(a)
if(A.hh(A.k(a.status))===B.q)return a
s=r.a(a.args)
A.hg(s)
return A.hi(s,r)},
$S:18}
A.dC.prototype={
$1(a){var s,r=t.K
r.a(a)
if(A.hh(A.k(a.status))===B.q)return a
s=r.a(a.args)
A.hg(s)
return A.hi(s,r)},
$S:18}
A.dA.prototype={
$1(a){var s,r,q=t.K
q.a(a)
if(A.hh(A.k(a.status))===B.q)return a
s=t.m
r=s.a(q.a(a.args))
A.hg(s.a(r.publicKey))
r.publicKey=A.a7(s.a(r.publicKey),s)
return A.hi(r,s)},
$S:18}
A.bw.prototype={
P(a){var s=this,r={}
r.connect=A.f(s.gA())
r.version="1.0.0"
a["bitcoin:connect"]=r
r={}
r.signPersonalMessage=A.f(s.gcz())
r.version="1.0.0"
a["bitcoin:signPersonalMessage"]=r
r={}
r.signTransaction=A.f(s.gcB())
r.version="1.0.0"
a["bitcoin:signTransaction"]=r
r={}
r.getAccountAddresses=A.f(s.gd_())
r.version="1.0.0"
a["bitcoin:getAccountAddresses"]=r
r={}
r.sendTransaction=A.f(s.gcv())
r.version="1.0.0"
a["bitcoin:sendTransaction"]=r
a["bitcoin:disconnect"]=A.ar(A.v(s.gJ()))
a["bitcoin:events"]=A.a5(A.w(s.gK()))},
q(a){var s=A.aa(A.B(a)),r=s==null?null:A.b([s],t.s)
return this.j("bitcoin_requestAccounts",r,t.m)},
B(){return this.q(null)},
cA(a){var s=t.K
return this.j("bitcoin_signPersonalMessage",A.b([s.a(a)],t.f),s)},
cC(a){var s=t.K
return this.j("bitcoin_signTransaction",A.b([s.a(a)],t.f),s)},
d0(a){return this.j("bitcoin_getAccountAddresses",A.b([t.K.a(a)],t.f),t.c)},
cw(a){return this.j("bitcoin_sendTransaction",A.S(t.c.a(a)),t.K)},
gH(){return B.z}}
A.bA.prototype={
bY(a){var s=A.aa(A.B(a)),r=s==null?null:A.b([s],t.s)
return this.j("cosmos_requestAccounts",r,t.m)},
eb(){return this.bY(null)},
F(a){var s=t.K
return this.j("cosmos_signMessage",A.b([s.a(a)],t.f),s)},
cc(a){var s=t.K
return this.j("cosmos_signTransactionDirect",A.b([s.a(a)],t.f),s)},
ca(a){var s=t.K
return this.j("cosmos_signTransactionAmino",A.b([s.a(a)],t.f),s)},
bx(a,b){var s,r,q
A.k(a)
s=A.v(new A.dN(this,a))
r=A.w(new A.dO(this,a,b))
q={}
q.getAccounts=s
q.signDirect=r
return A.a7(q,t.K)},
bw(a){return this.bx(a,null)},
bB(a,b){var s,r,q
A.k(a)
s=A.v(new A.dL(this,a))
r=A.w(new A.dM(this,a,b))
q={}
q.getAccounts=s
q.signAmino=r
return A.a7(q,t.K)},
bA(a){return this.bB(a,null)},
bO(a,b){var s,r
A.k(a)
s=this.bw(a)
r={}
r.amino=this.bA(a)
r.direct=s
return A.a7(r,t.K)},
e4(a){return this.bO(a,null)},
d1(a){A.k(a)
throw A.d(A.ht(null))},
gH(){return B.A},
aW(a){return this.j("wallet_addCosmosChain",A.b([t.K.a(a)],t.f),t.y)},
N(a){var s=t.K
return this.j("cosmos_signTransaction",A.b([s.a(a)],t.f),s)},
P(a){var s,r,q=this
if(q.c==null){s={}
s.getOfflineSigner=A.w(q.gbv())
s.getOfflineSignerOnlyAmino=A.w(q.gbz())
s.getOfflineSignerAuto=A.f(q.gby())
r=A.a7(s,t.m)
q.c=s
q.d=r}r=v.G
r.cosmos=q.d
r.getOfflineSigner=A.w(q.gbv())
r.getOfflineSignerOnlyAmino=A.w(q.gbz())
r.getOfflineSignerAuto=A.f(q.gby())
s={}
s.connect=A.f(q.gea())
s.version="1.0.0"
a["cosmos:connect"]=s
a["cosmos:events"]=A.a5(A.w(q.gK()))
s={}
s.signer=A.w(q.ge3())
s.version="1.0.0"
a["cosmos:signer"]=s
s={}
s.signTransactionDirect=A.f(q.gcb())
s.version="1.0.0"
a["cosmos:signTransactionDirect"]=s
s={}
s.signTransactionAmino=A.f(q.gc9())
s.version="1.0.0"
a["cosmos:signTransactionAmino"]=s
s={}
s.addNewChain=A.f(q.gaV())
s.version="1.0.0"
a["cosmos:addNewChain"]=s
s={}
s.signMessage=A.f(q.gE())
s.version="1.0.0"
a["cosmos:signMessage"]=s
s={}
s.signTransaction=A.f(q.gM())
s.version="1.0.0"
a["cosmos:signTransaction"]=s
a["cosmos:disconnect"]=A.ar(A.v(q.gJ()))}}
A.dN.prototype={
$0(){return this.a.j("cosmos_requestAccounts",A.io(A.b([this.b],t.s)),t.c)},
$S:5}
A.dO.prototype={
$2(a,b){var s,r
A.k(a)
s=t.K
r={}
r.signDoc=s.a(b)
r.signerAddress=a
r.chainId=this.b
r.signOption=this.c
return this.a.j("cosmos_signTransactionDirect",A.b([r],t.f),s)},
$S:30}
A.dL.prototype={
$0(){return this.a.j("cosmos_requestAccounts",A.io(A.b([this.b],t.s)),t.c)},
$S:5}
A.dM.prototype={
$2(a,b){var s,r
A.k(a)
s=t.K
s.a(b)
r={}
r.signDoc=A.k(t.m.a(v.G.JSON).stringify(b))
r.signerAddress=a
r.chainId=this.b
r.signOption=this.c
return this.a.j("cosmos_signTransactionAmino",A.b([r],t.f),s)},
$S:30}
A.bD.prototype={
b6(a){t.m.a(a)
return this.a2(A.k(a.method),A.S(a.params),B.j,t.X)},
ai(){var s,r,q,p,o,n,m,l,k=this,j=k.c
if(j==null){j=A.v(k.gcG())
r=A.f(k.gaD())
q=A.w(k.gcq())
p=A.w(k.gdn())
o=A.v(k.gJ())
n={}
n.request=r
n.on=q
n.removeListener=p
n.disconnect=o
n.enable=j
n.connect=j
n.isOnChain=!0
k.c=n
j=n}r=t.m
m=A.a7(j,r)
s=m
try{v.G.ethereum=s}catch(l){r.a(v.G.console).error("failed to set ethereum ")}A.k0(s)},
cH(){return this.c4("eth_requestAccounts",B.j,t.c)},
q(a){var s=A.aa(A.B(a)),r=s==null?null:A.b([s],t.s)
return this.j("eth_requestAccounts",r,t.m)},
B(){return this.q(null)},
aW(a){return this.j("wallet_addEthereumChain",A.S(t.m.a(a)),t.N)},
dZ(a){return this.j("eth_signTypedData",A.S(t.m.a(a)),t.N)},
e0(a){return this.j("eth_signTypedData_v3",A.S(t.m.a(a)),t.N)},
e2(a){return this.j("eth_signTypedData_v4",A.S(t.m.a(a)),t.N)},
dm(a){return this.j("personal_sign",A.S(t.m.a(a)),t.N)},
cX(a){return this.j("eth_sign",A.S(t.m.a(a)),t.N)},
Y(a){return this.j("eth_sendTransaction",A.S(t.m.a(a)),t.N)},
P(a){var s,r=this
r.ai()
s={}
s.connect=A.f(r.gA())
s.version="1.0.0"
a["ethereum:connect"]=s
s={}
s.addNewChain=A.f(r.gaV())
s.version="1.0.0"
a["ethereum:addNewChain"]=s
s={}
s.signTypedData=A.f(r.gdY())
s.version="1.0.0"
a["ethereum:signTypedData"]=s
s={}
s.signTypedDataV3=A.f(r.ge_())
s.version="1.0.0"
a["ethereum:signTypedDataV3"]=s
s={}
s.signTypedDataV4=A.f(r.ge1())
s.version="1.0.0"
a["ethereum:signTypedDataV4"]=s
s={}
s.personalSign=A.f(r.gdl())
s.version="1.0.0"
a["ethereum:personalSign"]=s
s={}
s.ethSign=A.f(r.gcW())
s.version="1.0.0"
a["ethereum:ethSign"]=s
s={}
s.sendTransaction=A.f(r.gX())
s.version="1.0.0"
a["ethereum:sendTransaction"]=s
s={}
s.request=A.f(r.gaD())
s.version="1.0.0"
a["ethereum:request"]=s
a["ethereum:events"]=A.a5(A.w(r.gK()))
a["ethereum:disconnect"]=A.ar(A.v(r.gJ()))},
ao(a){var s,r,q,p,o,n,m,l,k=this,j=null
k.aU(a)
s=t.m.a(a.data)
r=A.et(s)
for(q=r.length,p=t.A,o=0;o<r.length;r.length===q||(0,A.an)(r),++o)switch(r[o]){case B.t:n=k.c
if(n!=null){m=p.a(s.account)
m=m==null?j:A.k(m.address)
n.selectedAddress=m}break
case B.L:k.ag(B.c,s.message)
k.bt(B.c,s.message)
break
case B.K:n=p.a(s.networkAccounts)
k.ag(B.f,n==null?j:A.id(n))
break
case B.r:l=p.a(s.chainChanged)
n=k.c
if(n!=null){m=l==null?j:A.k(l.chainId)
n.chainId=m}n=k.c
if(n!=null){m=l==null?j:A.k(l.netVersion)
n.networkVersion=m}if(s.disconnect!=null)k.ag(B.m,s.disconnect)
if(l!=null){if(s.disconnect==null)k.ag(B.k,l)
k.ag(B.i,A.k(l.chainId))}break}},
ag(a,b){var s,r,q
if(b==null||!this.d.ac(a))return
s=this.d.k(0,a)
s.toString
s=A.a6(s,t.g)
for(r=s.length,q=0;q<s.length;s.length===r||(0,A.an)(s),++q)s[q].call(null,b)},
cr(a,b){var s,r
A.k(a)
t.g.a(b)
s=A.bH(a)
if(s==null)return
r=this.d.k(0,s)
if(r!=null)B.a.m(r,b)
this.ab(A.be(s))},
dq(a,b){var s
A.k(a)
t.g.a(b)
s=this.d.k(0,A.bH(a))
if(s!=null)B.a.ap(s,b)},
gH(){return B.B}}
A.bS.prototype={
P(a){var s=this,r={}
r.signAndSendTransaction=A.f(s.gX())
r.version="1.0.0"
a["monero:signAndSendTransaction"]=r
r={}
r.signMessage=A.f(s.gE())
r.version="1.0.0"
a["monero:signMessage"]=r
r={}
r.connect=A.f(s.gA())
r.version="1.0.0"
a["monero:connect"]=r
a["monero:events"]=A.a5(A.w(s.gK()))
a["monero:disconnect"]=A.ar(A.v(s.gJ()))},
q(a){var s=A.aa(A.B(a)),r=s==null?null:A.b([s],t.s)
return this.j("monero_requestAccounts",r,t.m)},
B(){return this.q(null)},
Y(a){var s=t.K
return this.j("monero_signAndSendTransaction",A.b([s.a(a)],t.f),s)},
F(a){return this.j("monero_signMessage",A.b([t.m.a(a)],t.O),t.K)},
gH(){return B.C}}
A.c2.prototype={
P(a){var s=this,r={}
r.signAndSendTransaction=A.f(s.gX())
r.version="1.0.0"
a["xrpl:signAndSendTransaction"]=r
r={}
r.signTransaction=A.f(s.gM())
r.version="1.0.0"
a["xrpl:signTransaction"]=r
r={}
r.signMessage=A.f(s.gE())
r.version="1.0.0"
a["xrpl:signMessage"]=r
r={}
r.connect=A.f(s.gA())
r.version="1.0.0"
a["xrpl:connect"]=r
a["xrpl:events"]=A.a5(A.w(s.gK()))
a["xrpl:disconnect"]=A.ar(A.v(s.gJ()))},
q(a){var s=A.aa(A.B(a)),r=s==null?null:A.b([s],t.s)
return this.j("xrpl_requestAccounts",r,t.m)},
B(){return this.q(null)},
N(a){var s=t.K
return this.j("xrpl_signTransaction",A.b([s.a(a)],t.f),s)},
Y(a){var s=t.K
return this.j("xrpl_signAndSendTransaction",A.b([s.a(a)],t.f),s)},
F(a){return this.j("xrpl_signMessage",A.b([t.m.a(a)],t.O),t.K)},
gH(){return B.J}}
A.c3.prototype={
P(a){var s=this,r=A.f(s.gdJ()),q=A.f(s.gdR()),p=A.f(s.gdB()),o=A.f(s.gE()),n=$.jl(),m={}
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
m.signAndSendAllTransactions=A.w(s.gdH())
m.version="1.0.0"
m.supportedTransactionVersions=n
a["solana:signAndSendAllTransactions"]=m
a["solana:events"]=A.a5(A.w(s.gK()))
m={}
m.connect=A.f(s.gA())
m.version="1.0.0"
a["solana:connect"]=m
m={}
m.signIn=A.f(s.gdL())
m.version="1.0.0"
a["solana:signIn"]=m
a["solana:disconnect"]=A.ar(A.v(s.gJ()))},
q(a){var s=A.aa(A.B(a)),r=s==null?null:A.b([s],t.s)
return this.j("solana_requestAccounts",r,t.m)},
B(){return this.q(null)},
dM(a){var s=t.m
return A.Y(this.O("solana_signIn",A.S(s.a(a)),s),s)},
F(a){var s=t.c
return A.Y(this.O("solana_signMessage",A.S(t.m.a(a)),s),s)},
dS(a){var s=t.c
return A.Y(this.O("solana_signTransaction",A.S(t.K.a(a)),s),s)},
dC(a){var s=t.c
return A.Y(this.O("solana_signAllTransactions",A.S(t.K.a(a)),s),s)},
dK(a){return this.j("solana_signAndSendTransaction",A.S(t.m.a(a)),t.c)},
bL(a,b){var s,r=t.c
r.a(a)
t.A.a(b)
s=A.S(a)
return this.j("solana_signAndSendAllTransactions",s,r)},
dI(a){return this.bL(a,null)},
gH(){return B.D}}
A.c5.prototype={
P(a){var s=this,r={}
r.signAndSendTransaction=A.f(s.gX())
r.version="1.0.0"
a["stellar:signAndSendTransaction"]=r
r={}
r.signTransaction=A.f(s.gM())
r.version="1.0.0"
a["stellar:signTransaction"]=r
r={}
r.signMessage=A.f(s.gE())
r.version="1.0.0"
a["stellar:signMessage"]=r
r={}
r.connect=A.f(s.gA())
r.version="1.0.0"
a["stellar:connect"]=r
a["stellar:events"]=A.a5(A.w(s.gK()))
a["stellar:disconnect"]=A.ar(A.v(s.gJ()))},
q(a){var s=A.aa(A.B(a)),r=s==null?null:A.b([s],t.s)
return this.j("stellar_requestAccounts",r,t.m)},
B(){return this.q(null)},
N(a){var s=t.K
return this.j("stellar_signTransaction",A.b([s.a(a)],t.f),s)},
Y(a){var s=t.K
return this.j("stellar_sendTransaction",A.b([s.a(a)],t.f),s)},
F(a){return this.j("stellar_signMessage",A.b([t.m.a(a)],t.O),t.K)},
gH(){return B.E}}
A.c7.prototype={
P(a){var s,r=this
r.d4()
s={}
s.signTransaction=A.f(r.gbg())
s.version="1.0.0"
a["polkadot:signTransaction"]=s
s={}
s.signMessage=A.f(r.gbf())
s.version="1.0.0"
a["polkadot:signMessage"]=s
s={}
s.addNewChain=A.f(r.gbD())
s.version="1.0.0"
a["polkadot:addNewChain"]=s
s={}
s.connect=A.f(r.gA())
s.version="1.0.0"
a["polkadot:connect"]=s
a["polkadot:events"]=A.a5(A.w(r.gK()))
a["polkadot:disconnect"]=A.ar(A.v(r.gJ()))},
d4(){var s,r,q,p,o=this,n=o.d
if(n==null){s={}
r={}
q={}
p={}
q.signPayload=A.f(o.gbg())
q.signRaw=A.f(o.gbf())
q.update=A.f(o.gex())
s.get=A.f(o.gd5())
s.provide=A.f(o.gbD())
r.get=A.f(o.gcI())
r.subscribe=A.f(o.gd7())
n=t.m
p.metadata=A.a7(s,n)
p.accounts=A.a7(r,n)
p.signer=A.a7(q,n)
n=o.gaZ()
p.connect=A.f(n)
p.enable=A.f(n)
p.name="OnChain"
p.version="0.4.0"
n=o.d=new A.aM(null,p,t.q)}if(o.e==null)o.e=A.fR(v.G.Proxy,[n.b,new A.eQ(o).$0()],t.m)
n=v.G
if(t.A.a(n.injectedWeb3)==null)n.injectedWeb3={}
t.m.a(n.injectedWeb3)["0"]=o.e
n.substrate=o.e},
bC(a){A.aB(a)
return this.c3("polkadot_knownMetadata",t.m)},
d6(){return this.bC(null)},
d9(a){return this.j("wallet_addPolkadotChain",A.b([t.m.a(a)],t.O),t.y)},
ce(a){var s=t.m
return this.j("polkadot_signTransaction",A.b([s.a(a)],t.O),s)},
cd(a){var s=t.m
return this.j("polkadot_signMessage",A.b([s.a(a)],t.O),s)},
q(a){var s=A.aa(A.B(a)),r=s==null?null:A.b([s],t.s)
return this.j("polkadot_requestAccounts",r,t.m)},
B(){return this.q(null)},
bq(a){var s=t.c
return A.Y(this.ez("polkadot_requestAccounts",t.m).aM(new A.eM(),s),s)},
cJ(){return this.bq(null)},
aO(a){throw A.d($.hT())},
ey(){return this.aO(null)},
cU(a){A.k(a)
return A.Y(new A.eN(this).$0(),t.A)},
d8(a){var s
t.g.a(a)
s=this.c.k(0,B.f)
s.toString
B.a.m(s,a)
this.ab(A.be(B.f))},
gH(){return B.F}}
A.eO.prototype={
$0(){return this.a.a},
$S:9}
A.eP.prototype={
$0(){return this.a.b},
$S:15}
A.eQ.prototype={
$0(){var s,r,q,p,o,n,m=this.a.d
m.toString
s=v.G
r=t.m
q=r.a(s.Object)
p=r.a(q.create.apply(q,[null]))
p.set=A.hG(m.gaR())
p.get=A.hF(m.gaQ())
q=r.a(s.Object)
o=r.a(q.create.apply(q,[null]))
o.get=A.v(new A.eO(m))
q=r.a(s.Object)
q.defineProperty.apply(q,[p,"debugKey",o])
q=r.a(s.Object)
n=r.a(q.create.apply(q,[null]))
n.get=A.v(new A.eP(m))
s=r.a(s.Object)
s.defineProperty.apply(s,[p,"object",n])
return p},
$S:7}
A.eM.prototype={
$1(a){return t.c.a(t.m.a(a).accounts)},
$S:58}
A.eN.prototype={
$0(){var s=0,r=A.ah(t.A),q,p=this
var $async$$0=A.ai(function(a,b){if(a===1)return A.ae(b,r)
while(true)switch(s){case 0:q=p.a.e
s=1
break
case 1:return A.af(q,r)}})
return A.ag($async$$0,r)},
$S:59}
A.c8.prototype={
F(a){var s=t.K
return this.j("sui_signMessage",A.b([s.a(a)],t.f),s)},
dQ(a){var s=t.K
return this.j("sui_signPersonalMessage",A.b([s.a(a)],t.f),s)},
a6(a,b,c){A.lU(c,t.K,"T","_signTransction_")
return this.dX(a,b,c,c)},
dX(a,b,c,d){var s=0,r=A.ah(d),q,p=this,o,n
var $async$a6=A.ai(function(e,f){if(e===1)return A.ae(f,r)
while(true)switch(s){case 0:o=a
n=A
s=3
return A.aC(A.eo(b),$async$a6)
case 3:q=p.O(o,n.b([f],t.f),c)
s=1
break
case 1:return A.af(q,r)}})
return A.ag($async$a6,r)},
N(a){var s=t.K
return A.Y(this.a6("sui_signTransaction",s.a(a),s),s)},
dG(a){var s=t.K
return A.Y(this.a6("sui_signAndExecuteTransaction",s.a(a),s),s)},
dE(a){var s=t.K
return A.Y(this.a6("sui_signAndExecuteTransactionBlock",s.a(a),s),s)},
dU(a){var s=t.K
return A.Y(this.a6("sui_signTransactionBlock",s.a(a),s),s)},
dv(a){t.K.a(a)
return A.k3(A.k4(B.P,t.z))},
gH(){return B.G},
q(a){var s=A.aa(A.B(a)),r=s==null?null:A.b([s],t.s)
return this.j("sui_requestAccounts",r,t.m)},
B(){return this.q(null)},
P(a){var s=this,r={}
r.signTransaction=A.f(s.gM())
r.version="1.0.0"
a["sui:signTransaction"]=r
r={}
r.connect=A.f(s.gA())
r.version="1.0.0"
a["sui:connect"]=r
r={}
r.signTransactionBlock=A.f(s.gdT())
r.version="1.0.0"
a["sui:signTransactionBlock"]=r
r={}
r.signAndExecuteTransactionBlock=A.f(s.gdD())
r.version="1.0.0"
a["sui:signAndExecuteTransactionBlock"]=r
r={}
r.signAndExecuteTransaction=A.f(s.gdF())
r.version="2.0.0"
a["sui:signAndExecuteTransaction"]=r
r={}
r.signPersonalMessage=A.f(s.gdP())
r.version="1.0.0"
a["sui:signPersonalMessage"]=r
r={}
r.signMessage=A.f(s.gE())
r.version="1.0.0"
a["sui:signMessage"]=r
r={}
r.reportTransactionEffects=A.f(s.gdu())
r.version="1.0.0"
a["sui:reportTransactionEffects"]=r
r={}
r.disconnect=A.v(s.gJ())
r.version="1.0.0"
a["sui:disconnect"]=r
a["sui:events"]=A.a5(A.w(s.gK()))}}
A.c9.prototype={
P(a){var s=this,r={}
r.signAndSendTransaction=A.f(s.gX())
r.version="1.0.0"
a["ton:signAndSendTransaction"]=r
r={}
r.signTransaction=A.f(s.gM())
r.version="1.0.0"
a["ton:signTransaction"]=r
r={}
r.signMessage=A.f(s.gE())
r.version="1.0.0"
a["ton:signMessage"]=r
r={}
r.connect=A.f(s.gA())
r.version="1.0.0"
a["ton:connect"]=r
a["ton:disconnect"]=A.ar(A.v(s.gJ()))
a["ton:events"]=A.a5(A.w(s.gK()))},
q(a){var s=A.aa(A.B(a)),r=s==null?null:A.b([s],t.s)
return this.j("ton_requestAccounts",r,t.m)},
B(){return this.q(null)},
N(a){return this.j("ton_signTransaction",A.b([t.m.a(a)],t.O),t.K)},
Y(a){return this.j("ton_sendTransaction",A.b([t.m.a(a)],t.O),t.K)},
F(a){return this.j("ton_signMessage",A.b([t.m.a(a)],t.O),t.K)},
gH(){return B.H}}
A.ca.prototype={
ai(){var s,r,q,p,o,n,m,l,k,j=this,i=v.G,h=new i.TronWeb("https://api.shasta.trongrid.io","https://api.shasta.trongrid.io","https://api.shasta.trongrid.io"),g=j.e,f=t.m,e=A.fR(i.Proxy,[g,new A.eU(new A.aM(null,g,t.q)).$0()],f)
f.a(h.trx).sign=A.w(j.gdV())
f.a(h.trx).signMessageV2=A.w(j.gdN())
f.a(h.trx).multiSign=A.w(j.gda())
g=j.gcN()
h.setPrivateKey=A.f(g)
h.setAddress=A.f(g)
h.setFullNode=A.f(g)
h.setSolidityNode=A.f(g)
h.setHeader=A.f(g)
h.setFullNodeHeader=A.f(g)
h.setDefaultBlock=A.f(g)
h.defaultPrivateKey=""
h.defaultAddress=e
g=t.K
s=A.a7(h,g)
r=A.f(j.gaD())
q=A.w(j.gcs())
p=A.v(j.gaZ())
o=A.w(j.gds())
n=A.v(j.gJ())
m={}
m.dappIcon=""
m.dappName=""
m.openTronLinkAppOnMobile=!0
m.openUrlWhenWalletNotFound=!0
l={}
l.config=m
l.request=r
l.on=q
l.removeListener=o
l.tronWeb=s
l.enable=p
l.connect=p
l.ready=!0
l.disconnect=n
k=f.a(i.Object.freeze(l))
i.tronLink=A.a7(k,f)
i.tronWeb=A.a7(h,g)
i.tron=A.a7(k,f)
j.c=k
j.d=h},
cO(a){throw A.d($.hT())},
bM(a,b){t.K.a(a)
if(b!=null)A.hC(b)
return this.a2("tron_signMessageV2",A.b([a],t.f),B.j,t.N)},
dO(a){return this.bM(a,null)},
bN(a,b){t.K.a(a)
if(b!=null)A.hC(b)
return this.a2("tron_signTransaction",A.b([a],t.f),B.j,t.m)},
dW(a){return this.bN(a,null)},
bF(a,b){t.K.a(a)
if(b!=null)A.hC(b)
return this.a2("tron_signTransaction",A.b([a],t.f),B.j,t.X)},
dc(a){return this.bF(a,null)},
ah(a,b){var s,r,q
if(b==null||!this.f.ac(a))return
s=this.f.k(0,a)
s.toString
s=A.a6(s,t.g)
for(r=s.length,q=0;q<s.length;s.length===r||(0,A.an)(s),++q)s[q].call(null,b)},
ct(a,b){var s,r
A.k(a)
t.g.a(b)
s=A.bH(a)
if(s==null)return
r=this.f.k(0,s)
if(r!=null)B.a.m(r,b)
this.ab(A.be(s))},
dt(a,b){var s
A.k(a)
t.g.a(b)
s=this.f.k(0,A.bH(a))
if(s!=null)B.a.ap(s,b)},
cT(){return this.c4("tron_requestAccounts",B.j,t.c)},
b6(a){t.m.a(a)
return this.a2(A.k(a.method),A.S(a.params),B.j,t.X)},
gH(){return B.I},
ao(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null
b.aU(a0)
s=t.m
r=s.a(a0.data)
q=A.et(r)
for(p=q.length,o=t.A,n=v.G,m=t.N,l=t.X,k=t.z,j=b.e,i=0;i<q.length;q.length===p||(0,A.an)(q),++i)switch(q[i]){case B.t:h=o.a(r.account)
g=b.c
f=g==null
e=f?a:A.B(g.selectedAddress)
d=h==null
if(e!=(d?a:A.k(h.address))){if(!f){f=d?a:A.k(h.address)
g.selectedAddress=f}g=d?a:A.k(h.address)
if(g==null)g=!1
j.base58=g
g=d?a:A.k(h.hex)
if(g==null)g=!1
j.hex=g
s.a(n.window).postMessage(A.h_(A.z(["message",A.z(["action","accountsChanged","data",h],m,l),"source","contentScript"],m,k)))}break
case B.L:b.ah(B.c,r.message)
break
case B.K:g=o.a(r.networkAccounts)
b.ah(B.f,g==null?a:A.id(g))
break
case B.r:c=o.a(r.chainChanged)
g=b.c
if(g!=null){f=c==null?a:A.k(c.chainId)
g.chainId=f}g=b.c
if(g!=null){f=c==null?a:A.k(c.netVersion)
g.networkVersion=f}if(r.disconnect!=null)b.ah(B.m,r.disconnect)
if(c!=null){if(r.disconnect==null){b.ah(B.k,c)
s.a(n.window).postMessage(A.h_(A.z(["message",A.z(["action","connect","data",null],m,l),"source","contentScript"],m,k)))}g=A.k(c.fullNode)
f=b.d
if(f!=null)f.fullNode=new n.TronWeb.providers.HttpProvider(g)
f=b.d
if(f!=null)f.solidityNode=new n.TronWeb.providers.HttpProvider(g)
f=b.d
if(f!=null)f.setEventServer(new n.TronWeb.providers.HttpProvider(g))
b.ah(B.i,A.k(c.chainId))
s.a(n.window).postMessage(A.h_(A.z(["message",A.z(["action","setNode","data",A.z(["node",c],m,o)],m,l),"source","contentScript"],m,k)))}break}},
q(a){var s=A.aa(A.B(a)),r=s==null?null:A.b([s],t.s)
return this.j("tron_requestAccounts",r,t.m)},
B(){return this.q(null)},
F(a){var s=t.m
return this.j("tron_signMessageV2",A.b([s.a(a)],t.O),s)},
N(a){var s=t.m
return this.j("tron_signTransaction",A.b([s.a(a)],t.O),s)},
P(a){var s,r,q=this
q.ai()
s={}
s.connect=A.f(q.gA())
s.version="1.0.0"
a["tron:connect"]=s
s={}
s.signMessage=A.f(q.gE())
s.version="1.0.0"
a["tron:signMessage"]=s
r=q.gM()
a["tron:signTransaction"]=A.iu(A.f(r))
a["tron:signTransaction"]=A.iu(A.f(r))
a["tron:disconnect"]=A.ar(A.v(q.gJ()))
a["tron:events"]=A.a5(A.w(q.gK()))}}
A.eS.prototype={
$0(){return this.a.a},
$S:9}
A.eT.prototype={
$0(){return this.a.b},
$S:15}
A.eU.prototype={
$0(){var s,r,q=this.a,p=v.G,o=t.m,n=o.a(p.Object),m=o.a(n.create.apply(n,[null]))
m.set=A.hG(q.gaR())
m.get=A.hF(q.gaQ())
n=o.a(p.Object)
s=o.a(n.create.apply(n,[null]))
s.get=A.v(new A.eS(q))
n=o.a(p.Object)
n.defineProperty.apply(n,[m,"debugKey",s])
n=o.a(p.Object)
r=o.a(n.create.apply(n,[null]))
r.get=A.v(new A.eT(q))
p=o.a(p.Object)
p.defineProperty.apply(p,[m,"object",r])
return m},
$S:7}
A.eu.prototype={
$1(a){return A.k(a)},
$S:27}
A.ev.prototype={
$1(a){return A.kc(A.k(a))},
$S:62}
A.eq.prototype={
$1(a){return A.k(t.m.a(a).address)},
$S:45};(function aliases(){var s=J.aK.prototype
s.cg=s.i
s=A.J.prototype
s.aU=s.ao})();(function installTearOffs(){var s=hunkHelpers._static_1,r=hunkHelpers._static_0,q=hunkHelpers.installInstanceTearOff,p=hunkHelpers._instance_1u,o=hunkHelpers._instance_2u,n=hunkHelpers._instance_0u
s(A,"lR","kI",16)
s(A,"lS","kJ",16)
s(A,"lT","kK",16)
r(A,"j7","lM",2)
var m
q(m=A.aM.prototype,"gaR",0,4,null,["$4"],["c8"],51,0,0)
q(m,"gaQ",0,3,null,["$3"],["c7"],52,0,0)
p(m=A.cX.prototype,"gc_","aL",8)
p(m,"gdj","dk",8)
o(m=A.bL.prototype,"gK","b5",41)
q(m,"gA",0,0,null,["$1","$0"],["q","B"],54,0,0)
n(m=A.J.prototype,"gJ","cP",5)
o(m,"gK","b5",6)
p(m=A.bt.prototype,"gcD","cE",0)
p(m,"gE","F",0)
p(m,"gM","N",0)
q(m,"gdw",0,0,null,["$1","$0"],["bJ","dz"],3,0,0)
n(m,"gdd","de",5)
p(m,"gdf","dg",17)
p(m,"gdh","di",17)
q(m=A.bw.prototype,"gA",0,0,null,["$1","$0"],["q","B"],3,0,0)
p(m,"gcz","cA",0)
p(m,"gcB","cC",0)
p(m,"gd_","d0",0)
p(m,"gcv","cw",50)
q(m=A.bA.prototype,"gea",0,0,null,["$1","$0"],["bY","eb"],3,0,0)
p(m,"gE","F",0)
p(m,"gcb","cc",0)
p(m,"gc9","ca",0)
q(m,"gbv",0,1,null,["$2","$1"],["bx","bw"],19,0,0)
q(m,"gbz",0,1,null,["$2","$1"],["bB","bA"],19,0,0)
q(m,"ge3",0,1,null,["$2","$1"],["bO","e4"],19,0,0)
p(m,"gby","d1",29)
p(m,"gaV","aW",0)
p(m,"gM","N",0)
p(m=A.bD.prototype,"gaD","b6",1)
n(m,"gcG","cH",5)
q(m,"gA",0,0,null,["$1","$0"],["q","B"],3,0,0)
p(m,"gaV","aW",1)
p(m,"gdY","dZ",1)
p(m,"ge_","e0",1)
p(m,"ge1","e2",1)
p(m,"gdl","dm",1)
p(m,"gcW","cX",1)
p(m,"gX","Y",1)
o(m,"gcq","cr",6)
o(m,"gdn","dq",6)
q(m=A.bS.prototype,"gA",0,0,null,["$1","$0"],["q","B"],3,0,0)
p(m,"gX","Y",0)
p(m,"gE","F",1)
q(m=A.c2.prototype,"gA",0,0,null,["$1","$0"],["q","B"],3,0,0)
p(m,"gM","N",0)
p(m,"gX","Y",0)
p(m,"gE","F",1)
q(m=A.c3.prototype,"gA",0,0,null,["$1","$0"],["q","B"],3,0,0)
p(m,"gdL","dM",1)
p(m,"gE","F",1)
p(m,"gdR","dS",0)
p(m,"gdB","dC",0)
p(m,"gdJ","dK",1)
q(m,"gdH",0,1,null,["$2","$1"],["bL","dI"],55,0,0)
q(m=A.c5.prototype,"gA",0,0,null,["$1","$0"],["q","B"],3,0,0)
p(m,"gM","N",0)
p(m,"gX","Y",0)
p(m,"gE","F",1)
q(m=A.c7.prototype,"gd5",0,0,null,["$1","$0"],["bC","d6"],56,0,0)
p(m,"gbD","d9",1)
p(m,"gbg","ce",1)
p(m,"gbf","cd",1)
q(m,"gA",0,0,null,["$1","$0"],["q","B"],3,0,0)
q(m,"gcI",0,0,null,["$1","$0"],["bq","cJ"],31,0,0)
q(m,"gex",0,0,null,["$1","$0"],["aO","ey"],31,0,0)
p(m,"gaZ","cU",29)
p(m,"gd7","d8",17)
p(m=A.c8.prototype,"gE","F",0)
p(m,"gdP","dQ",0)
p(m,"gM","N",0)
p(m,"gdF","dG",0)
p(m,"gdD","dE",0)
p(m,"gdT","dU",0)
p(m,"gdu","dv",0)
q(m,"gA",0,0,null,["$1","$0"],["q","B"],3,0,0)
q(m=A.c9.prototype,"gA",0,0,null,["$1","$0"],["q","B"],3,0,0)
p(m,"gM","N",1)
p(m,"gX","Y",1)
p(m,"gE","F",1)
p(m=A.ca.prototype,"gcN","cO",60)
q(m,"gdN",0,1,null,["$2","$1"],["bM","dO"],10,0,0)
q(m,"gdV",0,1,null,["$2","$1"],["bN","dW"],10,0,0)
q(m,"gda",0,1,null,["$2","$1"],["bF","dc"],10,0,0)
o(m,"gcs","ct",6)
o(m,"gds","dt",6)
n(m,"gaZ","cT",5)
p(m,"gaD","b6",1)
q(m,"gA",0,0,null,["$1","$0"],["q","B"],3,0,0)
p(m,"gE","F",1)
p(m,"gM","N",1)})();(function inheritance(){var s=hunkHelpers.mixin,r=hunkHelpers.inherit,q=hunkHelpers.inheritMany
r(A.e,null)
q(A.e,[A.hj,J.cV,J.bu,A.i,A.bx,A.y,A.eL,A.aV,A.bR,A.cf,A.bC,A.Q,A.bz,A.eV,A.eC,A.bE,A.cs,A.aG,A.aL,A.ey,A.bP,A.bO,A.cr,A.cY,A.fh,A.dv,A.ac,A.dq,A.du,A.fA,A.cg,A.a3,A.bk,A.aA,A.q,A.dl,A.ds,A.cy,A.cm,A.p,A.by,A.cO,A.fI,A.fF,A.E,A.cP,A.cR,A.fj,A.d8,A.c4,A.fk,A.dW,A.cU,A.T,A.I,A.dt,A.bi,A.eB,A.fx,A.dR,A.dI,A.fb,A.fd,A.eJ,A.fw,A.dS,A.eR,A.dw,A.aM,A.d9,A.eb,A.bL,A.J,A.da])
q(J.cV,[J.bG,J.bJ,J.A,J.bb,J.bc,J.bK,J.ba])
q(J.A,[J.aK,J.o,A.bT,A.bX])
q(J.aK,[J.dc,J.cb,J.D])
r(J.ep,J.o)
q(J.bK,[J.bI,J.cW])
q(A.i,[A.bj,A.l,A.av,A.ce])
r(A.cz,A.bj)
r(A.cj,A.cz)
r(A.aq,A.cj)
q(A.y,[A.bN,A.ax,A.cZ,A.di,A.de,A.dp,A.cH,A.a8,A.cc,A.dh,A.bh,A.cN])
q(A.l,[A.F,A.aS,A.aU,A.at,A.cl])
q(A.F,[A.c6,A.U,A.c1])
r(A.bB,A.av)
r(A.bF,A.bz)
r(A.bZ,A.ax)
q(A.aG,[A.cK,A.cL,A.dg,A.fW,A.fY,A.f8,A.f7,A.fK,A.fu,A.fg,A.dX,A.h0,A.h3,A.h4,A.fS,A.dJ,A.dK,A.eX,A.eY,A.e8,A.e4,A.e9,A.dQ,A.f3,A.f5,A.eF,A.h1,A.er,A.ei,A.eg,A.ef,A.ew,A.ed,A.el,A.em,A.dB,A.dC,A.dA,A.eM,A.eu,A.ev,A.eq])
q(A.dg,[A.df,A.b9])
q(A.aL,[A.as,A.ck])
r(A.bM,A.as)
q(A.cL,[A.fX,A.fL,A.fQ,A.fv,A.ez,A.ff,A.dZ,A.dY,A.f6,A.f4,A.dO,A.dM])
q(A.bX,[A.bU,A.bd])
q(A.bd,[A.cn,A.cp])
r(A.co,A.cn)
r(A.bV,A.co)
r(A.cq,A.cp)
r(A.bW,A.cq)
q(A.bV,[A.d1,A.d2])
q(A.bW,[A.d3,A.d4,A.d5,A.d6,A.d7,A.bY,A.aW])
r(A.bm,A.dp)
q(A.cK,[A.f9,A.fa,A.fB,A.e_,A.fl,A.fq,A.fp,A.fn,A.fm,A.ft,A.fs,A.fr,A.fP,A.fz,A.fH,A.fG,A.fc,A.e7,A.e6,A.e3,A.e5,A.ea,A.eG,A.eH,A.eI,A.es,A.ej,A.eh,A.ex,A.ee,A.ec,A.en,A.ek,A.dN,A.dL,A.eO,A.eP,A.eQ,A.eN,A.eS,A.eT,A.eU])
q(A.bk,[A.az,A.ct])
r(A.dr,A.cy)
r(A.bl,A.ck)
r(A.cS,A.by)
r(A.cG,A.cS)
q(A.cO,[A.fD,A.fC,A.f2,A.dk])
r(A.dF,A.fD)
r(A.dE,A.fC)
q(A.a8,[A.bg,A.cT])
q(A.fj,[A.bv,A.aw,A.d0,A.aH,A.aI,A.R,A.a4,A.aJ,A.H,A.db])
q(A.dI,[A.dH,A.dG,A.dP,A.b8,A.eA])
r(A.cd,A.dw)
r(A.cX,A.eb)
q(A.J,[A.bt,A.bw,A.bA,A.bD,A.bS,A.c2,A.c3,A.c5,A.c7,A.c8,A.c9,A.ca])
s(A.cz,A.p)
s(A.cn,A.p)
s(A.co,A.Q)
s(A.cp,A.p)
s(A.cq,A.Q)
s(A.dw,A.dS)})()
var v={G:typeof self!="undefined"?self:globalThis,typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{c:"int",r:"double",b7:"num",j:"String",C:"bool",I:"Null",m:"List",e:"Object",au:"Map"},mangledNames:{},types:["h(e)","h(h)","~()","h([j?])","0&()","h()","~(j,D)","e()","~(h)","j?()","h(e[e?])","e?(e?)","~(@)","j()","I(e)","e?()","~(~())","~(D)","e(e)","h(j[e?])","@()","c(c)","I(D,D)","@(@)","I(@)","I()","I(e,al)","j(j)","C(a4)","h(j)","h(j,e)","h([e?])","I(~())","e?(~)","~(e?,e?)","C(aI)","C(R)","m<c>()","C(aJ)","C(H)","M<~>()","D?(j,D)","c(c,c)","M<h>()","@(@,j)","j(h)","I(@,al)","~(c,@)","C(aH)","@(j)","h(o<e?>)","C(e,e?,e?,e?)","e?(e,e?,e?)","j(T<j,@>)","h([h?])","h(o<e?>[h?])","h([C?])","e(e,al)","o<e?>(h)","M<h?>()","~(e?)","j(c)","R(j)","C(T<j,@>)","j(e)"],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti"),rttc:{}}
A.l2(v.typeUniverse,JSON.parse('{"D":"aK","dc":"aK","cb":"aK","o":{"m":["1"],"A":[],"l":["1"],"h":[],"i":["1"]},"bG":{"C":[],"t":[]},"bJ":{"t":[]},"A":{"h":[]},"aK":{"A":[],"h":[]},"ep":{"o":["1"],"m":["1"],"A":[],"l":["1"],"h":[],"i":["1"]},"bu":{"N":["1"]},"bK":{"r":[],"b7":[]},"bI":{"r":[],"c":[],"b7":[],"t":[]},"cW":{"r":[],"b7":[],"t":[]},"ba":{"j":[],"eD":[],"t":[]},"bj":{"i":["2"]},"bx":{"N":["2"]},"cj":{"p":["2"],"m":["2"],"bj":["1","2"],"l":["2"],"i":["2"]},"aq":{"cj":["1","2"],"p":["2"],"m":["2"],"bj":["1","2"],"l":["2"],"i":["2"],"p.E":"2","i.E":"2"},"bN":{"y":[]},"l":{"i":["1"]},"F":{"l":["1"],"i":["1"]},"c6":{"F":["1"],"l":["1"],"i":["1"],"F.E":"1","i.E":"1"},"aV":{"N":["1"]},"av":{"i":["2"],"i.E":"2"},"bB":{"av":["1","2"],"l":["2"],"i":["2"],"i.E":"2"},"bR":{"N":["2"]},"U":{"F":["2"],"l":["2"],"i":["2"],"F.E":"2","i.E":"2"},"ce":{"i":["1"],"i.E":"1"},"cf":{"N":["1"]},"aS":{"l":["1"],"i":["1"],"i.E":"1"},"bC":{"N":["1"]},"c1":{"F":["1"],"l":["1"],"i":["1"],"F.E":"1","i.E":"1"},"bz":{"au":["1","2"]},"bF":{"bz":["1","2"],"au":["1","2"]},"bZ":{"ax":[],"y":[]},"cZ":{"y":[]},"di":{"y":[]},"cs":{"al":[]},"aG":{"aT":[]},"cK":{"aT":[]},"cL":{"aT":[]},"dg":{"aT":[]},"df":{"aT":[]},"b9":{"aT":[]},"de":{"y":[]},"as":{"aL":["1","2"],"hl":["1","2"],"au":["1","2"]},"aU":{"l":["1"],"i":["1"],"i.E":"1"},"bP":{"N":["1"]},"at":{"l":["T<1,2>"],"i":["T<1,2>"],"i.E":"T<1,2>"},"bO":{"N":["T<1,2>"]},"bM":{"as":["1","2"],"aL":["1","2"],"hl":["1","2"],"au":["1","2"]},"cY":{"eD":[]},"bT":{"A":[],"h":[],"cJ":[],"t":[]},"bX":{"A":[],"h":[]},"dv":{"cJ":[]},"bU":{"A":[],"hb":[],"h":[],"t":[]},"bd":{"a0":["1"],"A":[],"h":[]},"bV":{"p":["r"],"m":["r"],"a0":["r"],"A":[],"l":["r"],"h":[],"i":["r"],"Q":["r"]},"bW":{"p":["c"],"m":["c"],"a0":["c"],"A":[],"l":["c"],"h":[],"i":["c"],"Q":["c"]},"d1":{"dU":[],"p":["r"],"m":["r"],"a0":["r"],"A":[],"l":["r"],"h":[],"i":["r"],"Q":["r"],"t":[],"p.E":"r"},"d2":{"dV":[],"p":["r"],"m":["r"],"a0":["r"],"A":[],"l":["r"],"h":[],"i":["r"],"Q":["r"],"t":[],"p.E":"r"},"d3":{"e0":[],"p":["c"],"m":["c"],"a0":["c"],"A":[],"l":["c"],"h":[],"i":["c"],"Q":["c"],"t":[],"p.E":"c"},"d4":{"e1":[],"p":["c"],"m":["c"],"a0":["c"],"A":[],"l":["c"],"h":[],"i":["c"],"Q":["c"],"t":[],"p.E":"c"},"d5":{"e2":[],"p":["c"],"m":["c"],"a0":["c"],"A":[],"l":["c"],"h":[],"i":["c"],"Q":["c"],"t":[],"p.E":"c"},"d6":{"eZ":[],"p":["c"],"m":["c"],"a0":["c"],"A":[],"l":["c"],"h":[],"i":["c"],"Q":["c"],"t":[],"p.E":"c"},"d7":{"f_":[],"p":["c"],"m":["c"],"a0":["c"],"A":[],"l":["c"],"h":[],"i":["c"],"Q":["c"],"t":[],"p.E":"c"},"bY":{"f0":[],"p":["c"],"m":["c"],"a0":["c"],"A":[],"l":["c"],"h":[],"i":["c"],"Q":["c"],"t":[],"p.E":"c"},"aW":{"f1":[],"p":["c"],"m":["c"],"a0":["c"],"A":[],"l":["c"],"h":[],"i":["c"],"Q":["c"],"t":[],"p.E":"c"},"dp":{"y":[]},"bm":{"ax":[],"y":[]},"cg":{"cM":["1"]},"a3":{"y":[]},"bk":{"cM":["1"]},"az":{"bk":["1"],"cM":["1"]},"ct":{"bk":["1"],"cM":["1"]},"q":{"M":["1"]},"cy":{"iw":[]},"dr":{"cy":[],"iw":[]},"ck":{"aL":["1","2"],"au":["1","2"]},"bl":{"ck":["1","2"],"aL":["1","2"],"au":["1","2"]},"cl":{"l":["1"],"i":["1"],"i.E":"1"},"cm":{"N":["1"]},"aL":{"au":["1","2"]},"cG":{"by":["j","m<c>"]},"cS":{"by":["j","m<c>"]},"r":{"b7":[]},"c":{"b7":[]},"m":{"l":["1"],"i":["1"]},"j":{"eD":[]},"cH":{"y":[]},"ax":{"y":[]},"a8":{"y":[]},"bg":{"y":[]},"cT":{"y":[]},"cc":{"y":[]},"dh":{"y":[]},"bh":{"y":[]},"cN":{"y":[]},"d8":{"y":[]},"c4":{"y":[]},"cU":{"y":[]},"dt":{"al":[]},"e2":{"m":["c"],"l":["c"],"i":["c"]},"f1":{"m":["c"],"l":["c"],"i":["c"]},"f0":{"m":["c"],"l":["c"],"i":["c"]},"e0":{"m":["c"],"l":["c"],"i":["c"]},"eZ":{"m":["c"],"l":["c"],"i":["c"]},"e1":{"m":["c"],"l":["c"],"i":["c"]},"f_":{"m":["c"],"l":["c"],"i":["c"]},"dU":{"m":["r"],"l":["r"],"i":["r"]},"dV":{"m":["r"],"l":["r"],"i":["r"]},"bt":{"J":[]},"bw":{"J":[]},"bA":{"J":[]},"bD":{"J":[]},"bS":{"J":[]},"c2":{"J":[]},"c3":{"J":[]},"c5":{"J":[]},"c7":{"J":[]},"c8":{"J":[]},"c9":{"J":[]},"ca":{"J":[]}}'))
A.l1(v.typeUniverse,JSON.parse('{"cz":2,"bd":1,"cO":2}'))
var u={n:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",c:"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type",f:"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAhGVYSWZNTQAqAAAACAAFARIAAwAAAAEAAQAAARoABQAAAAEAAABKARsABQAAAAEAAABSASgAAwAAAAEAAgAAh2kABAAAAAEAAABaAAAAAAAAAEgAAAABAAAASAAAAAEAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAIKADAAQAAAABAAAAIAAAAABfvA/wAAAACXBIWXMAAAsTAAALEwEAmpwYAAACyGlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNi4wLjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyIKICAgICAgICAgICAgeG1sbnM6ZXhpZj0iaHR0cDovL25zLmFkb2JlLmNvbS9leGlmLzEuMC8iPgogICAgICAgICA8dGlmZjpZUmVzb2x1dGlvbj43MjwvdGlmZjpZUmVzb2x1dGlvbj4KICAgICAgICAgPHRpZmY6UmVzb2x1dGlvblVuaXQ+MjwvdGlmZjpSZXNvbHV0aW9uVW5pdD4KICAgICAgICAgPHRpZmY6WFJlc29sdXRpb24+NzI8L3RpZmY6WFJlc29sdXRpb24+CiAgICAgICAgIDx0aWZmOk9yaWVudGF0aW9uPjE8L3RpZmY6T3JpZW50YXRpb24+CiAgICAgICAgIDxleGlmOlBpeGVsWERpbWVuc2lvbj41MDwvZXhpZjpQaXhlbFhEaW1lbnNpb24+CiAgICAgICAgIDxleGlmOkNvbG9yU3BhY2U+MTwvZXhpZjpDb2xvclNwYWNlPgogICAgICAgICA8ZXhpZjpQaXhlbFlEaW1lbnNpb24+NTA8L2V4aWY6UGl4ZWxZRGltZW5zaW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KZxgR6QAAB6lJREFUWAnlVmlsXFcZPfe9ecvsYzt2SihSk1SQBUWCqKUJSEkQyw+qSqXEKhKFssROLSTU0MQJAtUI0WYtKkJpYtqoqBJLDAXyB4kSakUlZSkCEtwQoRYqJXU2e+zxvHnztns5903sOBlH6o9KCHGleXPX7zvfud9ygf/3Jm5CgIDiil6d/W/1brJ9wem3Q8aCgudPaog3M2L+vpv22w8rJbB7oAJlGAhtBTsUCFWARw96VKUwNGQAowYeHU3SsRat2BvZbODV1XpdckZgaCAPWzhzMoSU2HlwCkJoTufafAC6TwEPVuDaJyDUOyHRgGE6sIwAnrcR3/jBa3Mn9z2Qzwb5ih6XnMLUxe37vbm1x7+wDLYzili5kEkAAzkocR7K3IBdT1W5r6WLnczcodmOk+VisgSm2QkTnem0lIOp8r4+C8vFRii5AgngZ2So1wM1bWf3PkQ9yVmvjBfRP/w6DvR/F4bYRzktyTEPKI/sXd/aAWCaG3MNwOyiokkk8b3Y+cwJ7N6ynuOPIjFPIxONdKNUtExVqFgWlIrrZ86Nz6CQXWcju8vcu/W4/9VD+7G77/fIGD+nwYu4qQHXuo5+DaUNUYrPJO3a/RPMKt9CCtchmD6QyVpTrlF80i26v+ypVH5V4e8dXYuPfWLN+568f9XaWnj6Fwf8RN7p7u3vw87hlxDLe6mcmgwHzUhTn4pO//lpBxAUAphGk0uD2Hn4BB7bsoW+0ISTPyhyHc/GGfN4T6nQ223ZK0UcL+4yrMXvLvesqJRLvaZj/ubT9ww+N/TetYebSeTNgTCM7bBMH5aiXLYWjBu76bj1GaITDR15Hfv619GR1iPAU8gbLxuuvUb6UXRnpVvcVu4ywjgQPbkibNNQkYxlV66opo3Eqk3X/r7cdj8wdPqVrdmM+Qd/x6HfYVbmPDW6e9VDbpgd/UuV4ZSBWXsQgfU95NWzcJ1Nqu43y5btCEijk3+3FMuiaLlCCIjufMlwbNv0/EbTzueWnPfqK0+/9MzXjZ73fCZZtvYkDjw9cYOWdNh+BWmccy07voEXNIZifAds61Oo+xFj2E3jh3dqCh7l1dJyFJ0s8vzpccYw3LjeiEzH+uT99+y4KwzD03kdObrNyk4HrU87gFVjVx1FrkIkTiJSfVowf0LTVZMJOqnMtR36l8Qlr4bxmUl4QRN2JoOsaSOKY6YdiZlm0IfEO0mGVrTUjbbpa7+Co2NAuZZl+L0fInmD1n8FUvYYUmkcwjZMLCt1IWfZCKIA9cAnC0x+ZMU2LW5VqPp1eGEomioxGD3PX46S23s+vmrM+9qxEN9sQZn9tiFKU6XvVchxyKsuMJl0IpEMBCUUre+2s5zOoBGFDBYLHXRCl4oNXkkjJKCwiZkwEF4QoCFlpysyBYk4nJFWmd6vuZwXAwtlwllokjVBN202f0Uzg9hQyLkuM5/Em14dJgEtrXSjSFAhWfB9D5ONGVQ1K2SkQfO8KGJEU4LOBQu0dgZ0McrmWTSk5Vhihrl8suQ4eFdHj7qtczHLgonppod/1qp4g1T/7cp5XKLSehzhvJ6bmUI9itS0jDAdBpMXkrDOYHMaRjSt/ahl0jUk7QBGeg1s+46vGQ8iFqNInqrT8su1qozjmDfEmKOkDEU1mN/HSfUEHbBGSyXB1QhkIgzkJFm60vBPBQhoBH1k+3NeWjGv6U577QB0SU2bOMMw/BAy5jD9Cpf8umrS6bR3K9J5a2URlhQruCVfhk9QV+gT434D50n/lShQlzmuy2gYifVB3uE/UpFzslsa9LcdQKueA0snR3lwJWT4ZxWGP3E6ylYpV2henKmiQYuTpPUcsDMm7z9OPf/s1GWm+7DpOaaVNPyfwpv4I+laDf/WF1OVs7Kv6V8AgF781ueWo3eEGtSvyetWjFc/Hzb8v/47nHEbcRyVcsV4oj4tz05cUOeql9WFqQn5WvVSzKQUiULOhd88BWvys3A6+hkqLzABxanMeYpnu/PzQMvrH3kgj47CK/jYHQ52HP4xPrJ2BfLualyobgtt83bpWGtCFRuTUUBnEKIpE+FDCuU6hiAdvKcRZCbvRljezPiJMTh8DPsHdjCfHML6pcMYfVW/IVq62Gm/gq6CzSRkM/4ex7f7NmHX94+k+3rKX16EeIv0401TtdoPlRBjTH3jwrHGRSYzhiD4kWqGH4YKv4ioY4BPOhu7hp9mNd0AyD2IKTPIssyzXfUy3V34QSJzLMkkxzJ+RhD3UdAR7PnSXVeU+TCFncllzUca9YTPrKSkXIZIIuuQpoeMpMNxjxAvYPDwy9hL5Yb5fGqw5Luy++qDZM7+BQGUuZ/CNUxDdMAxf4snBnZh28HdOLr5T/hX58ZGqO6DTfaUGSBh3lAsABkmS5hn0Dj7GIZGYxx4aJAidmsrW9lM5NDkA/eG1s6AYN6FOsdKo7NXgynZoVUDdKIR9KaP0uOUcRxPPJyFTtn6OnXi0rljtunaDwwwZi+SnYCM5LjtTYg8ZV/f2hBRqcCe/hKtMuD6Ck0+UgO+bIeG+U5k0yVVV8zNRyUFt25Tn9EJ7NqznPv6cmTPmZOhDRs8XJs7cz2O/96onYEWloXm5/nuWwL8dsh4S4r+tzf9Bwpfgk0+0buPAAAAAElFTkSuQmCC"}
var t=(function rtii(){var s=A.aE
return{n:s("a3"),B:s("cJ"),Y:s("hb"),V:s("l<@>"),C:s("y"),E:s("dU"),d:s("dV"),Z:s("aT"),dQ:s("e0"),k:s("e1"),gj:s("e2"),R:s("i<@>"),c_:s("aH"),O:s("o<h>"),I:s("o<D>"),ao:s("o<T<j,@>>"),f:s("o<e>"),s:s("o<j>"),b:s("o<@>"),t:s("o<c>"),c:s("o<e?>"),D:s("H"),G:s("a4"),bs:s("R"),T:s("bJ"),m:s("h"),fr:s("aI"),e5:s("aJ"),g:s("D"),aU:s("a0<@>"),e:s("A"),cl:s("m<h>"),u:s("m<D>"),ew:s("m<e>"),a:s("m<j>"),j:s("m<@>"),L:s("m<c>"),fs:s("d0"),w:s("T<j,@>"),eO:s("au<@,@>"),bm:s("aW"),P:s("I"),K:s("e"),p:s("d9"),q:s("aM<e>"),gT:s("mi"),bQ:s("+()"),bJ:s("c1<j>"),l:s("al"),N:s("j"),dm:s("t"),eK:s("ax"),h7:s("eZ"),bv:s("f_"),go:s("f0"),gc:s("f1"),ak:s("cb"),aQ:s("J"),x:s("az<h>"),h:s("az<~>"),ev:s("E"),et:s("q<h>"),_:s("q<@>"),U:s("q<~>"),J:s("bl<e?,e?>"),aj:s("ct<~>"),y:s("C"),al:s("C(e)"),i:s("r"),z:s("@"),fO:s("@()"),v:s("@(e)"),Q:s("@(e,al)"),S:s("c"),eH:s("M<I>?"),W:s("M<@>?"),r:s("o<e?>?"),A:s("h?"),X:s("e?"),dk:s("j?"),F:s("aA<@,@>?"),fQ:s("C?"),cD:s("r?"),h6:s("c?"),cg:s("b7?"),o:s("b7"),H:s("~"),M:s("~()")}})();(function constants(){var s=hunkHelpers.makeConstList
B.an=J.cV.prototype
B.a=J.o.prototype
B.T=J.bG.prototype
B.b=J.bI.prototype
B.aq=J.bK.prototype
B.e=J.ba.prototype
B.as=J.D.prototype
B.at=J.A.prototype
B.aB=A.bU.prototype
B.aC=A.aW.prototype
B.a0=J.dc.prototype
B.O=J.cb.prototype
B.a6=new A.b8("invalid hex bytes",null)
B.a7=new A.b8("Hex input string must be divisible by two",null)
B.a8=new A.b8("Incorrect characters for hex decoding",null)
B.a9=new A.dE(!1)
B.w=new A.bv("bitcoin")
B.ab=new A.cG()
B.ac=new A.dF()
B.P=new A.cR()
B.ad=new A.bC(A.aE("bC<0&>"))
B.aR=new A.dR()
B.x=new A.cU()
B.Q=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.ae=function() {
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
B.aj=function(getTagFallback) {
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
B.af=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.ai=function(hooks) {
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
B.ah=function(hooks) {
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
B.ag=function(hooks) {
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
B.R=function(hooks) { return hooks; }

B.ak=new A.d8()
B.o=new A.eL()
B.al=new A.f2()
B.S=new A.fw()
B.h=new A.dr()
B.p=new A.dt()
B.am=new A.dP("SHA256: can't update because hash was finished.",null)
B.q=new A.aH("Rejected","rejected")
B.y=new A.H("Aptos","aptos")
B.z=new A.H("Bitcoin","bitcoin")
B.A=new A.H("Cosmos","cosmos")
B.B=new A.H("Ethereum","ethereum")
B.C=new A.H("Monero","monero")
B.D=new A.H("Solana","solana")
B.E=new A.H("Stellar","stellar")
B.F=new A.H("Substrate","substrate")
B.G=new A.H("Sui","sui")
B.H=new A.H("TON","ton")
B.I=new A.H("Tron","tron")
B.J=new A.H("XRPL","xrpl")
B.f=new A.a4("accountsChanged")
B.i=new A.a4("chainChanged")
B.c=new A.a4("message")
B.k=new A.a4("connect")
B.m=new A.a4("disconnect")
B.d=new A.a4("change")
B.K=new A.R("networkAccountsChanged")
B.U=new A.R("change")
B.r=new A.R("defaultChainChanged")
B.t=new A.R("defaultAccountChanged")
B.L=new A.R("message")
B.V=new A.aI("response")
B.W=new A.aJ("success")
B.M=new A.aJ("failed")
B.u=A.b(s(["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"]),t.s)
B.X=A.b(s([256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,0,1,2,3,4,5,6,7,8,9,256,256,256,256,256,256,256,10,11,12,13,14,15,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,10,11,12,13,14,15,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256]),t.t)
B.Y=A.b(s([B.f,B.i,B.c,B.k,B.m,B.d]),A.aE("o<a4>"))
B.ap=new A.H("","global")
B.au=A.b(s([B.ap,B.B,B.I,B.D,B.H,B.E,B.J,B.F,B.y,B.G,B.z,B.A,B.C]),A.aE("o<H>"))
B.av=A.b(s([1116352408,1899447441,3049323471,3921009573,961987163,1508970993,2453635748,2870763221,3624381080,310598401,607225278,1426881987,1925078388,2162078206,2614888103,3248222580,3835390401,4022224774,264347078,604807628,770255983,1249150122,1555081692,1996064986,2554220882,2821834349,2952996808,3210313671,3336571891,3584528711,113926993,338241895,666307205,773529912,1294757372,1396182291,1695183700,1986661051,2177026350,2456956037,2730485921,2820302411,3259730800,3345764771,3516065817,3600352804,4094571909,275423344,430227734,506948616,659060556,883997877,958139571,1322822218,1537002063,1747873779,1955562222,2024104815,2227730452,2361852424,2428436474,2756734187,3204031479,3329325298]),t.b)
B.ar=new A.aI("event")
B.aw=A.b(s([B.V,B.ar]),A.aE("o<aI>"))
B.ax=A.b(s([B.K,B.U,B.r,B.t,B.L]),A.aE("o<R>"))
B.ao=new A.aH("Approved","approved")
B.ay=A.b(s([B.ao,B.q]),A.aE("o<aH>"))
B.az=A.b(s([B.W,B.M]),A.aE("o<aJ>"))
B.Z=new A.d0("one")
B.aa=new A.bv("ripple")
B.a_=new A.bF([B.w,"123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz",B.aa,"rpshnaf39wBUDNEGHJKLM4PQRST7VWXYZ2bcdeCg65jkm8oFqi1tuvAxyz"],A.aE("bF<bv,j>"))
B.aA=new A.eA("Invalid character in Base58 string",null)
B.n=new A.db("walletStandard")
B.j=new A.db("eip1993")
B.a1=new A.aw("ascii")
B.N=new A.aw("utf8")
B.v=new A.aw("base64")
B.a2=new A.aw("base64UrlSafe")
B.a3=new A.aw("base58")
B.a4=new A.aw("base58Check")
B.a5=new A.aw("hex")
B.aD=A.aj("cJ")
B.aE=A.aj("hb")
B.aF=A.aj("dU")
B.aG=A.aj("dV")
B.aH=A.aj("e0")
B.aI=A.aj("e1")
B.aJ=A.aj("e2")
B.aK=A.aj("e")
B.aL=A.aj("eZ")
B.aM=A.aj("f_")
B.aN=A.aj("f0")
B.aO=A.aj("f1")
B.aP=new A.dk(!1)
B.aQ=new A.dk(!0)
B.l=new A.cd("An error occurred during the request",-32603)})();(function staticFields(){$.fy=null
$.a2=A.b([],t.f)
$.ik=null
$.i1=null
$.i0=null
$.jb=null
$.j6=null
$.jf=null
$.fU=null
$.fZ=null
$.hO=null
$.mF=A.b([],A.aE("o<m<e>?>"))
$.bn=null
$.cA=null
$.cB=null
$.hI=!1
$.u=B.h
$.iA=null
$.iB=null
$.iC=null
$.iD=null
$.hu=A.fi("_lastQuoRemDigits")
$.hv=A.fi("_lastQuoRemUsed")
$.ci=A.fi("_lastRemUsed")
$.hw=A.fi("_lastRem_nsh")})();(function lazyInitializers(){var s=hunkHelpers.lazyFinal
s($,"me","bs",()=>A.m1("_$dart_dartClosure"))
s($,"mn","jo",()=>A.ay(A.eW({
toString:function(){return"$receiver$"}})))
s($,"mo","jp",()=>A.ay(A.eW({$method$:null,
toString:function(){return"$receiver$"}})))
s($,"mp","jq",()=>A.ay(A.eW(null)))
s($,"mq","jr",()=>A.ay(function(){var $argumentsExpr$="$arguments$"
try{null.$method$($argumentsExpr$)}catch(r){return r.message}}()))
s($,"mt","ju",()=>A.ay(A.eW(void 0)))
s($,"mu","jv",()=>A.ay(function(){var $argumentsExpr$="$arguments$"
try{(void 0).$method$($argumentsExpr$)}catch(r){return r.message}}()))
s($,"ms","jt",()=>A.ay(A.iv(null)))
s($,"mr","js",()=>A.ay(function(){try{null.$method$}catch(r){return r.message}}()))
s($,"mw","jx",()=>A.ay(A.iv(void 0)))
s($,"mv","jw",()=>A.ay(function(){try{(void 0).$method$}catch(r){return r.message}}()))
s($,"mx","hU",()=>A.kH())
s($,"mI","jD",()=>A.ih(4096))
s($,"mG","jB",()=>new A.fH().$0())
s($,"mH","jC",()=>new A.fG().$0())
s($,"mE","P",()=>A.dm(0))
s($,"mC","aF",()=>A.dm(1))
s($,"mD","jA",()=>A.dm(2))
s($,"mB","hV",()=>$.aF().a0(0))
s($,"mz","jy",()=>A.dm(1e4))
s($,"mA","jz",()=>A.ih(8))
s($,"mJ","h6",()=>A.dy(B.aK))
s($,"mK","jE",()=>Symbol("jsBoxedDartObjectProperty"))
s($,"mh","jk",()=>{var r=new A.fx(new DataView(new ArrayBuffer(A.lk(8))))
r.ck()
return r})
s($,"my","h5",()=>new A.fc().$0())
s($,"ml","jm",()=>A.kA("^(0x|0X)?([0-9A-Fa-f]{2})+$"))
s($,"mg","hT",()=>({message:"this feature disabled by wallet provider."}))
s($,"mf","jj",()=>({uuid:"466aef37-e077-42d1-b26b-801ff1af4a36",name:"OnChain",icon:u.f,rdns:"com.mrtnetwork.wallet"}))
s($,"mj","jl",()=>A.kj(A.b(["legacy",0],t.f),t.K))
s($,"mm","jn",()=>({message:"Invalid Sui transaction. The transaction must include transactionBlock with the blockData property for v1, or transaction with the toJSON property for v2."}))})();(function nativeSupport(){!function(){var s=function(a){var m={}
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
hunkHelpers.setOrUpdateInterceptorsByTag({ArrayBuffer:A.bT,ArrayBufferView:A.bX,DataView:A.bU,Float32Array:A.d1,Float64Array:A.d2,Int16Array:A.d3,Int32Array:A.d4,Int8Array:A.d5,Uint16Array:A.d6,Uint32Array:A.d7,Uint8ClampedArray:A.bY,CanvasPixelArray:A.bY,Uint8Array:A.aW})
hunkHelpers.setOrUpdateLeafTags({ArrayBuffer:true,ArrayBufferView:false,DataView:true,Float32Array:true,Float64Array:true,Int16Array:true,Int32Array:true,Int8Array:true,Uint16Array:true,Uint32Array:true,Uint8ClampedArray:true,CanvasPixelArray:true,Uint8Array:false})
A.bd.$nativeSuperclassTag="ArrayBufferView"
A.cn.$nativeSuperclassTag="ArrayBufferView"
A.co.$nativeSuperclassTag="ArrayBufferView"
A.bV.$nativeSuperclassTag="ArrayBufferView"
A.cp.$nativeSuperclassTag="ArrayBufferView"
A.cq.$nativeSuperclassTag="ArrayBufferView"
A.bW.$nativeSuperclassTag="ArrayBufferView"})()
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
var s=function(b){return A.hQ(A.lX(b))}
if(typeof dartMainRunner==="function"){dartMainRunner(s,[])}else{s([])}})})()