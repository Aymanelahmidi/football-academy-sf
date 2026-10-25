(function(){"use strict";function Ec(e){return e&&e.__esModule&&Object.prototype.hasOwnProperty.call(e,"default")?e.default:e}var Ko={exports:{}},or={},Yo={exports:{}},I={};/**
 * @license React
 * react.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */var gn=Symbol.for("react.element"),zc=Symbol.for("react.portal"),_c=Symbol.for("react.fragment"),Lc=Symbol.for("react.strict_mode"),bc=Symbol.for("react.profiler"),Tc=Symbol.for("react.provider"),Pc=Symbol.for("react.context"),Fc=Symbol.for("react.forward_ref"),Mc=Symbol.for("react.suspense"),Dc=Symbol.for("react.memo"),Ic=Symbol.for("react.lazy"),Xo=Symbol.iterator;function Rc(e){return e===null||typeof e!="object"?null:(e=Xo&&e[Xo]||e["@@iterator"],typeof e=="function"?e:null)}var Go={isMounted:function(){return!1},enqueueForceUpdate:function(){},enqueueReplaceState:function(){},enqueueSetState:function(){}},Jo=Object.assign,Zo={};function At(e,t,n){this.props=e,this.context=t,this.refs=Zo,this.updater=n||Go}At.prototype.isReactComponent={},At.prototype.setState=function(e,t){if(typeof e!="object"&&typeof e!="function"&&e!=null)throw Error("setState(...): takes an object of state variables to update or a function which returns an object of state variables.");this.updater.enqueueSetState(this,e,t,"setState")},At.prototype.forceUpdate=function(e){this.updater.enqueueForceUpdate(this,e,"forceUpdate")};function qo(){}qo.prototype=At.prototype;function _l(e,t,n){this.props=e,this.context=t,this.refs=Zo,this.updater=n||Go}var Ll=_l.prototype=new qo;Ll.constructor=_l,Jo(Ll,At.prototype),Ll.isPureReactComponent=!0;var es=Array.isArray,ts=Object.prototype.hasOwnProperty,bl={current:null},ns={key:!0,ref:!0,__self:!0,__source:!0};function rs(e,t,n){var r,l={},i=null,o=null;if(t!=null)for(r in t.ref!==void 0&&(o=t.ref),t.key!==void 0&&(i=""+t.key),t)ts.call(t,r)&&!ns.hasOwnProperty(r)&&(l[r]=t[r]);var a=arguments.length-2;if(a===1)l.children=n;else if(1<a){for(var u=Array(a),f=0;f<a;f++)u[f]=arguments[f+2];l.children=u}if(e&&e.defaultProps)for(r in a=e.defaultProps,a)l[r]===void 0&&(l[r]=a[r]);return{$$typeof:gn,type:e,key:i,ref:o,props:l,_owner:bl.current}}function Oc(e,t){return{$$typeof:gn,type:e.type,key:t,ref:e.ref,props:e.props,_owner:e._owner}}function Tl(e){return typeof e=="object"&&e!==null&&e.$$typeof===gn}function Ac(e){var t={"=":"=0",":":"=2"};return"$"+e.replace(/[=:]/g,function(n){return t[n]})}var ls=/\/+/g;function Pl(e,t){return typeof e=="object"&&e!==null&&e.key!=null?Ac(""+e.key):t.toString(36)}function sr(e,t,n,r,l){var i=typeof e;(i==="undefined"||i==="boolean")&&(e=null);var o=!1;if(e===null)o=!0;else switch(i){case"string":case"number":o=!0;break;case"object":switch(e.$$typeof){case gn:case zc:o=!0}}if(o)return o=e,l=l(o),e=r===""?"."+Pl(o,0):r,es(l)?(n="",e!=null&&(n=e.replace(ls,"$&/")+"/"),sr(l,t,n,"",function(f){return f})):l!=null&&(Tl(l)&&(l=Oc(l,n+(!l.key||o&&o.key===l.key?"":(""+l.key).replace(ls,"$&/")+"/")+e)),t.push(l)),1;if(o=0,r=r===""?".":r+":",es(e))for(var a=0;a<e.length;a++){i=e[a];var u=r+Pl(i,a);o+=sr(i,t,n,u,l)}else if(u=Rc(e),typeof u=="function")for(e=u.call(e),a=0;!(i=e.next()).done;)i=i.value,u=r+Pl(i,a++),o+=sr(i,t,n,u,l);else if(i==="object")throw t=String(e),Error("Objects are not valid as a React child (found: "+(t==="[object Object]"?"object with keys {"+Object.keys(e).join(", ")+"}":t)+"). If you meant to render a collection of children, use an array instead.");return o}function ar(e,t,n){if(e==null)return e;var r=[],l=0;return sr(e,r,"","",function(i){return t.call(n,i,l++)}),r}function $c(e){if(e._status===-1){var t=e._result;t=t(),t.then(function(n){(e._status===0||e._status===-1)&&(e._status=1,e._result=n)},function(n){(e._status===0||e._status===-1)&&(e._status=2,e._result=n)}),e._status===-1&&(e._status=0,e._result=t)}if(e._status===1)return e._result.default;throw e._result}var ce={current:null},ur={transition:null},Bc={ReactCurrentDispatcher:ce,ReactCurrentBatchConfig:ur,ReactCurrentOwner:bl};I.Children={map:ar,forEach:function(e,t,n){ar(e,function(){t.apply(this,arguments)},n)},count:function(e){var t=0;return ar(e,function(){t++}),t},toArray:function(e){return ar(e,function(t){return t})||[]},only:function(e){if(!Tl(e))throw Error("React.Children.only expected to receive a single React element child.");return e}},I.Component=At,I.Fragment=_c,I.Profiler=bc,I.PureComponent=_l,I.StrictMode=Lc,I.Suspense=Mc,I.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED=Bc,I.cloneElement=function(e,t,n){if(e==null)throw Error("React.cloneElement(...): The argument must be a React element, but you passed "+e+".");var r=Jo({},e.props),l=e.key,i=e.ref,o=e._owner;if(t!=null){if(t.ref!==void 0&&(i=t.ref,o=bl.current),t.key!==void 0&&(l=""+t.key),e.type&&e.type.defaultProps)var a=e.type.defaultProps;for(u in t)ts.call(t,u)&&!ns.hasOwnProperty(u)&&(r[u]=t[u]===void 0&&a!==void 0?a[u]:t[u])}var u=arguments.length-2;if(u===1)r.children=n;else if(1<u){a=Array(u);for(var f=0;f<u;f++)a[f]=arguments[f+2];r.children=a}return{$$typeof:gn,type:e.type,key:l,ref:i,props:r,_owner:o}},I.createContext=function(e){return e={$$typeof:Pc,_currentValue:e,_currentValue2:e,_threadCount:0,Provider:null,Consumer:null,_defaultValue:null,_globalName:null},e.Provider={$$typeof:Tc,_context:e},e.Consumer=e},I.createElement=rs,I.createFactory=function(e){var t=rs.bind(null,e);return t.type=e,t},I.createRef=function(){return{current:null}},I.forwardRef=function(e){return{$$typeof:Fc,render:e}},I.isValidElement=Tl,I.lazy=function(e){return{$$typeof:Ic,_payload:{_status:-1,_result:e},_init:$c}},I.memo=function(e,t){return{$$typeof:Dc,type:e,compare:t===void 0?null:t}},I.startTransition=function(e){var t=ur.transition;ur.transition={};try{e()}finally{ur.transition=t}},I.unstable_act=function(){throw Error("act(...) is not supported in production builds of React.")},I.useCallback=function(e,t){return ce.current.useCallback(e,t)},I.useContext=function(e){return ce.current.useContext(e)},I.useDebugValue=function(){},I.useDeferredValue=function(e){return ce.current.useDeferredValue(e)},I.useEffect=function(e,t){return ce.current.useEffect(e,t)},I.useId=function(){return ce.current.useId()},I.useImperativeHandle=function(e,t,n){return ce.current.useImperativeHandle(e,t,n)},I.useInsertionEffect=function(e,t){return ce.current.useInsertionEffect(e,t)},I.useLayoutEffect=function(e,t){return ce.current.useLayoutEffect(e,t)},I.useMemo=function(e,t){return ce.current.useMemo(e,t)},I.useReducer=function(e,t,n){return ce.current.useReducer(e,t,n)},I.useRef=function(e){return ce.current.useRef(e)},I.useState=function(e){return ce.current.useState(e)},I.useSyncExternalStore=function(e,t,n){return ce.current.useSyncExternalStore(e,t,n)},I.useTransition=function(){return ce.current.useTransition()},I.version="18.2.0",Yo.exports=I;var P=Yo.exports;const Uc=Ec(P);/**
 * @license React
 * react-jsx-runtime.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */var Vc=P,Hc=Symbol.for("react.element"),Wc=Symbol.for("react.fragment"),Qc=Object.prototype.hasOwnProperty,Kc=Vc.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,Yc={key:!0,ref:!0,__self:!0,__source:!0};function is(e,t,n){var r,l={},i=null,o=null;n!==void 0&&(i=""+n),t.key!==void 0&&(i=""+t.key),t.ref!==void 0&&(o=t.ref);for(r in t)Qc.call(t,r)&&!Yc.hasOwnProperty(r)&&(l[r]=t[r]);if(e&&e.defaultProps)for(r in t=e.defaultProps,t)l[r]===void 0&&(l[r]=t[r]);return{$$typeof:Hc,type:e,key:i,ref:o,props:l,_owner:Kc.current}}or.Fragment=Wc,or.jsx=is,or.jsxs=is,Ko.exports=or;var s=Ko.exports,os={exports:{}},we={},ss={exports:{}},as={};/**
 * @license React
 * scheduler.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */(function(e){function t(T,M){var D=T.length;T.push(M);e:for(;0<D;){var G=D-1>>>1,ne=T[G];if(0<l(ne,M))T[G]=M,T[D]=ne,D=G;else break e}}function n(T){return T.length===0?null:T[0]}function r(T){if(T.length===0)return null;var M=T[0],D=T.pop();if(D!==M){T[0]=D;e:for(var G=0,ne=T.length,El=ne>>>1;G<El;){var Rt=2*(G+1)-1,Qo=T[Rt],Ot=Rt+1,zl=T[Ot];if(0>l(Qo,D))Ot<ne&&0>l(zl,Qo)?(T[G]=zl,T[Ot]=D,G=Ot):(T[G]=Qo,T[Rt]=D,G=Rt);else if(Ot<ne&&0>l(zl,D))T[G]=zl,T[Ot]=D,G=Ot;else break e}}return M}function l(T,M){var D=T.sortIndex-M.sortIndex;return D!==0?D:T.id-M.id}if(typeof performance=="object"&&typeof performance.now=="function"){var i=performance;e.unstable_now=function(){return i.now()}}else{var o=Date,a=o.now();e.unstable_now=function(){return o.now()-a}}var u=[],f=[],v=1,g=null,m=3,y=!1,C=!1,S=!1,_=typeof setTimeout=="function"?setTimeout:null,d=typeof clearTimeout=="function"?clearTimeout:null,c=typeof setImmediate<"u"?setImmediate:null;typeof navigator<"u"&&navigator.scheduling!==void 0&&navigator.scheduling.isInputPending!==void 0&&navigator.scheduling.isInputPending.bind(navigator.scheduling);function p(T){for(var M=n(f);M!==null;){if(M.callback===null)r(f);else if(M.startTime<=T)r(f),M.sortIndex=M.expirationTime,t(u,M);else break;M=n(f)}}function h(T){if(S=!1,p(T),!C)if(n(u)!==null)C=!0,mn(j);else{var M=n(f);M!==null&&Wo(h,M.startTime-T)}}function j(T,M){C=!1,S&&(S=!1,d(L),L=-1),y=!0;var D=m;try{for(p(M),g=n(u);g!==null&&(!(g.expirationTime>M)||T&&!z());){var G=g.callback;if(typeof G=="function"){g.callback=null,m=g.priorityLevel;var ne=G(g.expirationTime<=M);M=e.unstable_now(),typeof ne=="function"?g.callback=ne:g===n(u)&&r(u),p(M)}else r(u);g=n(u)}if(g!==null)var El=!0;else{var Rt=n(f);Rt!==null&&Wo(h,Rt.startTime-M),El=!1}return El}finally{g=null,m=D,y=!1}}var N=!1,w=null,L=-1,O=5,F=-1;function z(){return!(e.unstable_now()-F<O)}function E(){if(w!==null){var T=e.unstable_now();F=T;var M=!0;try{M=w(!0,T)}finally{M?$():(N=!1,w=null)}}else N=!1}var $;if(typeof c=="function")$=function(){c(E)};else if(typeof MessageChannel<"u"){var It=new MessageChannel,ye=It.port2;It.port1.onmessage=E,$=function(){ye.postMessage(null)}}else $=function(){_(E,0)};function mn(T){w=T,N||(N=!0,$())}function Wo(T,M){L=_(function(){T(e.unstable_now())},M)}e.unstable_IdlePriority=5,e.unstable_ImmediatePriority=1,e.unstable_LowPriority=4,e.unstable_NormalPriority=3,e.unstable_Profiling=null,e.unstable_UserBlockingPriority=2,e.unstable_cancelCallback=function(T){T.callback=null},e.unstable_continueExecution=function(){C||y||(C=!0,mn(j))},e.unstable_forceFrameRate=function(T){0>T||125<T?console.error("forceFrameRate takes a positive int between 0 and 125, forcing frame rates higher than 125 fps is not supported"):O=0<T?Math.floor(1e3/T):5},e.unstable_getCurrentPriorityLevel=function(){return m},e.unstable_getFirstCallbackNode=function(){return n(u)},e.unstable_next=function(T){switch(m){case 1:case 2:case 3:var M=3;break;default:M=m}var D=m;m=M;try{return T()}finally{m=D}},e.unstable_pauseExecution=function(){},e.unstable_requestPaint=function(){},e.unstable_runWithPriority=function(T,M){switch(T){case 1:case 2:case 3:case 4:case 5:break;default:T=3}var D=m;m=T;try{return M()}finally{m=D}},e.unstable_scheduleCallback=function(T,M,D){var G=e.unstable_now();switch(typeof D=="object"&&D!==null?(D=D.delay,D=typeof D=="number"&&0<D?G+D:G):D=G,T){case 1:var ne=-1;break;case 2:ne=250;break;case 5:ne=1073741823;break;case 4:ne=1e4;break;default:ne=5e3}return ne=D+ne,T={id:v++,callback:M,priorityLevel:T,startTime:D,expirationTime:ne,sortIndex:-1},D>G?(T.sortIndex=D,t(f,T),n(u)===null&&T===n(f)&&(S?(d(L),L=-1):S=!0,Wo(h,D-G))):(T.sortIndex=ne,t(u,T),C||y||(C=!0,mn(j))),T},e.unstable_shouldYield=z,e.unstable_wrapCallback=function(T){var M=m;return function(){var D=m;m=M;try{return T.apply(this,arguments)}finally{m=D}}}})(as),ss.exports=as;var Xc=ss.exports;/**
 * @license React
 * react-dom.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */var us=P,ke=Xc;function k(e){for(var t="https://reactjs.org/docs/error-decoder.html?invariant="+e,n=1;n<arguments.length;n++)t+="&args[]="+encodeURIComponent(arguments[n]);return"Minified React error #"+e+"; visit "+t+" for the full message or use the non-minified dev environment for full errors and additional helpful warnings."}var cs=new Set,vn={};function St(e,t){$t(e,t),$t(e+"Capture",t)}function $t(e,t){for(vn[e]=t,e=0;e<t.length;e++)cs.add(t[e])}var He=!(typeof window>"u"||typeof window.document>"u"||typeof window.document.createElement>"u"),Fl=Object.prototype.hasOwnProperty,Gc=/^[:A-Z_a-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD][:A-Z_a-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD\-.0-9\u00B7\u0300-\u036F\u203F-\u2040]*$/,ds={},fs={};function Jc(e){return Fl.call(fs,e)?!0:Fl.call(ds,e)?!1:Gc.test(e)?fs[e]=!0:(ds[e]=!0,!1)}function Zc(e,t,n,r){if(n!==null&&n.type===0)return!1;switch(typeof t){case"function":case"symbol":return!0;case"boolean":return r?!1:n!==null?!n.acceptsBooleans:(e=e.toLowerCase().slice(0,5),e!=="data-"&&e!=="aria-");default:return!1}}function qc(e,t,n,r){if(t===null||typeof t>"u"||Zc(e,t,n,r))return!0;if(r)return!1;if(n!==null)switch(n.type){case 3:return!t;case 4:return t===!1;case 5:return isNaN(t);case 6:return isNaN(t)||1>t}return!1}function de(e,t,n,r,l,i,o){this.acceptsBooleans=t===2||t===3||t===4,this.attributeName=r,this.attributeNamespace=l,this.mustUseProperty=n,this.propertyName=e,this.type=t,this.sanitizeURL=i,this.removeEmptyString=o}var re={};"children dangerouslySetInnerHTML defaultValue defaultChecked innerHTML suppressContentEditableWarning suppressHydrationWarning style".split(" ").forEach(function(e){re[e]=new de(e,0,!1,e,null,!1,!1)}),[["acceptCharset","accept-charset"],["className","class"],["htmlFor","for"],["httpEquiv","http-equiv"]].forEach(function(e){var t=e[0];re[t]=new de(t,1,!1,e[1],null,!1,!1)}),["contentEditable","draggable","spellCheck","value"].forEach(function(e){re[e]=new de(e,2,!1,e.toLowerCase(),null,!1,!1)}),["autoReverse","externalResourcesRequired","focusable","preserveAlpha"].forEach(function(e){re[e]=new de(e,2,!1,e,null,!1,!1)}),"allowFullScreen async autoFocus autoPlay controls default defer disabled disablePictureInPicture disableRemotePlayback formNoValidate hidden loop noModule noValidate open playsInline readOnly required reversed scoped seamless itemScope".split(" ").forEach(function(e){re[e]=new de(e,3,!1,e.toLowerCase(),null,!1,!1)}),["checked","multiple","muted","selected"].forEach(function(e){re[e]=new de(e,3,!0,e,null,!1,!1)}),["capture","download"].forEach(function(e){re[e]=new de(e,4,!1,e,null,!1,!1)}),["cols","rows","size","span"].forEach(function(e){re[e]=new de(e,6,!1,e,null,!1,!1)}),["rowSpan","start"].forEach(function(e){re[e]=new de(e,5,!1,e.toLowerCase(),null,!1,!1)});var Ml=/[\-:]([a-z])/g;function Dl(e){return e[1].toUpperCase()}"accent-height alignment-baseline arabic-form baseline-shift cap-height clip-path clip-rule color-interpolation color-interpolation-filters color-profile color-rendering dominant-baseline enable-background fill-opacity fill-rule flood-color flood-opacity font-family font-size font-size-adjust font-stretch font-style font-variant font-weight glyph-name glyph-orientation-horizontal glyph-orientation-vertical horiz-adv-x horiz-origin-x image-rendering letter-spacing lighting-color marker-end marker-mid marker-start overline-position overline-thickness paint-order panose-1 pointer-events rendering-intent shape-rendering stop-color stop-opacity strikethrough-position strikethrough-thickness stroke-dasharray stroke-dashoffset stroke-linecap stroke-linejoin stroke-miterlimit stroke-opacity stroke-width text-anchor text-decoration text-rendering underline-position underline-thickness unicode-bidi unicode-range units-per-em v-alphabetic v-hanging v-ideographic v-mathematical vector-effect vert-adv-y vert-origin-x vert-origin-y word-spacing writing-mode xmlns:xlink x-height".split(" ").forEach(function(e){var t=e.replace(Ml,Dl);re[t]=new de(t,1,!1,e,null,!1,!1)}),"xlink:actuate xlink:arcrole xlink:role xlink:show xlink:title xlink:type".split(" ").forEach(function(e){var t=e.replace(Ml,Dl);re[t]=new de(t,1,!1,e,"http://www.w3.org/1999/xlink",!1,!1)}),["xml:base","xml:lang","xml:space"].forEach(function(e){var t=e.replace(Ml,Dl);re[t]=new de(t,1,!1,e,"http://www.w3.org/XML/1998/namespace",!1,!1)}),["tabIndex","crossOrigin"].forEach(function(e){re[e]=new de(e,1,!1,e.toLowerCase(),null,!1,!1)}),re.xlinkHref=new de("xlinkHref",1,!1,"xlink:href","http://www.w3.org/1999/xlink",!0,!1),["src","href","action","formAction"].forEach(function(e){re[e]=new de(e,1,!1,e.toLowerCase(),null,!0,!0)});function Il(e,t,n,r){var l=re.hasOwnProperty(t)?re[t]:null;(l!==null?l.type!==0:r||!(2<t.length)||t[0]!=="o"&&t[0]!=="O"||t[1]!=="n"&&t[1]!=="N")&&(qc(t,n,l,r)&&(n=null),r||l===null?Jc(t)&&(n===null?e.removeAttribute(t):e.setAttribute(t,""+n)):l.mustUseProperty?e[l.propertyName]=n===null?l.type===3?!1:"":n:(t=l.attributeName,r=l.attributeNamespace,n===null?e.removeAttribute(t):(l=l.type,n=l===3||l===4&&n===!0?"":""+n,r?e.setAttributeNS(r,t,n):e.setAttribute(t,n))))}var We=us.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED,cr=Symbol.for("react.element"),Bt=Symbol.for("react.portal"),Ut=Symbol.for("react.fragment"),Rl=Symbol.for("react.strict_mode"),Ol=Symbol.for("react.profiler"),ps=Symbol.for("react.provider"),hs=Symbol.for("react.context"),Al=Symbol.for("react.forward_ref"),$l=Symbol.for("react.suspense"),Bl=Symbol.for("react.suspense_list"),Ul=Symbol.for("react.memo"),nt=Symbol.for("react.lazy"),ms=Symbol.for("react.offscreen"),gs=Symbol.iterator;function xn(e){return e===null||typeof e!="object"?null:(e=gs&&e[gs]||e["@@iterator"],typeof e=="function"?e:null)}var W=Object.assign,Vl;function yn(e){if(Vl===void 0)try{throw Error()}catch(n){var t=n.stack.trim().match(/\n( *(at )?)/);Vl=t&&t[1]||""}return`
`+Vl+e}var Hl=!1;function Wl(e,t){if(!e||Hl)return"";Hl=!0;var n=Error.prepareStackTrace;Error.prepareStackTrace=void 0;try{if(t)if(t=function(){throw Error()},Object.defineProperty(t.prototype,"props",{set:function(){throw Error()}}),typeof Reflect=="object"&&Reflect.construct){try{Reflect.construct(t,[])}catch(f){var r=f}Reflect.construct(e,[],t)}else{try{t.call()}catch(f){r=f}e.call(t.prototype)}else{try{throw Error()}catch(f){r=f}e()}}catch(f){if(f&&r&&typeof f.stack=="string"){for(var l=f.stack.split(`
`),i=r.stack.split(`
`),o=l.length-1,a=i.length-1;1<=o&&0<=a&&l[o]!==i[a];)a--;for(;1<=o&&0<=a;o--,a--)if(l[o]!==i[a]){if(o!==1||a!==1)do if(o--,a--,0>a||l[o]!==i[a]){var u=`
`+l[o].replace(" at new "," at ");return e.displayName&&u.includes("<anonymous>")&&(u=u.replace("<anonymous>",e.displayName)),u}while(1<=o&&0<=a);break}}}finally{Hl=!1,Error.prepareStackTrace=n}return(e=e?e.displayName||e.name:"")?yn(e):""}function ed(e){switch(e.tag){case 5:return yn(e.type);case 16:return yn("Lazy");case 13:return yn("Suspense");case 19:return yn("SuspenseList");case 0:case 2:case 15:return e=Wl(e.type,!1),e;case 11:return e=Wl(e.type.render,!1),e;case 1:return e=Wl(e.type,!0),e;default:return""}}function Ql(e){if(e==null)return null;if(typeof e=="function")return e.displayName||e.name||null;if(typeof e=="string")return e;switch(e){case Ut:return"Fragment";case Bt:return"Portal";case Ol:return"Profiler";case Rl:return"StrictMode";case $l:return"Suspense";case Bl:return"SuspenseList"}if(typeof e=="object")switch(e.$$typeof){case hs:return(e.displayName||"Context")+".Consumer";case ps:return(e._context.displayName||"Context")+".Provider";case Al:var t=e.render;return e=e.displayName,e||(e=t.displayName||t.name||"",e=e!==""?"ForwardRef("+e+")":"ForwardRef"),e;case Ul:return t=e.displayName||null,t!==null?t:Ql(e.type)||"Memo";case nt:t=e._payload,e=e._init;try{return Ql(e(t))}catch{}}return null}function td(e){var t=e.type;switch(e.tag){case 24:return"Cache";case 9:return(t.displayName||"Context")+".Consumer";case 10:return(t._context.displayName||"Context")+".Provider";case 18:return"DehydratedFragment";case 11:return e=t.render,e=e.displayName||e.name||"",t.displayName||(e!==""?"ForwardRef("+e+")":"ForwardRef");case 7:return"Fragment";case 5:return t;case 4:return"Portal";case 3:return"Root";case 6:return"Text";case 16:return Ql(t);case 8:return t===Rl?"StrictMode":"Mode";case 22:return"Offscreen";case 12:return"Profiler";case 21:return"Scope";case 13:return"Suspense";case 19:return"SuspenseList";case 25:return"TracingMarker";case 1:case 0:case 17:case 2:case 14:case 15:if(typeof t=="function")return t.displayName||t.name||null;if(typeof t=="string")return t}return null}function rt(e){switch(typeof e){case"boolean":case"number":case"string":case"undefined":return e;case"object":return e;default:return""}}function vs(e){var t=e.type;return(e=e.nodeName)&&e.toLowerCase()==="input"&&(t==="checkbox"||t==="radio")}function nd(e){var t=vs(e)?"checked":"value",n=Object.getOwnPropertyDescriptor(e.constructor.prototype,t),r=""+e[t];if(!e.hasOwnProperty(t)&&typeof n<"u"&&typeof n.get=="function"&&typeof n.set=="function"){var l=n.get,i=n.set;return Object.defineProperty(e,t,{configurable:!0,get:function(){return l.call(this)},set:function(o){r=""+o,i.call(this,o)}}),Object.defineProperty(e,t,{enumerable:n.enumerable}),{getValue:function(){return r},setValue:function(o){r=""+o},stopTracking:function(){e._valueTracker=null,delete e[t]}}}}function dr(e){e._valueTracker||(e._valueTracker=nd(e))}function xs(e){if(!e)return!1;var t=e._valueTracker;if(!t)return!0;var n=t.getValue(),r="";return e&&(r=vs(e)?e.checked?"true":"false":e.value),e=r,e!==n?(t.setValue(e),!0):!1}function fr(e){if(e=e||(typeof document<"u"?document:void 0),typeof e>"u")return null;try{return e.activeElement||e.body}catch{return e.body}}function Kl(e,t){var n=t.checked;return W({},t,{defaultChecked:void 0,defaultValue:void 0,value:void 0,checked:n??e._wrapperState.initialChecked})}function ys(e,t){var n=t.defaultValue==null?"":t.defaultValue,r=t.checked!=null?t.checked:t.defaultChecked;n=rt(t.value!=null?t.value:n),e._wrapperState={initialChecked:r,initialValue:n,controlled:t.type==="checkbox"||t.type==="radio"?t.checked!=null:t.value!=null}}function ws(e,t){t=t.checked,t!=null&&Il(e,"checked",t,!1)}function Yl(e,t){ws(e,t);var n=rt(t.value),r=t.type;if(n!=null)r==="number"?(n===0&&e.value===""||e.value!=n)&&(e.value=""+n):e.value!==""+n&&(e.value=""+n);else if(r==="submit"||r==="reset"){e.removeAttribute("value");return}t.hasOwnProperty("value")?Xl(e,t.type,n):t.hasOwnProperty("defaultValue")&&Xl(e,t.type,rt(t.defaultValue)),t.checked==null&&t.defaultChecked!=null&&(e.defaultChecked=!!t.defaultChecked)}function ks(e,t,n){if(t.hasOwnProperty("value")||t.hasOwnProperty("defaultValue")){var r=t.type;if(!(r!=="submit"&&r!=="reset"||t.value!==void 0&&t.value!==null))return;t=""+e._wrapperState.initialValue,n||t===e.value||(e.value=t),e.defaultValue=t}n=e.name,n!==""&&(e.name=""),e.defaultChecked=!!e._wrapperState.initialChecked,n!==""&&(e.name=n)}function Xl(e,t,n){(t!=="number"||fr(e.ownerDocument)!==e)&&(n==null?e.defaultValue=""+e._wrapperState.initialValue:e.defaultValue!==""+n&&(e.defaultValue=""+n))}var wn=Array.isArray;function Vt(e,t,n,r){if(e=e.options,t){t={};for(var l=0;l<n.length;l++)t["$"+n[l]]=!0;for(n=0;n<e.length;n++)l=t.hasOwnProperty("$"+e[n].value),e[n].selected!==l&&(e[n].selected=l),l&&r&&(e[n].defaultSelected=!0)}else{for(n=""+rt(n),t=null,l=0;l<e.length;l++){if(e[l].value===n){e[l].selected=!0,r&&(e[l].defaultSelected=!0);return}t!==null||e[l].disabled||(t=e[l])}t!==null&&(t.selected=!0)}}function Gl(e,t){if(t.dangerouslySetInnerHTML!=null)throw Error(k(91));return W({},t,{value:void 0,defaultValue:void 0,children:""+e._wrapperState.initialValue})}function Ss(e,t){var n=t.value;if(n==null){if(n=t.children,t=t.defaultValue,n!=null){if(t!=null)throw Error(k(92));if(wn(n)){if(1<n.length)throw Error(k(93));n=n[0]}t=n}t==null&&(t=""),n=t}e._wrapperState={initialValue:rt(n)}}function Cs(e,t){var n=rt(t.value),r=rt(t.defaultValue);n!=null&&(n=""+n,n!==e.value&&(e.value=n),t.defaultValue==null&&e.defaultValue!==n&&(e.defaultValue=n)),r!=null&&(e.defaultValue=""+r)}function js(e){var t=e.textContent;t===e._wrapperState.initialValue&&t!==""&&t!==null&&(e.value=t)}function Ns(e){switch(e){case"svg":return"http://www.w3.org/2000/svg";case"math":return"http://www.w3.org/1998/Math/MathML";default:return"http://www.w3.org/1999/xhtml"}}function Jl(e,t){return e==null||e==="http://www.w3.org/1999/xhtml"?Ns(t):e==="http://www.w3.org/2000/svg"&&t==="foreignObject"?"http://www.w3.org/1999/xhtml":e}var pr,Es=function(e){return typeof MSApp<"u"&&MSApp.execUnsafeLocalFunction?function(t,n,r,l){MSApp.execUnsafeLocalFunction(function(){return e(t,n,r,l)})}:e}(function(e,t){if(e.namespaceURI!=="http://www.w3.org/2000/svg"||"innerHTML"in e)e.innerHTML=t;else{for(pr=pr||document.createElement("div"),pr.innerHTML="<svg>"+t.valueOf().toString()+"</svg>",t=pr.firstChild;e.firstChild;)e.removeChild(e.firstChild);for(;t.firstChild;)e.appendChild(t.firstChild)}});function kn(e,t){if(t){var n=e.firstChild;if(n&&n===e.lastChild&&n.nodeType===3){n.nodeValue=t;return}}e.textContent=t}var Sn={animationIterationCount:!0,aspectRatio:!0,borderImageOutset:!0,borderImageSlice:!0,borderImageWidth:!0,boxFlex:!0,boxFlexGroup:!0,boxOrdinalGroup:!0,columnCount:!0,columns:!0,flex:!0,flexGrow:!0,flexPositive:!0,flexShrink:!0,flexNegative:!0,flexOrder:!0,gridArea:!0,gridRow:!0,gridRowEnd:!0,gridRowSpan:!0,gridRowStart:!0,gridColumn:!0,gridColumnEnd:!0,gridColumnSpan:!0,gridColumnStart:!0,fontWeight:!0,lineClamp:!0,lineHeight:!0,opacity:!0,order:!0,orphans:!0,tabSize:!0,widows:!0,zIndex:!0,zoom:!0,fillOpacity:!0,floodOpacity:!0,stopOpacity:!0,strokeDasharray:!0,strokeDashoffset:!0,strokeMiterlimit:!0,strokeOpacity:!0,strokeWidth:!0},rd=["Webkit","ms","Moz","O"];Object.keys(Sn).forEach(function(e){rd.forEach(function(t){t=t+e.charAt(0).toUpperCase()+e.substring(1),Sn[t]=Sn[e]})});function zs(e,t,n){return t==null||typeof t=="boolean"||t===""?"":n||typeof t!="number"||t===0||Sn.hasOwnProperty(e)&&Sn[e]?(""+t).trim():t+"px"}function _s(e,t){e=e.style;for(var n in t)if(t.hasOwnProperty(n)){var r=n.indexOf("--")===0,l=zs(n,t[n],r);n==="float"&&(n="cssFloat"),r?e.setProperty(n,l):e[n]=l}}var ld=W({menuitem:!0},{area:!0,base:!0,br:!0,col:!0,embed:!0,hr:!0,img:!0,input:!0,keygen:!0,link:!0,meta:!0,param:!0,source:!0,track:!0,wbr:!0});function Zl(e,t){if(t){if(ld[e]&&(t.children!=null||t.dangerouslySetInnerHTML!=null))throw Error(k(137,e));if(t.dangerouslySetInnerHTML!=null){if(t.children!=null)throw Error(k(60));if(typeof t.dangerouslySetInnerHTML!="object"||!("__html"in t.dangerouslySetInnerHTML))throw Error(k(61))}if(t.style!=null&&typeof t.style!="object")throw Error(k(62))}}function ql(e,t){if(e.indexOf("-")===-1)return typeof t.is=="string";switch(e){case"annotation-xml":case"color-profile":case"font-face":case"font-face-src":case"font-face-uri":case"font-face-format":case"font-face-name":case"missing-glyph":return!1;default:return!0}}var ei=null;function ti(e){return e=e.target||e.srcElement||window,e.correspondingUseElement&&(e=e.correspondingUseElement),e.nodeType===3?e.parentNode:e}var ni=null,Ht=null,Wt=null;function Ls(e){if(e=Hn(e)){if(typeof ni!="function")throw Error(k(280));var t=e.stateNode;t&&(t=Ir(t),ni(e.stateNode,e.type,t))}}function bs(e){Ht?Wt?Wt.push(e):Wt=[e]:Ht=e}function Ts(){if(Ht){var e=Ht,t=Wt;if(Wt=Ht=null,Ls(e),t)for(e=0;e<t.length;e++)Ls(t[e])}}function Ps(e,t){return e(t)}function Fs(){}var ri=!1;function Ms(e,t,n){if(ri)return e(t,n);ri=!0;try{return Ps(e,t,n)}finally{ri=!1,(Ht!==null||Wt!==null)&&(Fs(),Ts())}}function Cn(e,t){var n=e.stateNode;if(n===null)return null;var r=Ir(n);if(r===null)return null;n=r[t];e:switch(t){case"onClick":case"onClickCapture":case"onDoubleClick":case"onDoubleClickCapture":case"onMouseDown":case"onMouseDownCapture":case"onMouseMove":case"onMouseMoveCapture":case"onMouseUp":case"onMouseUpCapture":case"onMouseEnter":(r=!r.disabled)||(e=e.type,r=!(e==="button"||e==="input"||e==="select"||e==="textarea")),e=!r;break e;default:e=!1}if(e)return null;if(n&&typeof n!="function")throw Error(k(231,t,typeof n));return n}var li=!1;if(He)try{var jn={};Object.defineProperty(jn,"passive",{get:function(){li=!0}}),window.addEventListener("test",jn,jn),window.removeEventListener("test",jn,jn)}catch{li=!1}function id(e,t,n,r,l,i,o,a,u){var f=Array.prototype.slice.call(arguments,3);try{t.apply(n,f)}catch(v){this.onError(v)}}var Nn=!1,hr=null,mr=!1,ii=null,od={onError:function(e){Nn=!0,hr=e}};function sd(e,t,n,r,l,i,o,a,u){Nn=!1,hr=null,id.apply(od,arguments)}function ad(e,t,n,r,l,i,o,a,u){if(sd.apply(this,arguments),Nn){if(Nn){var f=hr;Nn=!1,hr=null}else throw Error(k(198));mr||(mr=!0,ii=f)}}function Ct(e){var t=e,n=e;if(e.alternate)for(;t.return;)t=t.return;else{e=t;do t=e,t.flags&4098&&(n=t.return),e=t.return;while(e)}return t.tag===3?n:null}function Ds(e){if(e.tag===13){var t=e.memoizedState;if(t===null&&(e=e.alternate,e!==null&&(t=e.memoizedState)),t!==null)return t.dehydrated}return null}function Is(e){if(Ct(e)!==e)throw Error(k(188))}function ud(e){var t=e.alternate;if(!t){if(t=Ct(e),t===null)throw Error(k(188));return t!==e?null:e}for(var n=e,r=t;;){var l=n.return;if(l===null)break;var i=l.alternate;if(i===null){if(r=l.return,r!==null){n=r;continue}break}if(l.child===i.child){for(i=l.child;i;){if(i===n)return Is(l),e;if(i===r)return Is(l),t;i=i.sibling}throw Error(k(188))}if(n.return!==r.return)n=l,r=i;else{for(var o=!1,a=l.child;a;){if(a===n){o=!0,n=l,r=i;break}if(a===r){o=!0,r=l,n=i;break}a=a.sibling}if(!o){for(a=i.child;a;){if(a===n){o=!0,n=i,r=l;break}if(a===r){o=!0,r=i,n=l;break}a=a.sibling}if(!o)throw Error(k(189))}}if(n.alternate!==r)throw Error(k(190))}if(n.tag!==3)throw Error(k(188));return n.stateNode.current===n?e:t}function Rs(e){return e=ud(e),e!==null?Os(e):null}function Os(e){if(e.tag===5||e.tag===6)return e;for(e=e.child;e!==null;){var t=Os(e);if(t!==null)return t;e=e.sibling}return null}var As=ke.unstable_scheduleCallback,$s=ke.unstable_cancelCallback,cd=ke.unstable_shouldYield,dd=ke.unstable_requestPaint,X=ke.unstable_now,fd=ke.unstable_getCurrentPriorityLevel,oi=ke.unstable_ImmediatePriority,Bs=ke.unstable_UserBlockingPriority,gr=ke.unstable_NormalPriority,pd=ke.unstable_LowPriority,Us=ke.unstable_IdlePriority,vr=null,Ae=null;function hd(e){if(Ae&&typeof Ae.onCommitFiberRoot=="function")try{Ae.onCommitFiberRoot(vr,e,void 0,(e.current.flags&128)===128)}catch{}}var Pe=Math.clz32?Math.clz32:vd,md=Math.log,gd=Math.LN2;function vd(e){return e>>>=0,e===0?32:31-(md(e)/gd|0)|0}var xr=64,yr=4194304;function En(e){switch(e&-e){case 1:return 1;case 2:return 2;case 4:return 4;case 8:return 8;case 16:return 16;case 32:return 32;case 64:case 128:case 256:case 512:case 1024:case 2048:case 4096:case 8192:case 16384:case 32768:case 65536:case 131072:case 262144:case 524288:case 1048576:case 2097152:return e&4194240;case 4194304:case 8388608:case 16777216:case 33554432:case 67108864:return e&130023424;case 134217728:return 134217728;case 268435456:return 268435456;case 536870912:return 536870912;case 1073741824:return 1073741824;default:return e}}function wr(e,t){var n=e.pendingLanes;if(n===0)return 0;var r=0,l=e.suspendedLanes,i=e.pingedLanes,o=n&268435455;if(o!==0){var a=o&~l;a!==0?r=En(a):(i&=o,i!==0&&(r=En(i)))}else o=n&~l,o!==0?r=En(o):i!==0&&(r=En(i));if(r===0)return 0;if(t!==0&&t!==r&&!(t&l)&&(l=r&-r,i=t&-t,l>=i||l===16&&(i&4194240)!==0))return t;if(r&4&&(r|=n&16),t=e.entangledLanes,t!==0)for(e=e.entanglements,t&=r;0<t;)n=31-Pe(t),l=1<<n,r|=e[n],t&=~l;return r}function xd(e,t){switch(e){case 1:case 2:case 4:return t+250;case 8:case 16:case 32:case 64:case 128:case 256:case 512:case 1024:case 2048:case 4096:case 8192:case 16384:case 32768:case 65536:case 131072:case 262144:case 524288:case 1048576:case 2097152:return t+5e3;case 4194304:case 8388608:case 16777216:case 33554432:case 67108864:return-1;case 134217728:case 268435456:case 536870912:case 1073741824:return-1;default:return-1}}function yd(e,t){for(var n=e.suspendedLanes,r=e.pingedLanes,l=e.expirationTimes,i=e.pendingLanes;0<i;){var o=31-Pe(i),a=1<<o,u=l[o];u===-1?(!(a&n)||a&r)&&(l[o]=xd(a,t)):u<=t&&(e.expiredLanes|=a),i&=~a}}function si(e){return e=e.pendingLanes&-1073741825,e!==0?e:e&1073741824?1073741824:0}function Vs(){var e=xr;return xr<<=1,!(xr&4194240)&&(xr=64),e}function ai(e){for(var t=[],n=0;31>n;n++)t.push(e);return t}function zn(e,t,n){e.pendingLanes|=t,t!==536870912&&(e.suspendedLanes=0,e.pingedLanes=0),e=e.eventTimes,t=31-Pe(t),e[t]=n}function wd(e,t){var n=e.pendingLanes&~t;e.pendingLanes=t,e.suspendedLanes=0,e.pingedLanes=0,e.expiredLanes&=t,e.mutableReadLanes&=t,e.entangledLanes&=t,t=e.entanglements;var r=e.eventTimes;for(e=e.expirationTimes;0<n;){var l=31-Pe(n),i=1<<l;t[l]=0,r[l]=-1,e[l]=-1,n&=~i}}function ui(e,t){var n=e.entangledLanes|=t;for(e=e.entanglements;n;){var r=31-Pe(n),l=1<<r;l&t|e[r]&t&&(e[r]|=t),n&=~l}}var A=0;function Hs(e){return e&=-e,1<e?4<e?e&268435455?16:536870912:4:1}var Ws,ci,Qs,Ks,Ys,di=!1,kr=[],lt=null,it=null,ot=null,_n=new Map,Ln=new Map,st=[],kd="mousedown mouseup touchcancel touchend touchstart auxclick dblclick pointercancel pointerdown pointerup dragend dragstart drop compositionend compositionstart keydown keypress keyup input textInput copy cut paste click change contextmenu reset submit".split(" ");function Xs(e,t){switch(e){case"focusin":case"focusout":lt=null;break;case"dragenter":case"dragleave":it=null;break;case"mouseover":case"mouseout":ot=null;break;case"pointerover":case"pointerout":_n.delete(t.pointerId);break;case"gotpointercapture":case"lostpointercapture":Ln.delete(t.pointerId)}}function bn(e,t,n,r,l,i){return e===null||e.nativeEvent!==i?(e={blockedOn:t,domEventName:n,eventSystemFlags:r,nativeEvent:i,targetContainers:[l]},t!==null&&(t=Hn(t),t!==null&&ci(t)),e):(e.eventSystemFlags|=r,t=e.targetContainers,l!==null&&t.indexOf(l)===-1&&t.push(l),e)}function Sd(e,t,n,r,l){switch(t){case"focusin":return lt=bn(lt,e,t,n,r,l),!0;case"dragenter":return it=bn(it,e,t,n,r,l),!0;case"mouseover":return ot=bn(ot,e,t,n,r,l),!0;case"pointerover":var i=l.pointerId;return _n.set(i,bn(_n.get(i)||null,e,t,n,r,l)),!0;case"gotpointercapture":return i=l.pointerId,Ln.set(i,bn(Ln.get(i)||null,e,t,n,r,l)),!0}return!1}function Gs(e){var t=jt(e.target);if(t!==null){var n=Ct(t);if(n!==null){if(t=n.tag,t===13){if(t=Ds(n),t!==null){e.blockedOn=t,Ys(e.priority,function(){Qs(n)});return}}else if(t===3&&n.stateNode.current.memoizedState.isDehydrated){e.blockedOn=n.tag===3?n.stateNode.containerInfo:null;return}}}e.blockedOn=null}function Sr(e){if(e.blockedOn!==null)return!1;for(var t=e.targetContainers;0<t.length;){var n=pi(e.domEventName,e.eventSystemFlags,t[0],e.nativeEvent);if(n===null){n=e.nativeEvent;var r=new n.constructor(n.type,n);ei=r,n.target.dispatchEvent(r),ei=null}else return t=Hn(n),t!==null&&ci(t),e.blockedOn=n,!1;t.shift()}return!0}function Js(e,t,n){Sr(e)&&n.delete(t)}function Cd(){di=!1,lt!==null&&Sr(lt)&&(lt=null),it!==null&&Sr(it)&&(it=null),ot!==null&&Sr(ot)&&(ot=null),_n.forEach(Js),Ln.forEach(Js)}function Tn(e,t){e.blockedOn===t&&(e.blockedOn=null,di||(di=!0,ke.unstable_scheduleCallback(ke.unstable_NormalPriority,Cd)))}function Pn(e){function t(l){return Tn(l,e)}if(0<kr.length){Tn(kr[0],e);for(var n=1;n<kr.length;n++){var r=kr[n];r.blockedOn===e&&(r.blockedOn=null)}}for(lt!==null&&Tn(lt,e),it!==null&&Tn(it,e),ot!==null&&Tn(ot,e),_n.forEach(t),Ln.forEach(t),n=0;n<st.length;n++)r=st[n],r.blockedOn===e&&(r.blockedOn=null);for(;0<st.length&&(n=st[0],n.blockedOn===null);)Gs(n),n.blockedOn===null&&st.shift()}var Qt=We.ReactCurrentBatchConfig,Cr=!0;function jd(e,t,n,r){var l=A,i=Qt.transition;Qt.transition=null;try{A=1,fi(e,t,n,r)}finally{A=l,Qt.transition=i}}function Nd(e,t,n,r){var l=A,i=Qt.transition;Qt.transition=null;try{A=4,fi(e,t,n,r)}finally{A=l,Qt.transition=i}}function fi(e,t,n,r){if(Cr){var l=pi(e,t,n,r);if(l===null)bi(e,t,r,jr,n),Xs(e,r);else if(Sd(l,e,t,n,r))r.stopPropagation();else if(Xs(e,r),t&4&&-1<kd.indexOf(e)){for(;l!==null;){var i=Hn(l);if(i!==null&&Ws(i),i=pi(e,t,n,r),i===null&&bi(e,t,r,jr,n),i===l)break;l=i}l!==null&&r.stopPropagation()}else bi(e,t,r,null,n)}}var jr=null;function pi(e,t,n,r){if(jr=null,e=ti(r),e=jt(e),e!==null)if(t=Ct(e),t===null)e=null;else if(n=t.tag,n===13){if(e=Ds(t),e!==null)return e;e=null}else if(n===3){if(t.stateNode.current.memoizedState.isDehydrated)return t.tag===3?t.stateNode.containerInfo:null;e=null}else t!==e&&(e=null);return jr=e,null}function Zs(e){switch(e){case"cancel":case"click":case"close":case"contextmenu":case"copy":case"cut":case"auxclick":case"dblclick":case"dragend":case"dragstart":case"drop":case"focusin":case"focusout":case"input":case"invalid":case"keydown":case"keypress":case"keyup":case"mousedown":case"mouseup":case"paste":case"pause":case"play":case"pointercancel":case"pointerdown":case"pointerup":case"ratechange":case"reset":case"resize":case"seeked":case"submit":case"touchcancel":case"touchend":case"touchstart":case"volumechange":case"change":case"selectionchange":case"textInput":case"compositionstart":case"compositionend":case"compositionupdate":case"beforeblur":case"afterblur":case"beforeinput":case"blur":case"fullscreenchange":case"focus":case"hashchange":case"popstate":case"select":case"selectstart":return 1;case"drag":case"dragenter":case"dragexit":case"dragleave":case"dragover":case"mousemove":case"mouseout":case"mouseover":case"pointermove":case"pointerout":case"pointerover":case"scroll":case"toggle":case"touchmove":case"wheel":case"mouseenter":case"mouseleave":case"pointerenter":case"pointerleave":return 4;case"message":switch(fd()){case oi:return 1;case Bs:return 4;case gr:case pd:return 16;case Us:return 536870912;default:return 16}default:return 16}}var at=null,hi=null,Nr=null;function qs(){if(Nr)return Nr;var e,t=hi,n=t.length,r,l="value"in at?at.value:at.textContent,i=l.length;for(e=0;e<n&&t[e]===l[e];e++);var o=n-e;for(r=1;r<=o&&t[n-r]===l[i-r];r++);return Nr=l.slice(e,1<r?1-r:void 0)}function Er(e){var t=e.keyCode;return"charCode"in e?(e=e.charCode,e===0&&t===13&&(e=13)):e=t,e===10&&(e=13),32<=e||e===13?e:0}function zr(){return!0}function ea(){return!1}function Se(e){function t(n,r,l,i,o){this._reactName=n,this._targetInst=l,this.type=r,this.nativeEvent=i,this.target=o,this.currentTarget=null;for(var a in e)e.hasOwnProperty(a)&&(n=e[a],this[a]=n?n(i):i[a]);return this.isDefaultPrevented=(i.defaultPrevented!=null?i.defaultPrevented:i.returnValue===!1)?zr:ea,this.isPropagationStopped=ea,this}return W(t.prototype,{preventDefault:function(){this.defaultPrevented=!0;var n=this.nativeEvent;n&&(n.preventDefault?n.preventDefault():typeof n.returnValue!="unknown"&&(n.returnValue=!1),this.isDefaultPrevented=zr)},stopPropagation:function(){var n=this.nativeEvent;n&&(n.stopPropagation?n.stopPropagation():typeof n.cancelBubble!="unknown"&&(n.cancelBubble=!0),this.isPropagationStopped=zr)},persist:function(){},isPersistent:zr}),t}var Kt={eventPhase:0,bubbles:0,cancelable:0,timeStamp:function(e){return e.timeStamp||Date.now()},defaultPrevented:0,isTrusted:0},mi=Se(Kt),Fn=W({},Kt,{view:0,detail:0}),Ed=Se(Fn),gi,vi,Mn,_r=W({},Fn,{screenX:0,screenY:0,clientX:0,clientY:0,pageX:0,pageY:0,ctrlKey:0,shiftKey:0,altKey:0,metaKey:0,getModifierState:yi,button:0,buttons:0,relatedTarget:function(e){return e.relatedTarget===void 0?e.fromElement===e.srcElement?e.toElement:e.fromElement:e.relatedTarget},movementX:function(e){return"movementX"in e?e.movementX:(e!==Mn&&(Mn&&e.type==="mousemove"?(gi=e.screenX-Mn.screenX,vi=e.screenY-Mn.screenY):vi=gi=0,Mn=e),gi)},movementY:function(e){return"movementY"in e?e.movementY:vi}}),ta=Se(_r),zd=W({},_r,{dataTransfer:0}),_d=Se(zd),Ld=W({},Fn,{relatedTarget:0}),xi=Se(Ld),bd=W({},Kt,{animationName:0,elapsedTime:0,pseudoElement:0}),Td=Se(bd),Pd=W({},Kt,{clipboardData:function(e){return"clipboardData"in e?e.clipboardData:window.clipboardData}}),Fd=Se(Pd),Md=W({},Kt,{data:0}),na=Se(Md),Dd={Esc:"Escape",Spacebar:" ",Left:"ArrowLeft",Up:"ArrowUp",Right:"ArrowRight",Down:"ArrowDown",Del:"Delete",Win:"OS",Menu:"ContextMenu",Apps:"ContextMenu",Scroll:"ScrollLock",MozPrintableKey:"Unidentified"},Id={8:"Backspace",9:"Tab",12:"Clear",13:"Enter",16:"Shift",17:"Control",18:"Alt",19:"Pause",20:"CapsLock",27:"Escape",32:" ",33:"PageUp",34:"PageDown",35:"End",36:"Home",37:"ArrowLeft",38:"ArrowUp",39:"ArrowRight",40:"ArrowDown",45:"Insert",46:"Delete",112:"F1",113:"F2",114:"F3",115:"F4",116:"F5",117:"F6",118:"F7",119:"F8",120:"F9",121:"F10",122:"F11",123:"F12",144:"NumLock",145:"ScrollLock",224:"Meta"},Rd={Alt:"altKey",Control:"ctrlKey",Meta:"metaKey",Shift:"shiftKey"};function Od(e){var t=this.nativeEvent;return t.getModifierState?t.getModifierState(e):(e=Rd[e])?!!t[e]:!1}function yi(){return Od}var Ad=W({},Fn,{key:function(e){if(e.key){var t=Dd[e.key]||e.key;if(t!=="Unidentified")return t}return e.type==="keypress"?(e=Er(e),e===13?"Enter":String.fromCharCode(e)):e.type==="keydown"||e.type==="keyup"?Id[e.keyCode]||"Unidentified":""},code:0,location:0,ctrlKey:0,shiftKey:0,altKey:0,metaKey:0,repeat:0,locale:0,getModifierState:yi,charCode:function(e){return e.type==="keypress"?Er(e):0},keyCode:function(e){return e.type==="keydown"||e.type==="keyup"?e.keyCode:0},which:function(e){return e.type==="keypress"?Er(e):e.type==="keydown"||e.type==="keyup"?e.keyCode:0}}),$d=Se(Ad),Bd=W({},_r,{pointerId:0,width:0,height:0,pressure:0,tangentialPressure:0,tiltX:0,tiltY:0,twist:0,pointerType:0,isPrimary:0}),ra=Se(Bd),Ud=W({},Fn,{touches:0,targetTouches:0,changedTouches:0,altKey:0,metaKey:0,ctrlKey:0,shiftKey:0,getModifierState:yi}),Vd=Se(Ud),Hd=W({},Kt,{propertyName:0,elapsedTime:0,pseudoElement:0}),Wd=Se(Hd),Qd=W({},_r,{deltaX:function(e){return"deltaX"in e?e.deltaX:"wheelDeltaX"in e?-e.wheelDeltaX:0},deltaY:function(e){return"deltaY"in e?e.deltaY:"wheelDeltaY"in e?-e.wheelDeltaY:"wheelDelta"in e?-e.wheelDelta:0},deltaZ:0,deltaMode:0}),Kd=Se(Qd),Yd=[9,13,27,32],wi=He&&"CompositionEvent"in window,Dn=null;He&&"documentMode"in document&&(Dn=document.documentMode);var Xd=He&&"TextEvent"in window&&!Dn,la=He&&(!wi||Dn&&8<Dn&&11>=Dn),ia=" ",oa=!1;function sa(e,t){switch(e){case"keyup":return Yd.indexOf(t.keyCode)!==-1;case"keydown":return t.keyCode!==229;case"keypress":case"mousedown":case"focusout":return!0;default:return!1}}function aa(e){return e=e.detail,typeof e=="object"&&"data"in e?e.data:null}var Yt=!1;function Gd(e,t){switch(e){case"compositionend":return aa(t);case"keypress":return t.which!==32?null:(oa=!0,ia);case"textInput":return e=t.data,e===ia&&oa?null:e;default:return null}}function Jd(e,t){if(Yt)return e==="compositionend"||!wi&&sa(e,t)?(e=qs(),Nr=hi=at=null,Yt=!1,e):null;switch(e){case"paste":return null;case"keypress":if(!(t.ctrlKey||t.altKey||t.metaKey)||t.ctrlKey&&t.altKey){if(t.char&&1<t.char.length)return t.char;if(t.which)return String.fromCharCode(t.which)}return null;case"compositionend":return la&&t.locale!=="ko"?null:t.data;default:return null}}var Zd={color:!0,date:!0,datetime:!0,"datetime-local":!0,email:!0,month:!0,number:!0,password:!0,range:!0,search:!0,tel:!0,text:!0,time:!0,url:!0,week:!0};function ua(e){var t=e&&e.nodeName&&e.nodeName.toLowerCase();return t==="input"?!!Zd[e.type]:t==="textarea"}function ca(e,t,n,r){bs(r),t=Fr(t,"onChange"),0<t.length&&(n=new mi("onChange","change",null,n,r),e.push({event:n,listeners:t}))}var In=null,Rn=null;function qd(e){_a(e,0)}function Lr(e){var t=qt(e);if(xs(t))return e}function ef(e,t){if(e==="change")return t}var da=!1;if(He){var ki;if(He){var Si="oninput"in document;if(!Si){var fa=document.createElement("div");fa.setAttribute("oninput","return;"),Si=typeof fa.oninput=="function"}ki=Si}else ki=!1;da=ki&&(!document.documentMode||9<document.documentMode)}function pa(){In&&(In.detachEvent("onpropertychange",ha),Rn=In=null)}function ha(e){if(e.propertyName==="value"&&Lr(Rn)){var t=[];ca(t,Rn,e,ti(e)),Ms(qd,t)}}function tf(e,t,n){e==="focusin"?(pa(),In=t,Rn=n,In.attachEvent("onpropertychange",ha)):e==="focusout"&&pa()}function nf(e){if(e==="selectionchange"||e==="keyup"||e==="keydown")return Lr(Rn)}function rf(e,t){if(e==="click")return Lr(t)}function lf(e,t){if(e==="input"||e==="change")return Lr(t)}function of(e,t){return e===t&&(e!==0||1/e===1/t)||e!==e&&t!==t}var Fe=typeof Object.is=="function"?Object.is:of;function On(e,t){if(Fe(e,t))return!0;if(typeof e!="object"||e===null||typeof t!="object"||t===null)return!1;var n=Object.keys(e),r=Object.keys(t);if(n.length!==r.length)return!1;for(r=0;r<n.length;r++){var l=n[r];if(!Fl.call(t,l)||!Fe(e[l],t[l]))return!1}return!0}function ma(e){for(;e&&e.firstChild;)e=e.firstChild;return e}function ga(e,t){var n=ma(e);e=0;for(var r;n;){if(n.nodeType===3){if(r=e+n.textContent.length,e<=t&&r>=t)return{node:n,offset:t-e};e=r}e:{for(;n;){if(n.nextSibling){n=n.nextSibling;break e}n=n.parentNode}n=void 0}n=ma(n)}}function va(e,t){return e&&t?e===t?!0:e&&e.nodeType===3?!1:t&&t.nodeType===3?va(e,t.parentNode):"contains"in e?e.contains(t):e.compareDocumentPosition?!!(e.compareDocumentPosition(t)&16):!1:!1}function xa(){for(var e=window,t=fr();t instanceof e.HTMLIFrameElement;){try{var n=typeof t.contentWindow.location.href=="string"}catch{n=!1}if(n)e=t.contentWindow;else break;t=fr(e.document)}return t}function Ci(e){var t=e&&e.nodeName&&e.nodeName.toLowerCase();return t&&(t==="input"&&(e.type==="text"||e.type==="search"||e.type==="tel"||e.type==="url"||e.type==="password")||t==="textarea"||e.contentEditable==="true")}function sf(e){var t=xa(),n=e.focusedElem,r=e.selectionRange;if(t!==n&&n&&n.ownerDocument&&va(n.ownerDocument.documentElement,n)){if(r!==null&&Ci(n)){if(t=r.start,e=r.end,e===void 0&&(e=t),"selectionStart"in n)n.selectionStart=t,n.selectionEnd=Math.min(e,n.value.length);else if(e=(t=n.ownerDocument||document)&&t.defaultView||window,e.getSelection){e=e.getSelection();var l=n.textContent.length,i=Math.min(r.start,l);r=r.end===void 0?i:Math.min(r.end,l),!e.extend&&i>r&&(l=r,r=i,i=l),l=ga(n,i);var o=ga(n,r);l&&o&&(e.rangeCount!==1||e.anchorNode!==l.node||e.anchorOffset!==l.offset||e.focusNode!==o.node||e.focusOffset!==o.offset)&&(t=t.createRange(),t.setStart(l.node,l.offset),e.removeAllRanges(),i>r?(e.addRange(t),e.extend(o.node,o.offset)):(t.setEnd(o.node,o.offset),e.addRange(t)))}}for(t=[],e=n;e=e.parentNode;)e.nodeType===1&&t.push({element:e,left:e.scrollLeft,top:e.scrollTop});for(typeof n.focus=="function"&&n.focus(),n=0;n<t.length;n++)e=t[n],e.element.scrollLeft=e.left,e.element.scrollTop=e.top}}var af=He&&"documentMode"in document&&11>=document.documentMode,Xt=null,ji=null,An=null,Ni=!1;function ya(e,t,n){var r=n.window===n?n.document:n.nodeType===9?n:n.ownerDocument;Ni||Xt==null||Xt!==fr(r)||(r=Xt,"selectionStart"in r&&Ci(r)?r={start:r.selectionStart,end:r.selectionEnd}:(r=(r.ownerDocument&&r.ownerDocument.defaultView||window).getSelection(),r={anchorNode:r.anchorNode,anchorOffset:r.anchorOffset,focusNode:r.focusNode,focusOffset:r.focusOffset}),An&&On(An,r)||(An=r,r=Fr(ji,"onSelect"),0<r.length&&(t=new mi("onSelect","select",null,t,n),e.push({event:t,listeners:r}),t.target=Xt)))}function br(e,t){var n={};return n[e.toLowerCase()]=t.toLowerCase(),n["Webkit"+e]="webkit"+t,n["Moz"+e]="moz"+t,n}var Gt={animationend:br("Animation","AnimationEnd"),animationiteration:br("Animation","AnimationIteration"),animationstart:br("Animation","AnimationStart"),transitionend:br("Transition","TransitionEnd")},Ei={},wa={};He&&(wa=document.createElement("div").style,"AnimationEvent"in window||(delete Gt.animationend.animation,delete Gt.animationiteration.animation,delete Gt.animationstart.animation),"TransitionEvent"in window||delete Gt.transitionend.transition);function Tr(e){if(Ei[e])return Ei[e];if(!Gt[e])return e;var t=Gt[e],n;for(n in t)if(t.hasOwnProperty(n)&&n in wa)return Ei[e]=t[n];return e}var ka=Tr("animationend"),Sa=Tr("animationiteration"),Ca=Tr("animationstart"),ja=Tr("transitionend"),Na=new Map,Ea="abort auxClick cancel canPlay canPlayThrough click close contextMenu copy cut drag dragEnd dragEnter dragExit dragLeave dragOver dragStart drop durationChange emptied encrypted ended error gotPointerCapture input invalid keyDown keyPress keyUp load loadedData loadedMetadata loadStart lostPointerCapture mouseDown mouseMove mouseOut mouseOver mouseUp paste pause play playing pointerCancel pointerDown pointerMove pointerOut pointerOver pointerUp progress rateChange reset resize seeked seeking stalled submit suspend timeUpdate touchCancel touchEnd touchStart volumeChange scroll toggle touchMove waiting wheel".split(" ");function ut(e,t){Na.set(e,t),St(t,[e])}for(var zi=0;zi<Ea.length;zi++){var _i=Ea[zi],uf=_i.toLowerCase(),cf=_i[0].toUpperCase()+_i.slice(1);ut(uf,"on"+cf)}ut(ka,"onAnimationEnd"),ut(Sa,"onAnimationIteration"),ut(Ca,"onAnimationStart"),ut("dblclick","onDoubleClick"),ut("focusin","onFocus"),ut("focusout","onBlur"),ut(ja,"onTransitionEnd"),$t("onMouseEnter",["mouseout","mouseover"]),$t("onMouseLeave",["mouseout","mouseover"]),$t("onPointerEnter",["pointerout","pointerover"]),$t("onPointerLeave",["pointerout","pointerover"]),St("onChange","change click focusin focusout input keydown keyup selectionchange".split(" ")),St("onSelect","focusout contextmenu dragend focusin keydown keyup mousedown mouseup selectionchange".split(" ")),St("onBeforeInput",["compositionend","keypress","textInput","paste"]),St("onCompositionEnd","compositionend focusout keydown keypress keyup mousedown".split(" ")),St("onCompositionStart","compositionstart focusout keydown keypress keyup mousedown".split(" ")),St("onCompositionUpdate","compositionupdate focusout keydown keypress keyup mousedown".split(" "));var $n="abort canplay canplaythrough durationchange emptied encrypted ended error loadeddata loadedmetadata loadstart pause play playing progress ratechange resize seeked seeking stalled suspend timeupdate volumechange waiting".split(" "),df=new Set("cancel close invalid load scroll toggle".split(" ").concat($n));function za(e,t,n){var r=e.type||"unknown-event";e.currentTarget=n,ad(r,t,void 0,e),e.currentTarget=null}function _a(e,t){t=(t&4)!==0;for(var n=0;n<e.length;n++){var r=e[n],l=r.event;r=r.listeners;e:{var i=void 0;if(t)for(var o=r.length-1;0<=o;o--){var a=r[o],u=a.instance,f=a.currentTarget;if(a=a.listener,u!==i&&l.isPropagationStopped())break e;za(l,a,f),i=u}else for(o=0;o<r.length;o++){if(a=r[o],u=a.instance,f=a.currentTarget,a=a.listener,u!==i&&l.isPropagationStopped())break e;za(l,a,f),i=u}}}if(mr)throw e=ii,mr=!1,ii=null,e}function U(e,t){var n=t[Ii];n===void 0&&(n=t[Ii]=new Set);var r=e+"__bubble";n.has(r)||(La(t,e,2,!1),n.add(r))}function Li(e,t,n){var r=0;t&&(r|=4),La(n,e,r,t)}var Pr="_reactListening"+Math.random().toString(36).slice(2);function Bn(e){if(!e[Pr]){e[Pr]=!0,cs.forEach(function(n){n!=="selectionchange"&&(df.has(n)||Li(n,!1,e),Li(n,!0,e))});var t=e.nodeType===9?e:e.ownerDocument;t===null||t[Pr]||(t[Pr]=!0,Li("selectionchange",!1,t))}}function La(e,t,n,r){switch(Zs(t)){case 1:var l=jd;break;case 4:l=Nd;break;default:l=fi}n=l.bind(null,t,n,e),l=void 0,!li||t!=="touchstart"&&t!=="touchmove"&&t!=="wheel"||(l=!0),r?l!==void 0?e.addEventListener(t,n,{capture:!0,passive:l}):e.addEventListener(t,n,!0):l!==void 0?e.addEventListener(t,n,{passive:l}):e.addEventListener(t,n,!1)}function bi(e,t,n,r,l){var i=r;if(!(t&1)&&!(t&2)&&r!==null)e:for(;;){if(r===null)return;var o=r.tag;if(o===3||o===4){var a=r.stateNode.containerInfo;if(a===l||a.nodeType===8&&a.parentNode===l)break;if(o===4)for(o=r.return;o!==null;){var u=o.tag;if((u===3||u===4)&&(u=o.stateNode.containerInfo,u===l||u.nodeType===8&&u.parentNode===l))return;o=o.return}for(;a!==null;){if(o=jt(a),o===null)return;if(u=o.tag,u===5||u===6){r=i=o;continue e}a=a.parentNode}}r=r.return}Ms(function(){var f=i,v=ti(n),g=[];e:{var m=Na.get(e);if(m!==void 0){var y=mi,C=e;switch(e){case"keypress":if(Er(n)===0)break e;case"keydown":case"keyup":y=$d;break;case"focusin":C="focus",y=xi;break;case"focusout":C="blur",y=xi;break;case"beforeblur":case"afterblur":y=xi;break;case"click":if(n.button===2)break e;case"auxclick":case"dblclick":case"mousedown":case"mousemove":case"mouseup":case"mouseout":case"mouseover":case"contextmenu":y=ta;break;case"drag":case"dragend":case"dragenter":case"dragexit":case"dragleave":case"dragover":case"dragstart":case"drop":y=_d;break;case"touchcancel":case"touchend":case"touchmove":case"touchstart":y=Vd;break;case ka:case Sa:case Ca:y=Td;break;case ja:y=Wd;break;case"scroll":y=Ed;break;case"wheel":y=Kd;break;case"copy":case"cut":case"paste":y=Fd;break;case"gotpointercapture":case"lostpointercapture":case"pointercancel":case"pointerdown":case"pointermove":case"pointerout":case"pointerover":case"pointerup":y=ra}var S=(t&4)!==0,_=!S&&e==="scroll",d=S?m!==null?m+"Capture":null:m;S=[];for(var c=f,p;c!==null;){p=c;var h=p.stateNode;if(p.tag===5&&h!==null&&(p=h,d!==null&&(h=Cn(c,d),h!=null&&S.push(Un(c,h,p)))),_)break;c=c.return}0<S.length&&(m=new y(m,C,null,n,v),g.push({event:m,listeners:S}))}}if(!(t&7)){e:{if(m=e==="mouseover"||e==="pointerover",y=e==="mouseout"||e==="pointerout",m&&n!==ei&&(C=n.relatedTarget||n.fromElement)&&(jt(C)||C[Qe]))break e;if((y||m)&&(m=v.window===v?v:(m=v.ownerDocument)?m.defaultView||m.parentWindow:window,y?(C=n.relatedTarget||n.toElement,y=f,C=C?jt(C):null,C!==null&&(_=Ct(C),C!==_||C.tag!==5&&C.tag!==6)&&(C=null)):(y=null,C=f),y!==C)){if(S=ta,h="onMouseLeave",d="onMouseEnter",c="mouse",(e==="pointerout"||e==="pointerover")&&(S=ra,h="onPointerLeave",d="onPointerEnter",c="pointer"),_=y==null?m:qt(y),p=C==null?m:qt(C),m=new S(h,c+"leave",y,n,v),m.target=_,m.relatedTarget=p,h=null,jt(v)===f&&(S=new S(d,c+"enter",C,n,v),S.target=p,S.relatedTarget=_,h=S),_=h,y&&C)t:{for(S=y,d=C,c=0,p=S;p;p=Jt(p))c++;for(p=0,h=d;h;h=Jt(h))p++;for(;0<c-p;)S=Jt(S),c--;for(;0<p-c;)d=Jt(d),p--;for(;c--;){if(S===d||d!==null&&S===d.alternate)break t;S=Jt(S),d=Jt(d)}S=null}else S=null;y!==null&&ba(g,m,y,S,!1),C!==null&&_!==null&&ba(g,_,C,S,!0)}}e:{if(m=f?qt(f):window,y=m.nodeName&&m.nodeName.toLowerCase(),y==="select"||y==="input"&&m.type==="file")var j=ef;else if(ua(m))if(da)j=lf;else{j=nf;var N=tf}else(y=m.nodeName)&&y.toLowerCase()==="input"&&(m.type==="checkbox"||m.type==="radio")&&(j=rf);if(j&&(j=j(e,f))){ca(g,j,n,v);break e}N&&N(e,m,f),e==="focusout"&&(N=m._wrapperState)&&N.controlled&&m.type==="number"&&Xl(m,"number",m.value)}switch(N=f?qt(f):window,e){case"focusin":(ua(N)||N.contentEditable==="true")&&(Xt=N,ji=f,An=null);break;case"focusout":An=ji=Xt=null;break;case"mousedown":Ni=!0;break;case"contextmenu":case"mouseup":case"dragend":Ni=!1,ya(g,n,v);break;case"selectionchange":if(af)break;case"keydown":case"keyup":ya(g,n,v)}var w;if(wi)e:{switch(e){case"compositionstart":var L="onCompositionStart";break e;case"compositionend":L="onCompositionEnd";break e;case"compositionupdate":L="onCompositionUpdate";break e}L=void 0}else Yt?sa(e,n)&&(L="onCompositionEnd"):e==="keydown"&&n.keyCode===229&&(L="onCompositionStart");L&&(la&&n.locale!=="ko"&&(Yt||L!=="onCompositionStart"?L==="onCompositionEnd"&&Yt&&(w=qs()):(at=v,hi="value"in at?at.value:at.textContent,Yt=!0)),N=Fr(f,L),0<N.length&&(L=new na(L,e,null,n,v),g.push({event:L,listeners:N}),w?L.data=w:(w=aa(n),w!==null&&(L.data=w)))),(w=Xd?Gd(e,n):Jd(e,n))&&(f=Fr(f,"onBeforeInput"),0<f.length&&(v=new na("onBeforeInput","beforeinput",null,n,v),g.push({event:v,listeners:f}),v.data=w))}_a(g,t)})}function Un(e,t,n){return{instance:e,listener:t,currentTarget:n}}function Fr(e,t){for(var n=t+"Capture",r=[];e!==null;){var l=e,i=l.stateNode;l.tag===5&&i!==null&&(l=i,i=Cn(e,n),i!=null&&r.unshift(Un(e,i,l)),i=Cn(e,t),i!=null&&r.push(Un(e,i,l))),e=e.return}return r}function Jt(e){if(e===null)return null;do e=e.return;while(e&&e.tag!==5);return e||null}function ba(e,t,n,r,l){for(var i=t._reactName,o=[];n!==null&&n!==r;){var a=n,u=a.alternate,f=a.stateNode;if(u!==null&&u===r)break;a.tag===5&&f!==null&&(a=f,l?(u=Cn(n,i),u!=null&&o.unshift(Un(n,u,a))):l||(u=Cn(n,i),u!=null&&o.push(Un(n,u,a)))),n=n.return}o.length!==0&&e.push({event:t,listeners:o})}var ff=/\r\n?/g,pf=/\u0000|\uFFFD/g;function Ta(e){return(typeof e=="string"?e:""+e).replace(ff,`
`).replace(pf,"")}function Mr(e,t,n){if(t=Ta(t),Ta(e)!==t&&n)throw Error(k(425))}function Dr(){}var Ti=null,Pi=null;function Fi(e,t){return e==="textarea"||e==="noscript"||typeof t.children=="string"||typeof t.children=="number"||typeof t.dangerouslySetInnerHTML=="object"&&t.dangerouslySetInnerHTML!==null&&t.dangerouslySetInnerHTML.__html!=null}var Mi=typeof setTimeout=="function"?setTimeout:void 0,hf=typeof clearTimeout=="function"?clearTimeout:void 0,Pa=typeof Promise=="function"?Promise:void 0,mf=typeof queueMicrotask=="function"?queueMicrotask:typeof Pa<"u"?function(e){return Pa.resolve(null).then(e).catch(gf)}:Mi;function gf(e){setTimeout(function(){throw e})}function Di(e,t){var n=t,r=0;do{var l=n.nextSibling;if(e.removeChild(n),l&&l.nodeType===8)if(n=l.data,n==="/$"){if(r===0){e.removeChild(l),Pn(t);return}r--}else n!=="$"&&n!=="$?"&&n!=="$!"||r++;n=l}while(n);Pn(t)}function ct(e){for(;e!=null;e=e.nextSibling){var t=e.nodeType;if(t===1||t===3)break;if(t===8){if(t=e.data,t==="$"||t==="$!"||t==="$?")break;if(t==="/$")return null}}return e}function Fa(e){e=e.previousSibling;for(var t=0;e;){if(e.nodeType===8){var n=e.data;if(n==="$"||n==="$!"||n==="$?"){if(t===0)return e;t--}else n==="/$"&&t++}e=e.previousSibling}return null}var Zt=Math.random().toString(36).slice(2),$e="__reactFiber$"+Zt,Vn="__reactProps$"+Zt,Qe="__reactContainer$"+Zt,Ii="__reactEvents$"+Zt,vf="__reactListeners$"+Zt,xf="__reactHandles$"+Zt;function jt(e){var t=e[$e];if(t)return t;for(var n=e.parentNode;n;){if(t=n[Qe]||n[$e]){if(n=t.alternate,t.child!==null||n!==null&&n.child!==null)for(e=Fa(e);e!==null;){if(n=e[$e])return n;e=Fa(e)}return t}e=n,n=e.parentNode}return null}function Hn(e){return e=e[$e]||e[Qe],!e||e.tag!==5&&e.tag!==6&&e.tag!==13&&e.tag!==3?null:e}function qt(e){if(e.tag===5||e.tag===6)return e.stateNode;throw Error(k(33))}function Ir(e){return e[Vn]||null}var Ri=[],en=-1;function dt(e){return{current:e}}function V(e){0>en||(e.current=Ri[en],Ri[en]=null,en--)}function B(e,t){en++,Ri[en]=e.current,e.current=t}var ft={},oe=dt(ft),he=dt(!1),Nt=ft;function tn(e,t){var n=e.type.contextTypes;if(!n)return ft;var r=e.stateNode;if(r&&r.__reactInternalMemoizedUnmaskedChildContext===t)return r.__reactInternalMemoizedMaskedChildContext;var l={},i;for(i in n)l[i]=t[i];return r&&(e=e.stateNode,e.__reactInternalMemoizedUnmaskedChildContext=t,e.__reactInternalMemoizedMaskedChildContext=l),l}function me(e){return e=e.childContextTypes,e!=null}function Rr(){V(he),V(oe)}function Ma(e,t,n){if(oe.current!==ft)throw Error(k(168));B(oe,t),B(he,n)}function Da(e,t,n){var r=e.stateNode;if(t=t.childContextTypes,typeof r.getChildContext!="function")return n;r=r.getChildContext();for(var l in r)if(!(l in t))throw Error(k(108,td(e)||"Unknown",l));return W({},n,r)}function Or(e){return e=(e=e.stateNode)&&e.__reactInternalMemoizedMergedChildContext||ft,Nt=oe.current,B(oe,e),B(he,he.current),!0}function Ia(e,t,n){var r=e.stateNode;if(!r)throw Error(k(169));n?(e=Da(e,t,Nt),r.__reactInternalMemoizedMergedChildContext=e,V(he),V(oe),B(oe,e)):V(he),B(he,n)}var Ke=null,Ar=!1,Oi=!1;function Ra(e){Ke===null?Ke=[e]:Ke.push(e)}function yf(e){Ar=!0,Ra(e)}function pt(){if(!Oi&&Ke!==null){Oi=!0;var e=0,t=A;try{var n=Ke;for(A=1;e<n.length;e++){var r=n[e];do r=r(!0);while(r!==null)}Ke=null,Ar=!1}catch(l){throw Ke!==null&&(Ke=Ke.slice(e+1)),As(oi,pt),l}finally{A=t,Oi=!1}}return null}var nn=[],rn=0,$r=null,Br=0,Ee=[],ze=0,Et=null,Ye=1,Xe="";function zt(e,t){nn[rn++]=Br,nn[rn++]=$r,$r=e,Br=t}function Oa(e,t,n){Ee[ze++]=Ye,Ee[ze++]=Xe,Ee[ze++]=Et,Et=e;var r=Ye;e=Xe;var l=32-Pe(r)-1;r&=~(1<<l),n+=1;var i=32-Pe(t)+l;if(30<i){var o=l-l%5;i=(r&(1<<o)-1).toString(32),r>>=o,l-=o,Ye=1<<32-Pe(t)+l|n<<l|r,Xe=i+e}else Ye=1<<i|n<<l|r,Xe=e}function Ai(e){e.return!==null&&(zt(e,1),Oa(e,1,0))}function $i(e){for(;e===$r;)$r=nn[--rn],nn[rn]=null,Br=nn[--rn],nn[rn]=null;for(;e===Et;)Et=Ee[--ze],Ee[ze]=null,Xe=Ee[--ze],Ee[ze]=null,Ye=Ee[--ze],Ee[ze]=null}var Ce=null,je=null,H=!1,Me=null;function Aa(e,t){var n=Te(5,null,null,0);n.elementType="DELETED",n.stateNode=t,n.return=e,t=e.deletions,t===null?(e.deletions=[n],e.flags|=16):t.push(n)}function $a(e,t){switch(e.tag){case 5:var n=e.type;return t=t.nodeType!==1||n.toLowerCase()!==t.nodeName.toLowerCase()?null:t,t!==null?(e.stateNode=t,Ce=e,je=ct(t.firstChild),!0):!1;case 6:return t=e.pendingProps===""||t.nodeType!==3?null:t,t!==null?(e.stateNode=t,Ce=e,je=null,!0):!1;case 13:return t=t.nodeType!==8?null:t,t!==null?(n=Et!==null?{id:Ye,overflow:Xe}:null,e.memoizedState={dehydrated:t,treeContext:n,retryLane:1073741824},n=Te(18,null,null,0),n.stateNode=t,n.return=e,e.child=n,Ce=e,je=null,!0):!1;default:return!1}}function Bi(e){return(e.mode&1)!==0&&(e.flags&128)===0}function Ui(e){if(H){var t=je;if(t){var n=t;if(!$a(e,t)){if(Bi(e))throw Error(k(418));t=ct(n.nextSibling);var r=Ce;t&&$a(e,t)?Aa(r,n):(e.flags=e.flags&-4097|2,H=!1,Ce=e)}}else{if(Bi(e))throw Error(k(418));e.flags=e.flags&-4097|2,H=!1,Ce=e}}}function Ba(e){for(e=e.return;e!==null&&e.tag!==5&&e.tag!==3&&e.tag!==13;)e=e.return;Ce=e}function Ur(e){if(e!==Ce)return!1;if(!H)return Ba(e),H=!0,!1;var t;if((t=e.tag!==3)&&!(t=e.tag!==5)&&(t=e.type,t=t!=="head"&&t!=="body"&&!Fi(e.type,e.memoizedProps)),t&&(t=je)){if(Bi(e))throw Ua(),Error(k(418));for(;t;)Aa(e,t),t=ct(t.nextSibling)}if(Ba(e),e.tag===13){if(e=e.memoizedState,e=e!==null?e.dehydrated:null,!e)throw Error(k(317));e:{for(e=e.nextSibling,t=0;e;){if(e.nodeType===8){var n=e.data;if(n==="/$"){if(t===0){je=ct(e.nextSibling);break e}t--}else n!=="$"&&n!=="$!"&&n!=="$?"||t++}e=e.nextSibling}je=null}}else je=Ce?ct(e.stateNode.nextSibling):null;return!0}function Ua(){for(var e=je;e;)e=ct(e.nextSibling)}function ln(){je=Ce=null,H=!1}function Vi(e){Me===null?Me=[e]:Me.push(e)}var wf=We.ReactCurrentBatchConfig;function De(e,t){if(e&&e.defaultProps){t=W({},t),e=e.defaultProps;for(var n in e)t[n]===void 0&&(t[n]=e[n]);return t}return t}var Vr=dt(null),Hr=null,on=null,Hi=null;function Wi(){Hi=on=Hr=null}function Qi(e){var t=Vr.current;V(Vr),e._currentValue=t}function Ki(e,t,n){for(;e!==null;){var r=e.alternate;if((e.childLanes&t)!==t?(e.childLanes|=t,r!==null&&(r.childLanes|=t)):r!==null&&(r.childLanes&t)!==t&&(r.childLanes|=t),e===n)break;e=e.return}}function sn(e,t){Hr=e,Hi=on=null,e=e.dependencies,e!==null&&e.firstContext!==null&&(e.lanes&t&&(ge=!0),e.firstContext=null)}function _e(e){var t=e._currentValue;if(Hi!==e)if(e={context:e,memoizedValue:t,next:null},on===null){if(Hr===null)throw Error(k(308));on=e,Hr.dependencies={lanes:0,firstContext:e}}else on=on.next=e;return t}var _t=null;function Yi(e){_t===null?_t=[e]:_t.push(e)}function Va(e,t,n,r){var l=t.interleaved;return l===null?(n.next=n,Yi(t)):(n.next=l.next,l.next=n),t.interleaved=n,Ge(e,r)}function Ge(e,t){e.lanes|=t;var n=e.alternate;for(n!==null&&(n.lanes|=t),n=e,e=e.return;e!==null;)e.childLanes|=t,n=e.alternate,n!==null&&(n.childLanes|=t),n=e,e=e.return;return n.tag===3?n.stateNode:null}var ht=!1;function Xi(e){e.updateQueue={baseState:e.memoizedState,firstBaseUpdate:null,lastBaseUpdate:null,shared:{pending:null,interleaved:null,lanes:0},effects:null}}function Ha(e,t){e=e.updateQueue,t.updateQueue===e&&(t.updateQueue={baseState:e.baseState,firstBaseUpdate:e.firstBaseUpdate,lastBaseUpdate:e.lastBaseUpdate,shared:e.shared,effects:e.effects})}function Je(e,t){return{eventTime:e,lane:t,tag:0,payload:null,callback:null,next:null}}function mt(e,t,n){var r=e.updateQueue;if(r===null)return null;if(r=r.shared,R&2){var l=r.pending;return l===null?t.next=t:(t.next=l.next,l.next=t),r.pending=t,Ge(e,n)}return l=r.interleaved,l===null?(t.next=t,Yi(r)):(t.next=l.next,l.next=t),r.interleaved=t,Ge(e,n)}function Wr(e,t,n){if(t=t.updateQueue,t!==null&&(t=t.shared,(n&4194240)!==0)){var r=t.lanes;r&=e.pendingLanes,n|=r,t.lanes=n,ui(e,n)}}function Wa(e,t){var n=e.updateQueue,r=e.alternate;if(r!==null&&(r=r.updateQueue,n===r)){var l=null,i=null;if(n=n.firstBaseUpdate,n!==null){do{var o={eventTime:n.eventTime,lane:n.lane,tag:n.tag,payload:n.payload,callback:n.callback,next:null};i===null?l=i=o:i=i.next=o,n=n.next}while(n!==null);i===null?l=i=t:i=i.next=t}else l=i=t;n={baseState:r.baseState,firstBaseUpdate:l,lastBaseUpdate:i,shared:r.shared,effects:r.effects},e.updateQueue=n;return}e=n.lastBaseUpdate,e===null?n.firstBaseUpdate=t:e.next=t,n.lastBaseUpdate=t}function Qr(e,t,n,r){var l=e.updateQueue;ht=!1;var i=l.firstBaseUpdate,o=l.lastBaseUpdate,a=l.shared.pending;if(a!==null){l.shared.pending=null;var u=a,f=u.next;u.next=null,o===null?i=f:o.next=f,o=u;var v=e.alternate;v!==null&&(v=v.updateQueue,a=v.lastBaseUpdate,a!==o&&(a===null?v.firstBaseUpdate=f:a.next=f,v.lastBaseUpdate=u))}if(i!==null){var g=l.baseState;o=0,v=f=u=null,a=i;do{var m=a.lane,y=a.eventTime;if((r&m)===m){v!==null&&(v=v.next={eventTime:y,lane:0,tag:a.tag,payload:a.payload,callback:a.callback,next:null});e:{var C=e,S=a;switch(m=t,y=n,S.tag){case 1:if(C=S.payload,typeof C=="function"){g=C.call(y,g,m);break e}g=C;break e;case 3:C.flags=C.flags&-65537|128;case 0:if(C=S.payload,m=typeof C=="function"?C.call(y,g,m):C,m==null)break e;g=W({},g,m);break e;case 2:ht=!0}}a.callback!==null&&a.lane!==0&&(e.flags|=64,m=l.effects,m===null?l.effects=[a]:m.push(a))}else y={eventTime:y,lane:m,tag:a.tag,payload:a.payload,callback:a.callback,next:null},v===null?(f=v=y,u=g):v=v.next=y,o|=m;if(a=a.next,a===null){if(a=l.shared.pending,a===null)break;m=a,a=m.next,m.next=null,l.lastBaseUpdate=m,l.shared.pending=null}}while(!0);if(v===null&&(u=g),l.baseState=u,l.firstBaseUpdate=f,l.lastBaseUpdate=v,t=l.shared.interleaved,t!==null){l=t;do o|=l.lane,l=l.next;while(l!==t)}else i===null&&(l.shared.lanes=0);Tt|=o,e.lanes=o,e.memoizedState=g}}function Qa(e,t,n){if(e=t.effects,t.effects=null,e!==null)for(t=0;t<e.length;t++){var r=e[t],l=r.callback;if(l!==null){if(r.callback=null,r=n,typeof l!="function")throw Error(k(191,l));l.call(r)}}}var Ka=new us.Component().refs;function Gi(e,t,n,r){t=e.memoizedState,n=n(r,t),n=n==null?t:W({},t,n),e.memoizedState=n,e.lanes===0&&(e.updateQueue.baseState=n)}var Kr={isMounted:function(e){return(e=e._reactInternals)?Ct(e)===e:!1},enqueueSetState:function(e,t,n){e=e._reactInternals;var r=pe(),l=yt(e),i=Je(r,l);i.payload=t,n!=null&&(i.callback=n),t=mt(e,i,l),t!==null&&(Oe(t,e,l,r),Wr(t,e,l))},enqueueReplaceState:function(e,t,n){e=e._reactInternals;var r=pe(),l=yt(e),i=Je(r,l);i.tag=1,i.payload=t,n!=null&&(i.callback=n),t=mt(e,i,l),t!==null&&(Oe(t,e,l,r),Wr(t,e,l))},enqueueForceUpdate:function(e,t){e=e._reactInternals;var n=pe(),r=yt(e),l=Je(n,r);l.tag=2,t!=null&&(l.callback=t),t=mt(e,l,r),t!==null&&(Oe(t,e,r,n),Wr(t,e,r))}};function Ya(e,t,n,r,l,i,o){return e=e.stateNode,typeof e.shouldComponentUpdate=="function"?e.shouldComponentUpdate(r,i,o):t.prototype&&t.prototype.isPureReactComponent?!On(n,r)||!On(l,i):!0}function Xa(e,t,n){var r=!1,l=ft,i=t.contextType;return typeof i=="object"&&i!==null?i=_e(i):(l=me(t)?Nt:oe.current,r=t.contextTypes,i=(r=r!=null)?tn(e,l):ft),t=new t(n,i),e.memoizedState=t.state!==null&&t.state!==void 0?t.state:null,t.updater=Kr,e.stateNode=t,t._reactInternals=e,r&&(e=e.stateNode,e.__reactInternalMemoizedUnmaskedChildContext=l,e.__reactInternalMemoizedMaskedChildContext=i),t}function Ga(e,t,n,r){e=t.state,typeof t.componentWillReceiveProps=="function"&&t.componentWillReceiveProps(n,r),typeof t.UNSAFE_componentWillReceiveProps=="function"&&t.UNSAFE_componentWillReceiveProps(n,r),t.state!==e&&Kr.enqueueReplaceState(t,t.state,null)}function Ji(e,t,n,r){var l=e.stateNode;l.props=n,l.state=e.memoizedState,l.refs=Ka,Xi(e);var i=t.contextType;typeof i=="object"&&i!==null?l.context=_e(i):(i=me(t)?Nt:oe.current,l.context=tn(e,i)),l.state=e.memoizedState,i=t.getDerivedStateFromProps,typeof i=="function"&&(Gi(e,t,i,n),l.state=e.memoizedState),typeof t.getDerivedStateFromProps=="function"||typeof l.getSnapshotBeforeUpdate=="function"||typeof l.UNSAFE_componentWillMount!="function"&&typeof l.componentWillMount!="function"||(t=l.state,typeof l.componentWillMount=="function"&&l.componentWillMount(),typeof l.UNSAFE_componentWillMount=="function"&&l.UNSAFE_componentWillMount(),t!==l.state&&Kr.enqueueReplaceState(l,l.state,null),Qr(e,n,l,r),l.state=e.memoizedState),typeof l.componentDidMount=="function"&&(e.flags|=4194308)}function Wn(e,t,n){if(e=n.ref,e!==null&&typeof e!="function"&&typeof e!="object"){if(n._owner){if(n=n._owner,n){if(n.tag!==1)throw Error(k(309));var r=n.stateNode}if(!r)throw Error(k(147,e));var l=r,i=""+e;return t!==null&&t.ref!==null&&typeof t.ref=="function"&&t.ref._stringRef===i?t.ref:(t=function(o){var a=l.refs;a===Ka&&(a=l.refs={}),o===null?delete a[i]:a[i]=o},t._stringRef=i,t)}if(typeof e!="string")throw Error(k(284));if(!n._owner)throw Error(k(290,e))}return e}function Yr(e,t){throw e=Object.prototype.toString.call(t),Error(k(31,e==="[object Object]"?"object with keys {"+Object.keys(t).join(", ")+"}":e))}function Ja(e){var t=e._init;return t(e._payload)}function Za(e){function t(d,c){if(e){var p=d.deletions;p===null?(d.deletions=[c],d.flags|=16):p.push(c)}}function n(d,c){if(!e)return null;for(;c!==null;)t(d,c),c=c.sibling;return null}function r(d,c){for(d=new Map;c!==null;)c.key!==null?d.set(c.key,c):d.set(c.index,c),c=c.sibling;return d}function l(d,c){return d=kt(d,c),d.index=0,d.sibling=null,d}function i(d,c,p){return d.index=p,e?(p=d.alternate,p!==null?(p=p.index,p<c?(d.flags|=2,c):p):(d.flags|=2,c)):(d.flags|=1048576,c)}function o(d){return e&&d.alternate===null&&(d.flags|=2),d}function a(d,c,p,h){return c===null||c.tag!==6?(c=Do(p,d.mode,h),c.return=d,c):(c=l(c,p),c.return=d,c)}function u(d,c,p,h){var j=p.type;return j===Ut?v(d,c,p.props.children,h,p.key):c!==null&&(c.elementType===j||typeof j=="object"&&j!==null&&j.$$typeof===nt&&Ja(j)===c.type)?(h=l(c,p.props),h.ref=Wn(d,c,p),h.return=d,h):(h=pl(p.type,p.key,p.props,null,d.mode,h),h.ref=Wn(d,c,p),h.return=d,h)}function f(d,c,p,h){return c===null||c.tag!==4||c.stateNode.containerInfo!==p.containerInfo||c.stateNode.implementation!==p.implementation?(c=Io(p,d.mode,h),c.return=d,c):(c=l(c,p.children||[]),c.return=d,c)}function v(d,c,p,h,j){return c===null||c.tag!==7?(c=Dt(p,d.mode,h,j),c.return=d,c):(c=l(c,p),c.return=d,c)}function g(d,c,p){if(typeof c=="string"&&c!==""||typeof c=="number")return c=Do(""+c,d.mode,p),c.return=d,c;if(typeof c=="object"&&c!==null){switch(c.$$typeof){case cr:return p=pl(c.type,c.key,c.props,null,d.mode,p),p.ref=Wn(d,null,c),p.return=d,p;case Bt:return c=Io(c,d.mode,p),c.return=d,c;case nt:var h=c._init;return g(d,h(c._payload),p)}if(wn(c)||xn(c))return c=Dt(c,d.mode,p,null),c.return=d,c;Yr(d,c)}return null}function m(d,c,p,h){var j=c!==null?c.key:null;if(typeof p=="string"&&p!==""||typeof p=="number")return j!==null?null:a(d,c,""+p,h);if(typeof p=="object"&&p!==null){switch(p.$$typeof){case cr:return p.key===j?u(d,c,p,h):null;case Bt:return p.key===j?f(d,c,p,h):null;case nt:return j=p._init,m(d,c,j(p._payload),h)}if(wn(p)||xn(p))return j!==null?null:v(d,c,p,h,null);Yr(d,p)}return null}function y(d,c,p,h,j){if(typeof h=="string"&&h!==""||typeof h=="number")return d=d.get(p)||null,a(c,d,""+h,j);if(typeof h=="object"&&h!==null){switch(h.$$typeof){case cr:return d=d.get(h.key===null?p:h.key)||null,u(c,d,h,j);case Bt:return d=d.get(h.key===null?p:h.key)||null,f(c,d,h,j);case nt:var N=h._init;return y(d,c,p,N(h._payload),j)}if(wn(h)||xn(h))return d=d.get(p)||null,v(c,d,h,j,null);Yr(c,h)}return null}function C(d,c,p,h){for(var j=null,N=null,w=c,L=c=0,O=null;w!==null&&L<p.length;L++){w.index>L?(O=w,w=null):O=w.sibling;var F=m(d,w,p[L],h);if(F===null){w===null&&(w=O);break}e&&w&&F.alternate===null&&t(d,w),c=i(F,c,L),N===null?j=F:N.sibling=F,N=F,w=O}if(L===p.length)return n(d,w),H&&zt(d,L),j;if(w===null){for(;L<p.length;L++)w=g(d,p[L],h),w!==null&&(c=i(w,c,L),N===null?j=w:N.sibling=w,N=w);return H&&zt(d,L),j}for(w=r(d,w);L<p.length;L++)O=y(w,d,L,p[L],h),O!==null&&(e&&O.alternate!==null&&w.delete(O.key===null?L:O.key),c=i(O,c,L),N===null?j=O:N.sibling=O,N=O);return e&&w.forEach(function(z){return t(d,z)}),H&&zt(d,L),j}function S(d,c,p,h){var j=xn(p);if(typeof j!="function")throw Error(k(150));if(p=j.call(p),p==null)throw Error(k(151));for(var N=j=null,w=c,L=c=0,O=null,F=p.next();w!==null&&!F.done;L++,F=p.next()){w.index>L?(O=w,w=null):O=w.sibling;var z=m(d,w,F.value,h);if(z===null){w===null&&(w=O);break}e&&w&&z.alternate===null&&t(d,w),c=i(z,c,L),N===null?j=z:N.sibling=z,N=z,w=O}if(F.done)return n(d,w),H&&zt(d,L),j;if(w===null){for(;!F.done;L++,F=p.next())F=g(d,F.value,h),F!==null&&(c=i(F,c,L),N===null?j=F:N.sibling=F,N=F);return H&&zt(d,L),j}for(w=r(d,w);!F.done;L++,F=p.next())F=y(w,d,L,F.value,h),F!==null&&(e&&F.alternate!==null&&w.delete(F.key===null?L:F.key),c=i(F,c,L),N===null?j=F:N.sibling=F,N=F);return e&&w.forEach(function(E){return t(d,E)}),H&&zt(d,L),j}function _(d,c,p,h){if(typeof p=="object"&&p!==null&&p.type===Ut&&p.key===null&&(p=p.props.children),typeof p=="object"&&p!==null){switch(p.$$typeof){case cr:e:{for(var j=p.key,N=c;N!==null;){if(N.key===j){if(j=p.type,j===Ut){if(N.tag===7){n(d,N.sibling),c=l(N,p.props.children),c.return=d,d=c;break e}}else if(N.elementType===j||typeof j=="object"&&j!==null&&j.$$typeof===nt&&Ja(j)===N.type){n(d,N.sibling),c=l(N,p.props),c.ref=Wn(d,N,p),c.return=d,d=c;break e}n(d,N);break}else t(d,N);N=N.sibling}p.type===Ut?(c=Dt(p.props.children,d.mode,h,p.key),c.return=d,d=c):(h=pl(p.type,p.key,p.props,null,d.mode,h),h.ref=Wn(d,c,p),h.return=d,d=h)}return o(d);case Bt:e:{for(N=p.key;c!==null;){if(c.key===N)if(c.tag===4&&c.stateNode.containerInfo===p.containerInfo&&c.stateNode.implementation===p.implementation){n(d,c.sibling),c=l(c,p.children||[]),c.return=d,d=c;break e}else{n(d,c);break}else t(d,c);c=c.sibling}c=Io(p,d.mode,h),c.return=d,d=c}return o(d);case nt:return N=p._init,_(d,c,N(p._payload),h)}if(wn(p))return C(d,c,p,h);if(xn(p))return S(d,c,p,h);Yr(d,p)}return typeof p=="string"&&p!==""||typeof p=="number"?(p=""+p,c!==null&&c.tag===6?(n(d,c.sibling),c=l(c,p),c.return=d,d=c):(n(d,c),c=Do(p,d.mode,h),c.return=d,d=c),o(d)):n(d,c)}return _}var an=Za(!0),qa=Za(!1),Qn={},Be=dt(Qn),Kn=dt(Qn),Yn=dt(Qn);function Lt(e){if(e===Qn)throw Error(k(174));return e}function Zi(e,t){switch(B(Yn,t),B(Kn,e),B(Be,Qn),e=t.nodeType,e){case 9:case 11:t=(t=t.documentElement)?t.namespaceURI:Jl(null,"");break;default:e=e===8?t.parentNode:t,t=e.namespaceURI||null,e=e.tagName,t=Jl(t,e)}V(Be),B(Be,t)}function un(){V(Be),V(Kn),V(Yn)}function eu(e){Lt(Yn.current);var t=Lt(Be.current),n=Jl(t,e.type);t!==n&&(B(Kn,e),B(Be,n))}function qi(e){Kn.current===e&&(V(Be),V(Kn))}var Q=dt(0);function Xr(e){for(var t=e;t!==null;){if(t.tag===13){var n=t.memoizedState;if(n!==null&&(n=n.dehydrated,n===null||n.data==="$?"||n.data==="$!"))return t}else if(t.tag===19&&t.memoizedProps.revealOrder!==void 0){if(t.flags&128)return t}else if(t.child!==null){t.child.return=t,t=t.child;continue}if(t===e)break;for(;t.sibling===null;){if(t.return===null||t.return===e)return null;t=t.return}t.sibling.return=t.return,t=t.sibling}return null}var eo=[];function to(){for(var e=0;e<eo.length;e++)eo[e]._workInProgressVersionPrimary=null;eo.length=0}var Gr=We.ReactCurrentDispatcher,no=We.ReactCurrentBatchConfig,bt=0,K=null,Z=null,ee=null,Jr=!1,Xn=!1,Gn=0,kf=0;function se(){throw Error(k(321))}function ro(e,t){if(t===null)return!1;for(var n=0;n<t.length&&n<e.length;n++)if(!Fe(e[n],t[n]))return!1;return!0}function lo(e,t,n,r,l,i){if(bt=i,K=t,t.memoizedState=null,t.updateQueue=null,t.lanes=0,Gr.current=e===null||e.memoizedState===null?Nf:Ef,e=n(r,l),Xn){i=0;do{if(Xn=!1,Gn=0,25<=i)throw Error(k(301));i+=1,ee=Z=null,t.updateQueue=null,Gr.current=zf,e=n(r,l)}while(Xn)}if(Gr.current=el,t=Z!==null&&Z.next!==null,bt=0,ee=Z=K=null,Jr=!1,t)throw Error(k(300));return e}function io(){var e=Gn!==0;return Gn=0,e}function Ue(){var e={memoizedState:null,baseState:null,baseQueue:null,queue:null,next:null};return ee===null?K.memoizedState=ee=e:ee=ee.next=e,ee}function Le(){if(Z===null){var e=K.alternate;e=e!==null?e.memoizedState:null}else e=Z.next;var t=ee===null?K.memoizedState:ee.next;if(t!==null)ee=t,Z=e;else{if(e===null)throw Error(k(310));Z=e,e={memoizedState:Z.memoizedState,baseState:Z.baseState,baseQueue:Z.baseQueue,queue:Z.queue,next:null},ee===null?K.memoizedState=ee=e:ee=ee.next=e}return ee}function Jn(e,t){return typeof t=="function"?t(e):t}function oo(e){var t=Le(),n=t.queue;if(n===null)throw Error(k(311));n.lastRenderedReducer=e;var r=Z,l=r.baseQueue,i=n.pending;if(i!==null){if(l!==null){var o=l.next;l.next=i.next,i.next=o}r.baseQueue=l=i,n.pending=null}if(l!==null){i=l.next,r=r.baseState;var a=o=null,u=null,f=i;do{var v=f.lane;if((bt&v)===v)u!==null&&(u=u.next={lane:0,action:f.action,hasEagerState:f.hasEagerState,eagerState:f.eagerState,next:null}),r=f.hasEagerState?f.eagerState:e(r,f.action);else{var g={lane:v,action:f.action,hasEagerState:f.hasEagerState,eagerState:f.eagerState,next:null};u===null?(a=u=g,o=r):u=u.next=g,K.lanes|=v,Tt|=v}f=f.next}while(f!==null&&f!==i);u===null?o=r:u.next=a,Fe(r,t.memoizedState)||(ge=!0),t.memoizedState=r,t.baseState=o,t.baseQueue=u,n.lastRenderedState=r}if(e=n.interleaved,e!==null){l=e;do i=l.lane,K.lanes|=i,Tt|=i,l=l.next;while(l!==e)}else l===null&&(n.lanes=0);return[t.memoizedState,n.dispatch]}function so(e){var t=Le(),n=t.queue;if(n===null)throw Error(k(311));n.lastRenderedReducer=e;var r=n.dispatch,l=n.pending,i=t.memoizedState;if(l!==null){n.pending=null;var o=l=l.next;do i=e(i,o.action),o=o.next;while(o!==l);Fe(i,t.memoizedState)||(ge=!0),t.memoizedState=i,t.baseQueue===null&&(t.baseState=i),n.lastRenderedState=i}return[i,r]}function tu(){}function nu(e,t){var n=K,r=Le(),l=t(),i=!Fe(r.memoizedState,l);if(i&&(r.memoizedState=l,ge=!0),r=r.queue,ao(iu.bind(null,n,r,e),[e]),r.getSnapshot!==t||i||ee!==null&&ee.memoizedState.tag&1){if(n.flags|=2048,Zn(9,lu.bind(null,n,r,l,t),void 0,null),te===null)throw Error(k(349));bt&30||ru(n,t,l)}return l}function ru(e,t,n){e.flags|=16384,e={getSnapshot:t,value:n},t=K.updateQueue,t===null?(t={lastEffect:null,stores:null},K.updateQueue=t,t.stores=[e]):(n=t.stores,n===null?t.stores=[e]:n.push(e))}function lu(e,t,n,r){t.value=n,t.getSnapshot=r,ou(t)&&su(e)}function iu(e,t,n){return n(function(){ou(t)&&su(e)})}function ou(e){var t=e.getSnapshot;e=e.value;try{var n=t();return!Fe(e,n)}catch{return!0}}function su(e){var t=Ge(e,1);t!==null&&Oe(t,e,1,-1)}function au(e){var t=Ue();return typeof e=="function"&&(e=e()),t.memoizedState=t.baseState=e,e={pending:null,interleaved:null,lanes:0,dispatch:null,lastRenderedReducer:Jn,lastRenderedState:e},t.queue=e,e=e.dispatch=jf.bind(null,K,e),[t.memoizedState,e]}function Zn(e,t,n,r){return e={tag:e,create:t,destroy:n,deps:r,next:null},t=K.updateQueue,t===null?(t={lastEffect:null,stores:null},K.updateQueue=t,t.lastEffect=e.next=e):(n=t.lastEffect,n===null?t.lastEffect=e.next=e:(r=n.next,n.next=e,e.next=r,t.lastEffect=e)),e}function uu(){return Le().memoizedState}function Zr(e,t,n,r){var l=Ue();K.flags|=e,l.memoizedState=Zn(1|t,n,void 0,r===void 0?null:r)}function qr(e,t,n,r){var l=Le();r=r===void 0?null:r;var i=void 0;if(Z!==null){var o=Z.memoizedState;if(i=o.destroy,r!==null&&ro(r,o.deps)){l.memoizedState=Zn(t,n,i,r);return}}K.flags|=e,l.memoizedState=Zn(1|t,n,i,r)}function cu(e,t){return Zr(8390656,8,e,t)}function ao(e,t){return qr(2048,8,e,t)}function du(e,t){return qr(4,2,e,t)}function fu(e,t){return qr(4,4,e,t)}function pu(e,t){if(typeof t=="function")return e=e(),t(e),function(){t(null)};if(t!=null)return e=e(),t.current=e,function(){t.current=null}}function hu(e,t,n){return n=n!=null?n.concat([e]):null,qr(4,4,pu.bind(null,t,e),n)}function uo(){}function mu(e,t){var n=Le();t=t===void 0?null:t;var r=n.memoizedState;return r!==null&&t!==null&&ro(t,r[1])?r[0]:(n.memoizedState=[e,t],e)}function gu(e,t){var n=Le();t=t===void 0?null:t;var r=n.memoizedState;return r!==null&&t!==null&&ro(t,r[1])?r[0]:(e=e(),n.memoizedState=[e,t],e)}function vu(e,t,n){return bt&21?(Fe(n,t)||(n=Vs(),K.lanes|=n,Tt|=n,e.baseState=!0),t):(e.baseState&&(e.baseState=!1,ge=!0),e.memoizedState=n)}function Sf(e,t){var n=A;A=n!==0&&4>n?n:4,e(!0);var r=no.transition;no.transition={};try{e(!1),t()}finally{A=n,no.transition=r}}function xu(){return Le().memoizedState}function Cf(e,t,n){var r=yt(e);if(n={lane:r,action:n,hasEagerState:!1,eagerState:null,next:null},yu(e))wu(t,n);else if(n=Va(e,t,n,r),n!==null){var l=pe();Oe(n,e,r,l),ku(n,t,r)}}function jf(e,t,n){var r=yt(e),l={lane:r,action:n,hasEagerState:!1,eagerState:null,next:null};if(yu(e))wu(t,l);else{var i=e.alternate;if(e.lanes===0&&(i===null||i.lanes===0)&&(i=t.lastRenderedReducer,i!==null))try{var o=t.lastRenderedState,a=i(o,n);if(l.hasEagerState=!0,l.eagerState=a,Fe(a,o)){var u=t.interleaved;u===null?(l.next=l,Yi(t)):(l.next=u.next,u.next=l),t.interleaved=l;return}}catch{}finally{}n=Va(e,t,l,r),n!==null&&(l=pe(),Oe(n,e,r,l),ku(n,t,r))}}function yu(e){var t=e.alternate;return e===K||t!==null&&t===K}function wu(e,t){Xn=Jr=!0;var n=e.pending;n===null?t.next=t:(t.next=n.next,n.next=t),e.pending=t}function ku(e,t,n){if(n&4194240){var r=t.lanes;r&=e.pendingLanes,n|=r,t.lanes=n,ui(e,n)}}var el={readContext:_e,useCallback:se,useContext:se,useEffect:se,useImperativeHandle:se,useInsertionEffect:se,useLayoutEffect:se,useMemo:se,useReducer:se,useRef:se,useState:se,useDebugValue:se,useDeferredValue:se,useTransition:se,useMutableSource:se,useSyncExternalStore:se,useId:se,unstable_isNewReconciler:!1},Nf={readContext:_e,useCallback:function(e,t){return Ue().memoizedState=[e,t===void 0?null:t],e},useContext:_e,useEffect:cu,useImperativeHandle:function(e,t,n){return n=n!=null?n.concat([e]):null,Zr(4194308,4,pu.bind(null,t,e),n)},useLayoutEffect:function(e,t){return Zr(4194308,4,e,t)},useInsertionEffect:function(e,t){return Zr(4,2,e,t)},useMemo:function(e,t){var n=Ue();return t=t===void 0?null:t,e=e(),n.memoizedState=[e,t],e},useReducer:function(e,t,n){var r=Ue();return t=n!==void 0?n(t):t,r.memoizedState=r.baseState=t,e={pending:null,interleaved:null,lanes:0,dispatch:null,lastRenderedReducer:e,lastRenderedState:t},r.queue=e,e=e.dispatch=Cf.bind(null,K,e),[r.memoizedState,e]},useRef:function(e){var t=Ue();return e={current:e},t.memoizedState=e},useState:au,useDebugValue:uo,useDeferredValue:function(e){return Ue().memoizedState=e},useTransition:function(){var e=au(!1),t=e[0];return e=Sf.bind(null,e[1]),Ue().memoizedState=e,[t,e]},useMutableSource:function(){},useSyncExternalStore:function(e,t,n){var r=K,l=Ue();if(H){if(n===void 0)throw Error(k(407));n=n()}else{if(n=t(),te===null)throw Error(k(349));bt&30||ru(r,t,n)}l.memoizedState=n;var i={value:n,getSnapshot:t};return l.queue=i,cu(iu.bind(null,r,i,e),[e]),r.flags|=2048,Zn(9,lu.bind(null,r,i,n,t),void 0,null),n},useId:function(){var e=Ue(),t=te.identifierPrefix;if(H){var n=Xe,r=Ye;n=(r&~(1<<32-Pe(r)-1)).toString(32)+n,t=":"+t+"R"+n,n=Gn++,0<n&&(t+="H"+n.toString(32)),t+=":"}else n=kf++,t=":"+t+"r"+n.toString(32)+":";return e.memoizedState=t},unstable_isNewReconciler:!1},Ef={readContext:_e,useCallback:mu,useContext:_e,useEffect:ao,useImperativeHandle:hu,useInsertionEffect:du,useLayoutEffect:fu,useMemo:gu,useReducer:oo,useRef:uu,useState:function(){return oo(Jn)},useDebugValue:uo,useDeferredValue:function(e){var t=Le();return vu(t,Z.memoizedState,e)},useTransition:function(){var e=oo(Jn)[0],t=Le().memoizedState;return[e,t]},useMutableSource:tu,useSyncExternalStore:nu,useId:xu,unstable_isNewReconciler:!1},zf={readContext:_e,useCallback:mu,useContext:_e,useEffect:ao,useImperativeHandle:hu,useInsertionEffect:du,useLayoutEffect:fu,useMemo:gu,useReducer:so,useRef:uu,useState:function(){return so(Jn)},useDebugValue:uo,useDeferredValue:function(e){var t=Le();return Z===null?t.memoizedState=e:vu(t,Z.memoizedState,e)},useTransition:function(){var e=so(Jn)[0],t=Le().memoizedState;return[e,t]},useMutableSource:tu,useSyncExternalStore:nu,useId:xu,unstable_isNewReconciler:!1};function cn(e,t){try{var n="",r=t;do n+=ed(r),r=r.return;while(r);var l=n}catch(i){l=`
Error generating stack: `+i.message+`
`+i.stack}return{value:e,source:t,stack:l,digest:null}}function co(e,t,n){return{value:e,source:null,stack:n??null,digest:t??null}}function fo(e,t){try{console.error(t.value)}catch(n){setTimeout(function(){throw n})}}var _f=typeof WeakMap=="function"?WeakMap:Map;function Su(e,t,n){n=Je(-1,n),n.tag=3,n.payload={element:null};var r=t.value;return n.callback=function(){sl||(sl=!0,zo=r),fo(e,t)},n}function Cu(e,t,n){n=Je(-1,n),n.tag=3;var r=e.type.getDerivedStateFromError;if(typeof r=="function"){var l=t.value;n.payload=function(){return r(l)},n.callback=function(){fo(e,t)}}var i=e.stateNode;return i!==null&&typeof i.componentDidCatch=="function"&&(n.callback=function(){fo(e,t),typeof r!="function"&&(vt===null?vt=new Set([this]):vt.add(this));var o=t.stack;this.componentDidCatch(t.value,{componentStack:o!==null?o:""})}),n}function ju(e,t,n){var r=e.pingCache;if(r===null){r=e.pingCache=new _f;var l=new Set;r.set(t,l)}else l=r.get(t),l===void 0&&(l=new Set,r.set(t,l));l.has(n)||(l.add(n),e=Uf.bind(null,e,t,n),t.then(e,e))}function Nu(e){do{var t;if((t=e.tag===13)&&(t=e.memoizedState,t=t!==null?t.dehydrated!==null:!0),t)return e;e=e.return}while(e!==null);return null}function Eu(e,t,n,r,l){return e.mode&1?(e.flags|=65536,e.lanes=l,e):(e===t?e.flags|=65536:(e.flags|=128,n.flags|=131072,n.flags&=-52805,n.tag===1&&(n.alternate===null?n.tag=17:(t=Je(-1,1),t.tag=2,mt(n,t,1))),n.lanes|=1),e)}var Lf=We.ReactCurrentOwner,ge=!1;function fe(e,t,n,r){t.child=e===null?qa(t,null,n,r):an(t,e.child,n,r)}function zu(e,t,n,r,l){n=n.render;var i=t.ref;return sn(t,l),r=lo(e,t,n,r,i,l),n=io(),e!==null&&!ge?(t.updateQueue=e.updateQueue,t.flags&=-2053,e.lanes&=~l,Ze(e,t,l)):(H&&n&&Ai(t),t.flags|=1,fe(e,t,r,l),t.child)}function _u(e,t,n,r,l){if(e===null){var i=n.type;return typeof i=="function"&&!Mo(i)&&i.defaultProps===void 0&&n.compare===null&&n.defaultProps===void 0?(t.tag=15,t.type=i,Lu(e,t,i,r,l)):(e=pl(n.type,null,r,t,t.mode,l),e.ref=t.ref,e.return=t,t.child=e)}if(i=e.child,!(e.lanes&l)){var o=i.memoizedProps;if(n=n.compare,n=n!==null?n:On,n(o,r)&&e.ref===t.ref)return Ze(e,t,l)}return t.flags|=1,e=kt(i,r),e.ref=t.ref,e.return=t,t.child=e}function Lu(e,t,n,r,l){if(e!==null){var i=e.memoizedProps;if(On(i,r)&&e.ref===t.ref)if(ge=!1,t.pendingProps=r=i,(e.lanes&l)!==0)e.flags&131072&&(ge=!0);else return t.lanes=e.lanes,Ze(e,t,l)}return po(e,t,n,r,l)}function bu(e,t,n){var r=t.pendingProps,l=r.children,i=e!==null?e.memoizedState:null;if(r.mode==="hidden")if(!(t.mode&1))t.memoizedState={baseLanes:0,cachePool:null,transitions:null},B(fn,Ne),Ne|=n;else{if(!(n&1073741824))return e=i!==null?i.baseLanes|n:n,t.lanes=t.childLanes=1073741824,t.memoizedState={baseLanes:e,cachePool:null,transitions:null},t.updateQueue=null,B(fn,Ne),Ne|=e,null;t.memoizedState={baseLanes:0,cachePool:null,transitions:null},r=i!==null?i.baseLanes:n,B(fn,Ne),Ne|=r}else i!==null?(r=i.baseLanes|n,t.memoizedState=null):r=n,B(fn,Ne),Ne|=r;return fe(e,t,l,n),t.child}function Tu(e,t){var n=t.ref;(e===null&&n!==null||e!==null&&e.ref!==n)&&(t.flags|=512,t.flags|=2097152)}function po(e,t,n,r,l){var i=me(n)?Nt:oe.current;return i=tn(t,i),sn(t,l),n=lo(e,t,n,r,i,l),r=io(),e!==null&&!ge?(t.updateQueue=e.updateQueue,t.flags&=-2053,e.lanes&=~l,Ze(e,t,l)):(H&&r&&Ai(t),t.flags|=1,fe(e,t,n,l),t.child)}function Pu(e,t,n,r,l){if(me(n)){var i=!0;Or(t)}else i=!1;if(sn(t,l),t.stateNode===null)nl(e,t),Xa(t,n,r),Ji(t,n,r,l),r=!0;else if(e===null){var o=t.stateNode,a=t.memoizedProps;o.props=a;var u=o.context,f=n.contextType;typeof f=="object"&&f!==null?f=_e(f):(f=me(n)?Nt:oe.current,f=tn(t,f));var v=n.getDerivedStateFromProps,g=typeof v=="function"||typeof o.getSnapshotBeforeUpdate=="function";g||typeof o.UNSAFE_componentWillReceiveProps!="function"&&typeof o.componentWillReceiveProps!="function"||(a!==r||u!==f)&&Ga(t,o,r,f),ht=!1;var m=t.memoizedState;o.state=m,Qr(t,r,o,l),u=t.memoizedState,a!==r||m!==u||he.current||ht?(typeof v=="function"&&(Gi(t,n,v,r),u=t.memoizedState),(a=ht||Ya(t,n,a,r,m,u,f))?(g||typeof o.UNSAFE_componentWillMount!="function"&&typeof o.componentWillMount!="function"||(typeof o.componentWillMount=="function"&&o.componentWillMount(),typeof o.UNSAFE_componentWillMount=="function"&&o.UNSAFE_componentWillMount()),typeof o.componentDidMount=="function"&&(t.flags|=4194308)):(typeof o.componentDidMount=="function"&&(t.flags|=4194308),t.memoizedProps=r,t.memoizedState=u),o.props=r,o.state=u,o.context=f,r=a):(typeof o.componentDidMount=="function"&&(t.flags|=4194308),r=!1)}else{o=t.stateNode,Ha(e,t),a=t.memoizedProps,f=t.type===t.elementType?a:De(t.type,a),o.props=f,g=t.pendingProps,m=o.context,u=n.contextType,typeof u=="object"&&u!==null?u=_e(u):(u=me(n)?Nt:oe.current,u=tn(t,u));var y=n.getDerivedStateFromProps;(v=typeof y=="function"||typeof o.getSnapshotBeforeUpdate=="function")||typeof o.UNSAFE_componentWillReceiveProps!="function"&&typeof o.componentWillReceiveProps!="function"||(a!==g||m!==u)&&Ga(t,o,r,u),ht=!1,m=t.memoizedState,o.state=m,Qr(t,r,o,l);var C=t.memoizedState;a!==g||m!==C||he.current||ht?(typeof y=="function"&&(Gi(t,n,y,r),C=t.memoizedState),(f=ht||Ya(t,n,f,r,m,C,u)||!1)?(v||typeof o.UNSAFE_componentWillUpdate!="function"&&typeof o.componentWillUpdate!="function"||(typeof o.componentWillUpdate=="function"&&o.componentWillUpdate(r,C,u),typeof o.UNSAFE_componentWillUpdate=="function"&&o.UNSAFE_componentWillUpdate(r,C,u)),typeof o.componentDidUpdate=="function"&&(t.flags|=4),typeof o.getSnapshotBeforeUpdate=="function"&&(t.flags|=1024)):(typeof o.componentDidUpdate!="function"||a===e.memoizedProps&&m===e.memoizedState||(t.flags|=4),typeof o.getSnapshotBeforeUpdate!="function"||a===e.memoizedProps&&m===e.memoizedState||(t.flags|=1024),t.memoizedProps=r,t.memoizedState=C),o.props=r,o.state=C,o.context=u,r=f):(typeof o.componentDidUpdate!="function"||a===e.memoizedProps&&m===e.memoizedState||(t.flags|=4),typeof o.getSnapshotBeforeUpdate!="function"||a===e.memoizedProps&&m===e.memoizedState||(t.flags|=1024),r=!1)}return ho(e,t,n,r,i,l)}function ho(e,t,n,r,l,i){Tu(e,t);var o=(t.flags&128)!==0;if(!r&&!o)return l&&Ia(t,n,!1),Ze(e,t,i);r=t.stateNode,Lf.current=t;var a=o&&typeof n.getDerivedStateFromError!="function"?null:r.render();return t.flags|=1,e!==null&&o?(t.child=an(t,e.child,null,i),t.child=an(t,null,a,i)):fe(e,t,a,i),t.memoizedState=r.state,l&&Ia(t,n,!0),t.child}function Fu(e){var t=e.stateNode;t.pendingContext?Ma(e,t.pendingContext,t.pendingContext!==t.context):t.context&&Ma(e,t.context,!1),Zi(e,t.containerInfo)}function Mu(e,t,n,r,l){return ln(),Vi(l),t.flags|=256,fe(e,t,n,r),t.child}var mo={dehydrated:null,treeContext:null,retryLane:0};function go(e){return{baseLanes:e,cachePool:null,transitions:null}}function Du(e,t,n){var r=t.pendingProps,l=Q.current,i=!1,o=(t.flags&128)!==0,a;if((a=o)||(a=e!==null&&e.memoizedState===null?!1:(l&2)!==0),a?(i=!0,t.flags&=-129):(e===null||e.memoizedState!==null)&&(l|=1),B(Q,l&1),e===null)return Ui(t),e=t.memoizedState,e!==null&&(e=e.dehydrated,e!==null)?(t.mode&1?e.data==="$!"?t.lanes=8:t.lanes=1073741824:t.lanes=1,null):(o=r.children,e=r.fallback,i?(r=t.mode,i=t.child,o={mode:"hidden",children:o},!(r&1)&&i!==null?(i.childLanes=0,i.pendingProps=o):i=hl(o,r,0,null),e=Dt(e,r,n,null),i.return=t,e.return=t,i.sibling=e,t.child=i,t.child.memoizedState=go(n),t.memoizedState=mo,e):vo(t,o));if(l=e.memoizedState,l!==null&&(a=l.dehydrated,a!==null))return bf(e,t,o,r,a,l,n);if(i){i=r.fallback,o=t.mode,l=e.child,a=l.sibling;var u={mode:"hidden",children:r.children};return!(o&1)&&t.child!==l?(r=t.child,r.childLanes=0,r.pendingProps=u,t.deletions=null):(r=kt(l,u),r.subtreeFlags=l.subtreeFlags&14680064),a!==null?i=kt(a,i):(i=Dt(i,o,n,null),i.flags|=2),i.return=t,r.return=t,r.sibling=i,t.child=r,r=i,i=t.child,o=e.child.memoizedState,o=o===null?go(n):{baseLanes:o.baseLanes|n,cachePool:null,transitions:o.transitions},i.memoizedState=o,i.childLanes=e.childLanes&~n,t.memoizedState=mo,r}return i=e.child,e=i.sibling,r=kt(i,{mode:"visible",children:r.children}),!(t.mode&1)&&(r.lanes=n),r.return=t,r.sibling=null,e!==null&&(n=t.deletions,n===null?(t.deletions=[e],t.flags|=16):n.push(e)),t.child=r,t.memoizedState=null,r}function vo(e,t){return t=hl({mode:"visible",children:t},e.mode,0,null),t.return=e,e.child=t}function tl(e,t,n,r){return r!==null&&Vi(r),an(t,e.child,null,n),e=vo(t,t.pendingProps.children),e.flags|=2,t.memoizedState=null,e}function bf(e,t,n,r,l,i,o){if(n)return t.flags&256?(t.flags&=-257,r=co(Error(k(422))),tl(e,t,o,r)):t.memoizedState!==null?(t.child=e.child,t.flags|=128,null):(i=r.fallback,l=t.mode,r=hl({mode:"visible",children:r.children},l,0,null),i=Dt(i,l,o,null),i.flags|=2,r.return=t,i.return=t,r.sibling=i,t.child=r,t.mode&1&&an(t,e.child,null,o),t.child.memoizedState=go(o),t.memoizedState=mo,i);if(!(t.mode&1))return tl(e,t,o,null);if(l.data==="$!"){if(r=l.nextSibling&&l.nextSibling.dataset,r)var a=r.dgst;return r=a,i=Error(k(419)),r=co(i,r,void 0),tl(e,t,o,r)}if(a=(o&e.childLanes)!==0,ge||a){if(r=te,r!==null){switch(o&-o){case 4:l=2;break;case 16:l=8;break;case 64:case 128:case 256:case 512:case 1024:case 2048:case 4096:case 8192:case 16384:case 32768:case 65536:case 131072:case 262144:case 524288:case 1048576:case 2097152:case 4194304:case 8388608:case 16777216:case 33554432:case 67108864:l=32;break;case 536870912:l=268435456;break;default:l=0}l=l&(r.suspendedLanes|o)?0:l,l!==0&&l!==i.retryLane&&(i.retryLane=l,Ge(e,l),Oe(r,e,l,-1))}return Fo(),r=co(Error(k(421))),tl(e,t,o,r)}return l.data==="$?"?(t.flags|=128,t.child=e.child,t=Vf.bind(null,e),l._reactRetry=t,null):(e=i.treeContext,je=ct(l.nextSibling),Ce=t,H=!0,Me=null,e!==null&&(Ee[ze++]=Ye,Ee[ze++]=Xe,Ee[ze++]=Et,Ye=e.id,Xe=e.overflow,Et=t),t=vo(t,r.children),t.flags|=4096,t)}function Iu(e,t,n){e.lanes|=t;var r=e.alternate;r!==null&&(r.lanes|=t),Ki(e.return,t,n)}function xo(e,t,n,r,l){var i=e.memoizedState;i===null?e.memoizedState={isBackwards:t,rendering:null,renderingStartTime:0,last:r,tail:n,tailMode:l}:(i.isBackwards=t,i.rendering=null,i.renderingStartTime=0,i.last=r,i.tail=n,i.tailMode=l)}function Ru(e,t,n){var r=t.pendingProps,l=r.revealOrder,i=r.tail;if(fe(e,t,r.children,n),r=Q.current,r&2)r=r&1|2,t.flags|=128;else{if(e!==null&&e.flags&128)e:for(e=t.child;e!==null;){if(e.tag===13)e.memoizedState!==null&&Iu(e,n,t);else if(e.tag===19)Iu(e,n,t);else if(e.child!==null){e.child.return=e,e=e.child;continue}if(e===t)break e;for(;e.sibling===null;){if(e.return===null||e.return===t)break e;e=e.return}e.sibling.return=e.return,e=e.sibling}r&=1}if(B(Q,r),!(t.mode&1))t.memoizedState=null;else switch(l){case"forwards":for(n=t.child,l=null;n!==null;)e=n.alternate,e!==null&&Xr(e)===null&&(l=n),n=n.sibling;n=l,n===null?(l=t.child,t.child=null):(l=n.sibling,n.sibling=null),xo(t,!1,l,n,i);break;case"backwards":for(n=null,l=t.child,t.child=null;l!==null;){if(e=l.alternate,e!==null&&Xr(e)===null){t.child=l;break}e=l.sibling,l.sibling=n,n=l,l=e}xo(t,!0,n,null,i);break;case"together":xo(t,!1,null,null,void 0);break;default:t.memoizedState=null}return t.child}function nl(e,t){!(t.mode&1)&&e!==null&&(e.alternate=null,t.alternate=null,t.flags|=2)}function Ze(e,t,n){if(e!==null&&(t.dependencies=e.dependencies),Tt|=t.lanes,!(n&t.childLanes))return null;if(e!==null&&t.child!==e.child)throw Error(k(153));if(t.child!==null){for(e=t.child,n=kt(e,e.pendingProps),t.child=n,n.return=t;e.sibling!==null;)e=e.sibling,n=n.sibling=kt(e,e.pendingProps),n.return=t;n.sibling=null}return t.child}function Tf(e,t,n){switch(t.tag){case 3:Fu(t),ln();break;case 5:eu(t);break;case 1:me(t.type)&&Or(t);break;case 4:Zi(t,t.stateNode.containerInfo);break;case 10:var r=t.type._context,l=t.memoizedProps.value;B(Vr,r._currentValue),r._currentValue=l;break;case 13:if(r=t.memoizedState,r!==null)return r.dehydrated!==null?(B(Q,Q.current&1),t.flags|=128,null):n&t.child.childLanes?Du(e,t,n):(B(Q,Q.current&1),e=Ze(e,t,n),e!==null?e.sibling:null);B(Q,Q.current&1);break;case 19:if(r=(n&t.childLanes)!==0,e.flags&128){if(r)return Ru(e,t,n);t.flags|=128}if(l=t.memoizedState,l!==null&&(l.rendering=null,l.tail=null,l.lastEffect=null),B(Q,Q.current),r)break;return null;case 22:case 23:return t.lanes=0,bu(e,t,n)}return Ze(e,t,n)}var Ou,yo,Au,$u;Ou=function(e,t){for(var n=t.child;n!==null;){if(n.tag===5||n.tag===6)e.appendChild(n.stateNode);else if(n.tag!==4&&n.child!==null){n.child.return=n,n=n.child;continue}if(n===t)break;for(;n.sibling===null;){if(n.return===null||n.return===t)return;n=n.return}n.sibling.return=n.return,n=n.sibling}},yo=function(){},Au=function(e,t,n,r){var l=e.memoizedProps;if(l!==r){e=t.stateNode,Lt(Be.current);var i=null;switch(n){case"input":l=Kl(e,l),r=Kl(e,r),i=[];break;case"select":l=W({},l,{value:void 0}),r=W({},r,{value:void 0}),i=[];break;case"textarea":l=Gl(e,l),r=Gl(e,r),i=[];break;default:typeof l.onClick!="function"&&typeof r.onClick=="function"&&(e.onclick=Dr)}Zl(n,r);var o;n=null;for(f in l)if(!r.hasOwnProperty(f)&&l.hasOwnProperty(f)&&l[f]!=null)if(f==="style"){var a=l[f];for(o in a)a.hasOwnProperty(o)&&(n||(n={}),n[o]="")}else f!=="dangerouslySetInnerHTML"&&f!=="children"&&f!=="suppressContentEditableWarning"&&f!=="suppressHydrationWarning"&&f!=="autoFocus"&&(vn.hasOwnProperty(f)?i||(i=[]):(i=i||[]).push(f,null));for(f in r){var u=r[f];if(a=l?.[f],r.hasOwnProperty(f)&&u!==a&&(u!=null||a!=null))if(f==="style")if(a){for(o in a)!a.hasOwnProperty(o)||u&&u.hasOwnProperty(o)||(n||(n={}),n[o]="");for(o in u)u.hasOwnProperty(o)&&a[o]!==u[o]&&(n||(n={}),n[o]=u[o])}else n||(i||(i=[]),i.push(f,n)),n=u;else f==="dangerouslySetInnerHTML"?(u=u?u.__html:void 0,a=a?a.__html:void 0,u!=null&&a!==u&&(i=i||[]).push(f,u)):f==="children"?typeof u!="string"&&typeof u!="number"||(i=i||[]).push(f,""+u):f!=="suppressContentEditableWarning"&&f!=="suppressHydrationWarning"&&(vn.hasOwnProperty(f)?(u!=null&&f==="onScroll"&&U("scroll",e),i||a===u||(i=[])):(i=i||[]).push(f,u))}n&&(i=i||[]).push("style",n);var f=i;(t.updateQueue=f)&&(t.flags|=4)}},$u=function(e,t,n,r){n!==r&&(t.flags|=4)};function qn(e,t){if(!H)switch(e.tailMode){case"hidden":t=e.tail;for(var n=null;t!==null;)t.alternate!==null&&(n=t),t=t.sibling;n===null?e.tail=null:n.sibling=null;break;case"collapsed":n=e.tail;for(var r=null;n!==null;)n.alternate!==null&&(r=n),n=n.sibling;r===null?t||e.tail===null?e.tail=null:e.tail.sibling=null:r.sibling=null}}function ae(e){var t=e.alternate!==null&&e.alternate.child===e.child,n=0,r=0;if(t)for(var l=e.child;l!==null;)n|=l.lanes|l.childLanes,r|=l.subtreeFlags&14680064,r|=l.flags&14680064,l.return=e,l=l.sibling;else for(l=e.child;l!==null;)n|=l.lanes|l.childLanes,r|=l.subtreeFlags,r|=l.flags,l.return=e,l=l.sibling;return e.subtreeFlags|=r,e.childLanes=n,t}function Pf(e,t,n){var r=t.pendingProps;switch($i(t),t.tag){case 2:case 16:case 15:case 0:case 11:case 7:case 8:case 12:case 9:case 14:return ae(t),null;case 1:return me(t.type)&&Rr(),ae(t),null;case 3:return r=t.stateNode,un(),V(he),V(oe),to(),r.pendingContext&&(r.context=r.pendingContext,r.pendingContext=null),(e===null||e.child===null)&&(Ur(t)?t.flags|=4:e===null||e.memoizedState.isDehydrated&&!(t.flags&256)||(t.flags|=1024,Me!==null&&(bo(Me),Me=null))),yo(e,t),ae(t),null;case 5:qi(t);var l=Lt(Yn.current);if(n=t.type,e!==null&&t.stateNode!=null)Au(e,t,n,r,l),e.ref!==t.ref&&(t.flags|=512,t.flags|=2097152);else{if(!r){if(t.stateNode===null)throw Error(k(166));return ae(t),null}if(e=Lt(Be.current),Ur(t)){r=t.stateNode,n=t.type;var i=t.memoizedProps;switch(r[$e]=t,r[Vn]=i,e=(t.mode&1)!==0,n){case"dialog":U("cancel",r),U("close",r);break;case"iframe":case"object":case"embed":U("load",r);break;case"video":case"audio":for(l=0;l<$n.length;l++)U($n[l],r);break;case"source":U("error",r);break;case"img":case"image":case"link":U("error",r),U("load",r);break;case"details":U("toggle",r);break;case"input":ys(r,i),U("invalid",r);break;case"select":r._wrapperState={wasMultiple:!!i.multiple},U("invalid",r);break;case"textarea":Ss(r,i),U("invalid",r)}Zl(n,i),l=null;for(var o in i)if(i.hasOwnProperty(o)){var a=i[o];o==="children"?typeof a=="string"?r.textContent!==a&&(i.suppressHydrationWarning!==!0&&Mr(r.textContent,a,e),l=["children",a]):typeof a=="number"&&r.textContent!==""+a&&(i.suppressHydrationWarning!==!0&&Mr(r.textContent,a,e),l=["children",""+a]):vn.hasOwnProperty(o)&&a!=null&&o==="onScroll"&&U("scroll",r)}switch(n){case"input":dr(r),ks(r,i,!0);break;case"textarea":dr(r),js(r);break;case"select":case"option":break;default:typeof i.onClick=="function"&&(r.onclick=Dr)}r=l,t.updateQueue=r,r!==null&&(t.flags|=4)}else{o=l.nodeType===9?l:l.ownerDocument,e==="http://www.w3.org/1999/xhtml"&&(e=Ns(n)),e==="http://www.w3.org/1999/xhtml"?n==="script"?(e=o.createElement("div"),e.innerHTML="<script><\/script>",e=e.removeChild(e.firstChild)):typeof r.is=="string"?e=o.createElement(n,{is:r.is}):(e=o.createElement(n),n==="select"&&(o=e,r.multiple?o.multiple=!0:r.size&&(o.size=r.size))):e=o.createElementNS(e,n),e[$e]=t,e[Vn]=r,Ou(e,t,!1,!1),t.stateNode=e;e:{switch(o=ql(n,r),n){case"dialog":U("cancel",e),U("close",e),l=r;break;case"iframe":case"object":case"embed":U("load",e),l=r;break;case"video":case"audio":for(l=0;l<$n.length;l++)U($n[l],e);l=r;break;case"source":U("error",e),l=r;break;case"img":case"image":case"link":U("error",e),U("load",e),l=r;break;case"details":U("toggle",e),l=r;break;case"input":ys(e,r),l=Kl(e,r),U("invalid",e);break;case"option":l=r;break;case"select":e._wrapperState={wasMultiple:!!r.multiple},l=W({},r,{value:void 0}),U("invalid",e);break;case"textarea":Ss(e,r),l=Gl(e,r),U("invalid",e);break;default:l=r}Zl(n,l),a=l;for(i in a)if(a.hasOwnProperty(i)){var u=a[i];i==="style"?_s(e,u):i==="dangerouslySetInnerHTML"?(u=u?u.__html:void 0,u!=null&&Es(e,u)):i==="children"?typeof u=="string"?(n!=="textarea"||u!=="")&&kn(e,u):typeof u=="number"&&kn(e,""+u):i!=="suppressContentEditableWarning"&&i!=="suppressHydrationWarning"&&i!=="autoFocus"&&(vn.hasOwnProperty(i)?u!=null&&i==="onScroll"&&U("scroll",e):u!=null&&Il(e,i,u,o))}switch(n){case"input":dr(e),ks(e,r,!1);break;case"textarea":dr(e),js(e);break;case"option":r.value!=null&&e.setAttribute("value",""+rt(r.value));break;case"select":e.multiple=!!r.multiple,i=r.value,i!=null?Vt(e,!!r.multiple,i,!1):r.defaultValue!=null&&Vt(e,!!r.multiple,r.defaultValue,!0);break;default:typeof l.onClick=="function"&&(e.onclick=Dr)}switch(n){case"button":case"input":case"select":case"textarea":r=!!r.autoFocus;break e;case"img":r=!0;break e;default:r=!1}}r&&(t.flags|=4)}t.ref!==null&&(t.flags|=512,t.flags|=2097152)}return ae(t),null;case 6:if(e&&t.stateNode!=null)$u(e,t,e.memoizedProps,r);else{if(typeof r!="string"&&t.stateNode===null)throw Error(k(166));if(n=Lt(Yn.current),Lt(Be.current),Ur(t)){if(r=t.stateNode,n=t.memoizedProps,r[$e]=t,(i=r.nodeValue!==n)&&(e=Ce,e!==null))switch(e.tag){case 3:Mr(r.nodeValue,n,(e.mode&1)!==0);break;case 5:e.memoizedProps.suppressHydrationWarning!==!0&&Mr(r.nodeValue,n,(e.mode&1)!==0)}i&&(t.flags|=4)}else r=(n.nodeType===9?n:n.ownerDocument).createTextNode(r),r[$e]=t,t.stateNode=r}return ae(t),null;case 13:if(V(Q),r=t.memoizedState,e===null||e.memoizedState!==null&&e.memoizedState.dehydrated!==null){if(H&&je!==null&&t.mode&1&&!(t.flags&128))Ua(),ln(),t.flags|=98560,i=!1;else if(i=Ur(t),r!==null&&r.dehydrated!==null){if(e===null){if(!i)throw Error(k(318));if(i=t.memoizedState,i=i!==null?i.dehydrated:null,!i)throw Error(k(317));i[$e]=t}else ln(),!(t.flags&128)&&(t.memoizedState=null),t.flags|=4;ae(t),i=!1}else Me!==null&&(bo(Me),Me=null),i=!0;if(!i)return t.flags&65536?t:null}return t.flags&128?(t.lanes=n,t):(r=r!==null,r!==(e!==null&&e.memoizedState!==null)&&r&&(t.child.flags|=8192,t.mode&1&&(e===null||Q.current&1?q===0&&(q=3):Fo())),t.updateQueue!==null&&(t.flags|=4),ae(t),null);case 4:return un(),yo(e,t),e===null&&Bn(t.stateNode.containerInfo),ae(t),null;case 10:return Qi(t.type._context),ae(t),null;case 17:return me(t.type)&&Rr(),ae(t),null;case 19:if(V(Q),i=t.memoizedState,i===null)return ae(t),null;if(r=(t.flags&128)!==0,o=i.rendering,o===null)if(r)qn(i,!1);else{if(q!==0||e!==null&&e.flags&128)for(e=t.child;e!==null;){if(o=Xr(e),o!==null){for(t.flags|=128,qn(i,!1),r=o.updateQueue,r!==null&&(t.updateQueue=r,t.flags|=4),t.subtreeFlags=0,r=n,n=t.child;n!==null;)i=n,e=r,i.flags&=14680066,o=i.alternate,o===null?(i.childLanes=0,i.lanes=e,i.child=null,i.subtreeFlags=0,i.memoizedProps=null,i.memoizedState=null,i.updateQueue=null,i.dependencies=null,i.stateNode=null):(i.childLanes=o.childLanes,i.lanes=o.lanes,i.child=o.child,i.subtreeFlags=0,i.deletions=null,i.memoizedProps=o.memoizedProps,i.memoizedState=o.memoizedState,i.updateQueue=o.updateQueue,i.type=o.type,e=o.dependencies,i.dependencies=e===null?null:{lanes:e.lanes,firstContext:e.firstContext}),n=n.sibling;return B(Q,Q.current&1|2),t.child}e=e.sibling}i.tail!==null&&X()>pn&&(t.flags|=128,r=!0,qn(i,!1),t.lanes=4194304)}else{if(!r)if(e=Xr(o),e!==null){if(t.flags|=128,r=!0,n=e.updateQueue,n!==null&&(t.updateQueue=n,t.flags|=4),qn(i,!0),i.tail===null&&i.tailMode==="hidden"&&!o.alternate&&!H)return ae(t),null}else 2*X()-i.renderingStartTime>pn&&n!==1073741824&&(t.flags|=128,r=!0,qn(i,!1),t.lanes=4194304);i.isBackwards?(o.sibling=t.child,t.child=o):(n=i.last,n!==null?n.sibling=o:t.child=o,i.last=o)}return i.tail!==null?(t=i.tail,i.rendering=t,i.tail=t.sibling,i.renderingStartTime=X(),t.sibling=null,n=Q.current,B(Q,r?n&1|2:n&1),t):(ae(t),null);case 22:case 23:return Po(),r=t.memoizedState!==null,e!==null&&e.memoizedState!==null!==r&&(t.flags|=8192),r&&t.mode&1?Ne&1073741824&&(ae(t),t.subtreeFlags&6&&(t.flags|=8192)):ae(t),null;case 24:return null;case 25:return null}throw Error(k(156,t.tag))}function Ff(e,t){switch($i(t),t.tag){case 1:return me(t.type)&&Rr(),e=t.flags,e&65536?(t.flags=e&-65537|128,t):null;case 3:return un(),V(he),V(oe),to(),e=t.flags,e&65536&&!(e&128)?(t.flags=e&-65537|128,t):null;case 5:return qi(t),null;case 13:if(V(Q),e=t.memoizedState,e!==null&&e.dehydrated!==null){if(t.alternate===null)throw Error(k(340));ln()}return e=t.flags,e&65536?(t.flags=e&-65537|128,t):null;case 19:return V(Q),null;case 4:return un(),null;case 10:return Qi(t.type._context),null;case 22:case 23:return Po(),null;case 24:return null;default:return null}}var rl=!1,ue=!1,Mf=typeof WeakSet=="function"?WeakSet:Set,b=null;function dn(e,t){var n=e.ref;if(n!==null)if(typeof n=="function")try{n(null)}catch(r){Y(e,t,r)}else n.current=null}function wo(e,t,n){try{n()}catch(r){Y(e,t,r)}}var Bu=!1;function Df(e,t){if(Ti=Cr,e=xa(),Ci(e)){if("selectionStart"in e)var n={start:e.selectionStart,end:e.selectionEnd};else e:{n=(n=e.ownerDocument)&&n.defaultView||window;var r=n.getSelection&&n.getSelection();if(r&&r.rangeCount!==0){n=r.anchorNode;var l=r.anchorOffset,i=r.focusNode;r=r.focusOffset;try{n.nodeType,i.nodeType}catch{n=null;break e}var o=0,a=-1,u=-1,f=0,v=0,g=e,m=null;t:for(;;){for(var y;g!==n||l!==0&&g.nodeType!==3||(a=o+l),g!==i||r!==0&&g.nodeType!==3||(u=o+r),g.nodeType===3&&(o+=g.nodeValue.length),(y=g.firstChild)!==null;)m=g,g=y;for(;;){if(g===e)break t;if(m===n&&++f===l&&(a=o),m===i&&++v===r&&(u=o),(y=g.nextSibling)!==null)break;g=m,m=g.parentNode}g=y}n=a===-1||u===-1?null:{start:a,end:u}}else n=null}n=n||{start:0,end:0}}else n=null;for(Pi={focusedElem:e,selectionRange:n},Cr=!1,b=t;b!==null;)if(t=b,e=t.child,(t.subtreeFlags&1028)!==0&&e!==null)e.return=t,b=e;else for(;b!==null;){t=b;try{var C=t.alternate;if(t.flags&1024)switch(t.tag){case 0:case 11:case 15:break;case 1:if(C!==null){var S=C.memoizedProps,_=C.memoizedState,d=t.stateNode,c=d.getSnapshotBeforeUpdate(t.elementType===t.type?S:De(t.type,S),_);d.__reactInternalSnapshotBeforeUpdate=c}break;case 3:var p=t.stateNode.containerInfo;p.nodeType===1?p.textContent="":p.nodeType===9&&p.documentElement&&p.removeChild(p.documentElement);break;case 5:case 6:case 4:case 17:break;default:throw Error(k(163))}}catch(h){Y(t,t.return,h)}if(e=t.sibling,e!==null){e.return=t.return,b=e;break}b=t.return}return C=Bu,Bu=!1,C}function er(e,t,n){var r=t.updateQueue;if(r=r!==null?r.lastEffect:null,r!==null){var l=r=r.next;do{if((l.tag&e)===e){var i=l.destroy;l.destroy=void 0,i!==void 0&&wo(t,n,i)}l=l.next}while(l!==r)}}function ll(e,t){if(t=t.updateQueue,t=t!==null?t.lastEffect:null,t!==null){var n=t=t.next;do{if((n.tag&e)===e){var r=n.create;n.destroy=r()}n=n.next}while(n!==t)}}function ko(e){var t=e.ref;if(t!==null){var n=e.stateNode;switch(e.tag){case 5:e=n;break;default:e=n}typeof t=="function"?t(e):t.current=e}}function Uu(e){var t=e.alternate;t!==null&&(e.alternate=null,Uu(t)),e.child=null,e.deletions=null,e.sibling=null,e.tag===5&&(t=e.stateNode,t!==null&&(delete t[$e],delete t[Vn],delete t[Ii],delete t[vf],delete t[xf])),e.stateNode=null,e.return=null,e.dependencies=null,e.memoizedProps=null,e.memoizedState=null,e.pendingProps=null,e.stateNode=null,e.updateQueue=null}function Vu(e){return e.tag===5||e.tag===3||e.tag===4}function Hu(e){e:for(;;){for(;e.sibling===null;){if(e.return===null||Vu(e.return))return null;e=e.return}for(e.sibling.return=e.return,e=e.sibling;e.tag!==5&&e.tag!==6&&e.tag!==18;){if(e.flags&2||e.child===null||e.tag===4)continue e;e.child.return=e,e=e.child}if(!(e.flags&2))return e.stateNode}}function So(e,t,n){var r=e.tag;if(r===5||r===6)e=e.stateNode,t?n.nodeType===8?n.parentNode.insertBefore(e,t):n.insertBefore(e,t):(n.nodeType===8?(t=n.parentNode,t.insertBefore(e,n)):(t=n,t.appendChild(e)),n=n._reactRootContainer,n!=null||t.onclick!==null||(t.onclick=Dr));else if(r!==4&&(e=e.child,e!==null))for(So(e,t,n),e=e.sibling;e!==null;)So(e,t,n),e=e.sibling}function Co(e,t,n){var r=e.tag;if(r===5||r===6)e=e.stateNode,t?n.insertBefore(e,t):n.appendChild(e);else if(r!==4&&(e=e.child,e!==null))for(Co(e,t,n),e=e.sibling;e!==null;)Co(e,t,n),e=e.sibling}var le=null,Ie=!1;function gt(e,t,n){for(n=n.child;n!==null;)Wu(e,t,n),n=n.sibling}function Wu(e,t,n){if(Ae&&typeof Ae.onCommitFiberUnmount=="function")try{Ae.onCommitFiberUnmount(vr,n)}catch{}switch(n.tag){case 5:ue||dn(n,t);case 6:var r=le,l=Ie;le=null,gt(e,t,n),le=r,Ie=l,le!==null&&(Ie?(e=le,n=n.stateNode,e.nodeType===8?e.parentNode.removeChild(n):e.removeChild(n)):le.removeChild(n.stateNode));break;case 18:le!==null&&(Ie?(e=le,n=n.stateNode,e.nodeType===8?Di(e.parentNode,n):e.nodeType===1&&Di(e,n),Pn(e)):Di(le,n.stateNode));break;case 4:r=le,l=Ie,le=n.stateNode.containerInfo,Ie=!0,gt(e,t,n),le=r,Ie=l;break;case 0:case 11:case 14:case 15:if(!ue&&(r=n.updateQueue,r!==null&&(r=r.lastEffect,r!==null))){l=r=r.next;do{var i=l,o=i.destroy;i=i.tag,o!==void 0&&(i&2||i&4)&&wo(n,t,o),l=l.next}while(l!==r)}gt(e,t,n);break;case 1:if(!ue&&(dn(n,t),r=n.stateNode,typeof r.componentWillUnmount=="function"))try{r.props=n.memoizedProps,r.state=n.memoizedState,r.componentWillUnmount()}catch(a){Y(n,t,a)}gt(e,t,n);break;case 21:gt(e,t,n);break;case 22:n.mode&1?(ue=(r=ue)||n.memoizedState!==null,gt(e,t,n),ue=r):gt(e,t,n);break;default:gt(e,t,n)}}function Qu(e){var t=e.updateQueue;if(t!==null){e.updateQueue=null;var n=e.stateNode;n===null&&(n=e.stateNode=new Mf),t.forEach(function(r){var l=Hf.bind(null,e,r);n.has(r)||(n.add(r),r.then(l,l))})}}function Re(e,t){var n=t.deletions;if(n!==null)for(var r=0;r<n.length;r++){var l=n[r];try{var i=e,o=t,a=o;e:for(;a!==null;){switch(a.tag){case 5:le=a.stateNode,Ie=!1;break e;case 3:le=a.stateNode.containerInfo,Ie=!0;break e;case 4:le=a.stateNode.containerInfo,Ie=!0;break e}a=a.return}if(le===null)throw Error(k(160));Wu(i,o,l),le=null,Ie=!1;var u=l.alternate;u!==null&&(u.return=null),l.return=null}catch(f){Y(l,t,f)}}if(t.subtreeFlags&12854)for(t=t.child;t!==null;)Ku(t,e),t=t.sibling}function Ku(e,t){var n=e.alternate,r=e.flags;switch(e.tag){case 0:case 11:case 14:case 15:if(Re(t,e),Ve(e),r&4){try{er(3,e,e.return),ll(3,e)}catch(S){Y(e,e.return,S)}try{er(5,e,e.return)}catch(S){Y(e,e.return,S)}}break;case 1:Re(t,e),Ve(e),r&512&&n!==null&&dn(n,n.return);break;case 5:if(Re(t,e),Ve(e),r&512&&n!==null&&dn(n,n.return),e.flags&32){var l=e.stateNode;try{kn(l,"")}catch(S){Y(e,e.return,S)}}if(r&4&&(l=e.stateNode,l!=null)){var i=e.memoizedProps,o=n!==null?n.memoizedProps:i,a=e.type,u=e.updateQueue;if(e.updateQueue=null,u!==null)try{a==="input"&&i.type==="radio"&&i.name!=null&&ws(l,i),ql(a,o);var f=ql(a,i);for(o=0;o<u.length;o+=2){var v=u[o],g=u[o+1];v==="style"?_s(l,g):v==="dangerouslySetInnerHTML"?Es(l,g):v==="children"?kn(l,g):Il(l,v,g,f)}switch(a){case"input":Yl(l,i);break;case"textarea":Cs(l,i);break;case"select":var m=l._wrapperState.wasMultiple;l._wrapperState.wasMultiple=!!i.multiple;var y=i.value;y!=null?Vt(l,!!i.multiple,y,!1):m!==!!i.multiple&&(i.defaultValue!=null?Vt(l,!!i.multiple,i.defaultValue,!0):Vt(l,!!i.multiple,i.multiple?[]:"",!1))}l[Vn]=i}catch(S){Y(e,e.return,S)}}break;case 6:if(Re(t,e),Ve(e),r&4){if(e.stateNode===null)throw Error(k(162));l=e.stateNode,i=e.memoizedProps;try{l.nodeValue=i}catch(S){Y(e,e.return,S)}}break;case 3:if(Re(t,e),Ve(e),r&4&&n!==null&&n.memoizedState.isDehydrated)try{Pn(t.containerInfo)}catch(S){Y(e,e.return,S)}break;case 4:Re(t,e),Ve(e);break;case 13:Re(t,e),Ve(e),l=e.child,l.flags&8192&&(i=l.memoizedState!==null,l.stateNode.isHidden=i,!i||l.alternate!==null&&l.alternate.memoizedState!==null||(Eo=X())),r&4&&Qu(e);break;case 22:if(v=n!==null&&n.memoizedState!==null,e.mode&1?(ue=(f=ue)||v,Re(t,e),ue=f):Re(t,e),Ve(e),r&8192){if(f=e.memoizedState!==null,(e.stateNode.isHidden=f)&&!v&&e.mode&1)for(b=e,v=e.child;v!==null;){for(g=b=v;b!==null;){switch(m=b,y=m.child,m.tag){case 0:case 11:case 14:case 15:er(4,m,m.return);break;case 1:dn(m,m.return);var C=m.stateNode;if(typeof C.componentWillUnmount=="function"){r=m,n=m.return;try{t=r,C.props=t.memoizedProps,C.state=t.memoizedState,C.componentWillUnmount()}catch(S){Y(r,n,S)}}break;case 5:dn(m,m.return);break;case 22:if(m.memoizedState!==null){Gu(g);continue}}y!==null?(y.return=m,b=y):Gu(g)}v=v.sibling}e:for(v=null,g=e;;){if(g.tag===5){if(v===null){v=g;try{l=g.stateNode,f?(i=l.style,typeof i.setProperty=="function"?i.setProperty("display","none","important"):i.display="none"):(a=g.stateNode,u=g.memoizedProps.style,o=u!=null&&u.hasOwnProperty("display")?u.display:null,a.style.display=zs("display",o))}catch(S){Y(e,e.return,S)}}}else if(g.tag===6){if(v===null)try{g.stateNode.nodeValue=f?"":g.memoizedProps}catch(S){Y(e,e.return,S)}}else if((g.tag!==22&&g.tag!==23||g.memoizedState===null||g===e)&&g.child!==null){g.child.return=g,g=g.child;continue}if(g===e)break e;for(;g.sibling===null;){if(g.return===null||g.return===e)break e;v===g&&(v=null),g=g.return}v===g&&(v=null),g.sibling.return=g.return,g=g.sibling}}break;case 19:Re(t,e),Ve(e),r&4&&Qu(e);break;case 21:break;default:Re(t,e),Ve(e)}}function Ve(e){var t=e.flags;if(t&2){try{e:{for(var n=e.return;n!==null;){if(Vu(n)){var r=n;break e}n=n.return}throw Error(k(160))}switch(r.tag){case 5:var l=r.stateNode;r.flags&32&&(kn(l,""),r.flags&=-33);var i=Hu(e);Co(e,i,l);break;case 3:case 4:var o=r.stateNode.containerInfo,a=Hu(e);So(e,a,o);break;default:throw Error(k(161))}}catch(u){Y(e,e.return,u)}e.flags&=-3}t&4096&&(e.flags&=-4097)}function If(e,t,n){b=e,Yu(e)}function Yu(e,t,n){for(var r=(e.mode&1)!==0;b!==null;){var l=b,i=l.child;if(l.tag===22&&r){var o=l.memoizedState!==null||rl;if(!o){var a=l.alternate,u=a!==null&&a.memoizedState!==null||ue;a=rl;var f=ue;if(rl=o,(ue=u)&&!f)for(b=l;b!==null;)o=b,u=o.child,o.tag===22&&o.memoizedState!==null?Ju(l):u!==null?(u.return=o,b=u):Ju(l);for(;i!==null;)b=i,Yu(i),i=i.sibling;b=l,rl=a,ue=f}Xu(e)}else l.subtreeFlags&8772&&i!==null?(i.return=l,b=i):Xu(e)}}function Xu(e){for(;b!==null;){var t=b;if(t.flags&8772){var n=t.alternate;try{if(t.flags&8772)switch(t.tag){case 0:case 11:case 15:ue||ll(5,t);break;case 1:var r=t.stateNode;if(t.flags&4&&!ue)if(n===null)r.componentDidMount();else{var l=t.elementType===t.type?n.memoizedProps:De(t.type,n.memoizedProps);r.componentDidUpdate(l,n.memoizedState,r.__reactInternalSnapshotBeforeUpdate)}var i=t.updateQueue;i!==null&&Qa(t,i,r);break;case 3:var o=t.updateQueue;if(o!==null){if(n=null,t.child!==null)switch(t.child.tag){case 5:n=t.child.stateNode;break;case 1:n=t.child.stateNode}Qa(t,o,n)}break;case 5:var a=t.stateNode;if(n===null&&t.flags&4){n=a;var u=t.memoizedProps;switch(t.type){case"button":case"input":case"select":case"textarea":u.autoFocus&&n.focus();break;case"img":u.src&&(n.src=u.src)}}break;case 6:break;case 4:break;case 12:break;case 13:if(t.memoizedState===null){var f=t.alternate;if(f!==null){var v=f.memoizedState;if(v!==null){var g=v.dehydrated;g!==null&&Pn(g)}}}break;case 19:case 17:case 21:case 22:case 23:case 25:break;default:throw Error(k(163))}ue||t.flags&512&&ko(t)}catch(m){Y(t,t.return,m)}}if(t===e){b=null;break}if(n=t.sibling,n!==null){n.return=t.return,b=n;break}b=t.return}}function Gu(e){for(;b!==null;){var t=b;if(t===e){b=null;break}var n=t.sibling;if(n!==null){n.return=t.return,b=n;break}b=t.return}}function Ju(e){for(;b!==null;){var t=b;try{switch(t.tag){case 0:case 11:case 15:var n=t.return;try{ll(4,t)}catch(u){Y(t,n,u)}break;case 1:var r=t.stateNode;if(typeof r.componentDidMount=="function"){var l=t.return;try{r.componentDidMount()}catch(u){Y(t,l,u)}}var i=t.return;try{ko(t)}catch(u){Y(t,i,u)}break;case 5:var o=t.return;try{ko(t)}catch(u){Y(t,o,u)}}}catch(u){Y(t,t.return,u)}if(t===e){b=null;break}var a=t.sibling;if(a!==null){a.return=t.return,b=a;break}b=t.return}}var Rf=Math.ceil,il=We.ReactCurrentDispatcher,jo=We.ReactCurrentOwner,be=We.ReactCurrentBatchConfig,R=0,te=null,J=null,ie=0,Ne=0,fn=dt(0),q=0,tr=null,Tt=0,ol=0,No=0,nr=null,ve=null,Eo=0,pn=1/0,qe=null,sl=!1,zo=null,vt=null,al=!1,xt=null,ul=0,rr=0,_o=null,cl=-1,dl=0;function pe(){return R&6?X():cl!==-1?cl:cl=X()}function yt(e){return e.mode&1?R&2&&ie!==0?ie&-ie:wf.transition!==null?(dl===0&&(dl=Vs()),dl):(e=A,e!==0||(e=window.event,e=e===void 0?16:Zs(e.type)),e):1}function Oe(e,t,n,r){if(50<rr)throw rr=0,_o=null,Error(k(185));zn(e,n,r),(!(R&2)||e!==te)&&(e===te&&(!(R&2)&&(ol|=n),q===4&&wt(e,ie)),xe(e,r),n===1&&R===0&&!(t.mode&1)&&(pn=X()+500,Ar&&pt()))}function xe(e,t){var n=e.callbackNode;yd(e,t);var r=wr(e,e===te?ie:0);if(r===0)n!==null&&$s(n),e.callbackNode=null,e.callbackPriority=0;else if(t=r&-r,e.callbackPriority!==t){if(n!=null&&$s(n),t===1)e.tag===0?yf(qu.bind(null,e)):Ra(qu.bind(null,e)),mf(function(){!(R&6)&&pt()}),n=null;else{switch(Hs(r)){case 1:n=oi;break;case 4:n=Bs;break;case 16:n=gr;break;case 536870912:n=Us;break;default:n=gr}n=sc(n,Zu.bind(null,e))}e.callbackPriority=t,e.callbackNode=n}}function Zu(e,t){if(cl=-1,dl=0,R&6)throw Error(k(327));var n=e.callbackNode;if(hn()&&e.callbackNode!==n)return null;var r=wr(e,e===te?ie:0);if(r===0)return null;if(r&30||r&e.expiredLanes||t)t=fl(e,r);else{t=r;var l=R;R|=2;var i=tc();(te!==e||ie!==t)&&(qe=null,pn=X()+500,Ft(e,t));do try{$f();break}catch(a){ec(e,a)}while(!0);Wi(),il.current=i,R=l,J!==null?t=0:(te=null,ie=0,t=q)}if(t!==0){if(t===2&&(l=si(e),l!==0&&(r=l,t=Lo(e,l))),t===1)throw n=tr,Ft(e,0),wt(e,r),xe(e,X()),n;if(t===6)wt(e,r);else{if(l=e.current.alternate,!(r&30)&&!Of(l)&&(t=fl(e,r),t===2&&(i=si(e),i!==0&&(r=i,t=Lo(e,i))),t===1))throw n=tr,Ft(e,0),wt(e,r),xe(e,X()),n;switch(e.finishedWork=l,e.finishedLanes=r,t){case 0:case 1:throw Error(k(345));case 2:Mt(e,ve,qe);break;case 3:if(wt(e,r),(r&130023424)===r&&(t=Eo+500-X(),10<t)){if(wr(e,0)!==0)break;if(l=e.suspendedLanes,(l&r)!==r){pe(),e.pingedLanes|=e.suspendedLanes&l;break}e.timeoutHandle=Mi(Mt.bind(null,e,ve,qe),t);break}Mt(e,ve,qe);break;case 4:if(wt(e,r),(r&4194240)===r)break;for(t=e.eventTimes,l=-1;0<r;){var o=31-Pe(r);i=1<<o,o=t[o],o>l&&(l=o),r&=~i}if(r=l,r=X()-r,r=(120>r?120:480>r?480:1080>r?1080:1920>r?1920:3e3>r?3e3:4320>r?4320:1960*Rf(r/1960))-r,10<r){e.timeoutHandle=Mi(Mt.bind(null,e,ve,qe),r);break}Mt(e,ve,qe);break;case 5:Mt(e,ve,qe);break;default:throw Error(k(329))}}}return xe(e,X()),e.callbackNode===n?Zu.bind(null,e):null}function Lo(e,t){var n=nr;return e.current.memoizedState.isDehydrated&&(Ft(e,t).flags|=256),e=fl(e,t),e!==2&&(t=ve,ve=n,t!==null&&bo(t)),e}function bo(e){ve===null?ve=e:ve.push.apply(ve,e)}function Of(e){for(var t=e;;){if(t.flags&16384){var n=t.updateQueue;if(n!==null&&(n=n.stores,n!==null))for(var r=0;r<n.length;r++){var l=n[r],i=l.getSnapshot;l=l.value;try{if(!Fe(i(),l))return!1}catch{return!1}}}if(n=t.child,t.subtreeFlags&16384&&n!==null)n.return=t,t=n;else{if(t===e)break;for(;t.sibling===null;){if(t.return===null||t.return===e)return!0;t=t.return}t.sibling.return=t.return,t=t.sibling}}return!0}function wt(e,t){for(t&=~No,t&=~ol,e.suspendedLanes|=t,e.pingedLanes&=~t,e=e.expirationTimes;0<t;){var n=31-Pe(t),r=1<<n;e[n]=-1,t&=~r}}function qu(e){if(R&6)throw Error(k(327));hn();var t=wr(e,0);if(!(t&1))return xe(e,X()),null;var n=fl(e,t);if(e.tag!==0&&n===2){var r=si(e);r!==0&&(t=r,n=Lo(e,r))}if(n===1)throw n=tr,Ft(e,0),wt(e,t),xe(e,X()),n;if(n===6)throw Error(k(345));return e.finishedWork=e.current.alternate,e.finishedLanes=t,Mt(e,ve,qe),xe(e,X()),null}function To(e,t){var n=R;R|=1;try{return e(t)}finally{R=n,R===0&&(pn=X()+500,Ar&&pt())}}function Pt(e){xt!==null&&xt.tag===0&&!(R&6)&&hn();var t=R;R|=1;var n=be.transition,r=A;try{if(be.transition=null,A=1,e)return e()}finally{A=r,be.transition=n,R=t,!(R&6)&&pt()}}function Po(){Ne=fn.current,V(fn)}function Ft(e,t){e.finishedWork=null,e.finishedLanes=0;var n=e.timeoutHandle;if(n!==-1&&(e.timeoutHandle=-1,hf(n)),J!==null)for(n=J.return;n!==null;){var r=n;switch($i(r),r.tag){case 1:r=r.type.childContextTypes,r!=null&&Rr();break;case 3:un(),V(he),V(oe),to();break;case 5:qi(r);break;case 4:un();break;case 13:V(Q);break;case 19:V(Q);break;case 10:Qi(r.type._context);break;case 22:case 23:Po()}n=n.return}if(te=e,J=e=kt(e.current,null),ie=Ne=t,q=0,tr=null,No=ol=Tt=0,ve=nr=null,_t!==null){for(t=0;t<_t.length;t++)if(n=_t[t],r=n.interleaved,r!==null){n.interleaved=null;var l=r.next,i=n.pending;if(i!==null){var o=i.next;i.next=l,r.next=o}n.pending=r}_t=null}return e}function ec(e,t){do{var n=J;try{if(Wi(),Gr.current=el,Jr){for(var r=K.memoizedState;r!==null;){var l=r.queue;l!==null&&(l.pending=null),r=r.next}Jr=!1}if(bt=0,ee=Z=K=null,Xn=!1,Gn=0,jo.current=null,n===null||n.return===null){q=1,tr=t,J=null;break}e:{var i=e,o=n.return,a=n,u=t;if(t=ie,a.flags|=32768,u!==null&&typeof u=="object"&&typeof u.then=="function"){var f=u,v=a,g=v.tag;if(!(v.mode&1)&&(g===0||g===11||g===15)){var m=v.alternate;m?(v.updateQueue=m.updateQueue,v.memoizedState=m.memoizedState,v.lanes=m.lanes):(v.updateQueue=null,v.memoizedState=null)}var y=Nu(o);if(y!==null){y.flags&=-257,Eu(y,o,a,i,t),y.mode&1&&ju(i,f,t),t=y,u=f;var C=t.updateQueue;if(C===null){var S=new Set;S.add(u),t.updateQueue=S}else C.add(u);break e}else{if(!(t&1)){ju(i,f,t),Fo();break e}u=Error(k(426))}}else if(H&&a.mode&1){var _=Nu(o);if(_!==null){!(_.flags&65536)&&(_.flags|=256),Eu(_,o,a,i,t),Vi(cn(u,a));break e}}i=u=cn(u,a),q!==4&&(q=2),nr===null?nr=[i]:nr.push(i),i=o;do{switch(i.tag){case 3:i.flags|=65536,t&=-t,i.lanes|=t;var d=Su(i,u,t);Wa(i,d);break e;case 1:a=u;var c=i.type,p=i.stateNode;if(!(i.flags&128)&&(typeof c.getDerivedStateFromError=="function"||p!==null&&typeof p.componentDidCatch=="function"&&(vt===null||!vt.has(p)))){i.flags|=65536,t&=-t,i.lanes|=t;var h=Cu(i,a,t);Wa(i,h);break e}}i=i.return}while(i!==null)}rc(n)}catch(j){t=j,J===n&&n!==null&&(J=n=n.return);continue}break}while(!0)}function tc(){var e=il.current;return il.current=el,e===null?el:e}function Fo(){(q===0||q===3||q===2)&&(q=4),te===null||!(Tt&268435455)&&!(ol&268435455)||wt(te,ie)}function fl(e,t){var n=R;R|=2;var r=tc();(te!==e||ie!==t)&&(qe=null,Ft(e,t));do try{Af();break}catch(l){ec(e,l)}while(!0);if(Wi(),R=n,il.current=r,J!==null)throw Error(k(261));return te=null,ie=0,q}function Af(){for(;J!==null;)nc(J)}function $f(){for(;J!==null&&!cd();)nc(J)}function nc(e){var t=oc(e.alternate,e,Ne);e.memoizedProps=e.pendingProps,t===null?rc(e):J=t,jo.current=null}function rc(e){var t=e;do{var n=t.alternate;if(e=t.return,t.flags&32768){if(n=Ff(n,t),n!==null){n.flags&=32767,J=n;return}if(e!==null)e.flags|=32768,e.subtreeFlags=0,e.deletions=null;else{q=6,J=null;return}}else if(n=Pf(n,t,Ne),n!==null){J=n;return}if(t=t.sibling,t!==null){J=t;return}J=t=e}while(t!==null);q===0&&(q=5)}function Mt(e,t,n){var r=A,l=be.transition;try{be.transition=null,A=1,Bf(e,t,n,r)}finally{be.transition=l,A=r}return null}function Bf(e,t,n,r){do hn();while(xt!==null);if(R&6)throw Error(k(327));n=e.finishedWork;var l=e.finishedLanes;if(n===null)return null;if(e.finishedWork=null,e.finishedLanes=0,n===e.current)throw Error(k(177));e.callbackNode=null,e.callbackPriority=0;var i=n.lanes|n.childLanes;if(wd(e,i),e===te&&(J=te=null,ie=0),!(n.subtreeFlags&2064)&&!(n.flags&2064)||al||(al=!0,sc(gr,function(){return hn(),null})),i=(n.flags&15990)!==0,n.subtreeFlags&15990||i){i=be.transition,be.transition=null;var o=A;A=1;var a=R;R|=4,jo.current=null,Df(e,n),Ku(n,e),sf(Pi),Cr=!!Ti,Pi=Ti=null,e.current=n,If(n),dd(),R=a,A=o,be.transition=i}else e.current=n;if(al&&(al=!1,xt=e,ul=l),i=e.pendingLanes,i===0&&(vt=null),hd(n.stateNode),xe(e,X()),t!==null)for(r=e.onRecoverableError,n=0;n<t.length;n++)l=t[n],r(l.value,{componentStack:l.stack,digest:l.digest});if(sl)throw sl=!1,e=zo,zo=null,e;return ul&1&&e.tag!==0&&hn(),i=e.pendingLanes,i&1?e===_o?rr++:(rr=0,_o=e):rr=0,pt(),null}function hn(){if(xt!==null){var e=Hs(ul),t=be.transition,n=A;try{if(be.transition=null,A=16>e?16:e,xt===null)var r=!1;else{if(e=xt,xt=null,ul=0,R&6)throw Error(k(331));var l=R;for(R|=4,b=e.current;b!==null;){var i=b,o=i.child;if(b.flags&16){var a=i.deletions;if(a!==null){for(var u=0;u<a.length;u++){var f=a[u];for(b=f;b!==null;){var v=b;switch(v.tag){case 0:case 11:case 15:er(8,v,i)}var g=v.child;if(g!==null)g.return=v,b=g;else for(;b!==null;){v=b;var m=v.sibling,y=v.return;if(Uu(v),v===f){b=null;break}if(m!==null){m.return=y,b=m;break}b=y}}}var C=i.alternate;if(C!==null){var S=C.child;if(S!==null){C.child=null;do{var _=S.sibling;S.sibling=null,S=_}while(S!==null)}}b=i}}if(i.subtreeFlags&2064&&o!==null)o.return=i,b=o;else e:for(;b!==null;){if(i=b,i.flags&2048)switch(i.tag){case 0:case 11:case 15:er(9,i,i.return)}var d=i.sibling;if(d!==null){d.return=i.return,b=d;break e}b=i.return}}var c=e.current;for(b=c;b!==null;){o=b;var p=o.child;if(o.subtreeFlags&2064&&p!==null)p.return=o,b=p;else e:for(o=c;b!==null;){if(a=b,a.flags&2048)try{switch(a.tag){case 0:case 11:case 15:ll(9,a)}}catch(j){Y(a,a.return,j)}if(a===o){b=null;break e}var h=a.sibling;if(h!==null){h.return=a.return,b=h;break e}b=a.return}}if(R=l,pt(),Ae&&typeof Ae.onPostCommitFiberRoot=="function")try{Ae.onPostCommitFiberRoot(vr,e)}catch{}r=!0}return r}finally{A=n,be.transition=t}}return!1}function lc(e,t,n){t=cn(n,t),t=Su(e,t,1),e=mt(e,t,1),t=pe(),e!==null&&(zn(e,1,t),xe(e,t))}function Y(e,t,n){if(e.tag===3)lc(e,e,n);else for(;t!==null;){if(t.tag===3){lc(t,e,n);break}else if(t.tag===1){var r=t.stateNode;if(typeof t.type.getDerivedStateFromError=="function"||typeof r.componentDidCatch=="function"&&(vt===null||!vt.has(r))){e=cn(n,e),e=Cu(t,e,1),t=mt(t,e,1),e=pe(),t!==null&&(zn(t,1,e),xe(t,e));break}}t=t.return}}function Uf(e,t,n){var r=e.pingCache;r!==null&&r.delete(t),t=pe(),e.pingedLanes|=e.suspendedLanes&n,te===e&&(ie&n)===n&&(q===4||q===3&&(ie&130023424)===ie&&500>X()-Eo?Ft(e,0):No|=n),xe(e,t)}function ic(e,t){t===0&&(e.mode&1?(t=yr,yr<<=1,!(yr&130023424)&&(yr=4194304)):t=1);var n=pe();e=Ge(e,t),e!==null&&(zn(e,t,n),xe(e,n))}function Vf(e){var t=e.memoizedState,n=0;t!==null&&(n=t.retryLane),ic(e,n)}function Hf(e,t){var n=0;switch(e.tag){case 13:var r=e.stateNode,l=e.memoizedState;l!==null&&(n=l.retryLane);break;case 19:r=e.stateNode;break;default:throw Error(k(314))}r!==null&&r.delete(t),ic(e,n)}var oc;oc=function(e,t,n){if(e!==null)if(e.memoizedProps!==t.pendingProps||he.current)ge=!0;else{if(!(e.lanes&n)&&!(t.flags&128))return ge=!1,Tf(e,t,n);ge=!!(e.flags&131072)}else ge=!1,H&&t.flags&1048576&&Oa(t,Br,t.index);switch(t.lanes=0,t.tag){case 2:var r=t.type;nl(e,t),e=t.pendingProps;var l=tn(t,oe.current);sn(t,n),l=lo(null,t,r,e,l,n);var i=io();return t.flags|=1,typeof l=="object"&&l!==null&&typeof l.render=="function"&&l.$$typeof===void 0?(t.tag=1,t.memoizedState=null,t.updateQueue=null,me(r)?(i=!0,Or(t)):i=!1,t.memoizedState=l.state!==null&&l.state!==void 0?l.state:null,Xi(t),l.updater=Kr,t.stateNode=l,l._reactInternals=t,Ji(t,r,e,n),t=ho(null,t,r,!0,i,n)):(t.tag=0,H&&i&&Ai(t),fe(null,t,l,n),t=t.child),t;case 16:r=t.elementType;e:{switch(nl(e,t),e=t.pendingProps,l=r._init,r=l(r._payload),t.type=r,l=t.tag=Qf(r),e=De(r,e),l){case 0:t=po(null,t,r,e,n);break e;case 1:t=Pu(null,t,r,e,n);break e;case 11:t=zu(null,t,r,e,n);break e;case 14:t=_u(null,t,r,De(r.type,e),n);break e}throw Error(k(306,r,""))}return t;case 0:return r=t.type,l=t.pendingProps,l=t.elementType===r?l:De(r,l),po(e,t,r,l,n);case 1:return r=t.type,l=t.pendingProps,l=t.elementType===r?l:De(r,l),Pu(e,t,r,l,n);case 3:e:{if(Fu(t),e===null)throw Error(k(387));r=t.pendingProps,i=t.memoizedState,l=i.element,Ha(e,t),Qr(t,r,null,n);var o=t.memoizedState;if(r=o.element,i.isDehydrated)if(i={element:r,isDehydrated:!1,cache:o.cache,pendingSuspenseBoundaries:o.pendingSuspenseBoundaries,transitions:o.transitions},t.updateQueue.baseState=i,t.memoizedState=i,t.flags&256){l=cn(Error(k(423)),t),t=Mu(e,t,r,n,l);break e}else if(r!==l){l=cn(Error(k(424)),t),t=Mu(e,t,r,n,l);break e}else for(je=ct(t.stateNode.containerInfo.firstChild),Ce=t,H=!0,Me=null,n=qa(t,null,r,n),t.child=n;n;)n.flags=n.flags&-3|4096,n=n.sibling;else{if(ln(),r===l){t=Ze(e,t,n);break e}fe(e,t,r,n)}t=t.child}return t;case 5:return eu(t),e===null&&Ui(t),r=t.type,l=t.pendingProps,i=e!==null?e.memoizedProps:null,o=l.children,Fi(r,l)?o=null:i!==null&&Fi(r,i)&&(t.flags|=32),Tu(e,t),fe(e,t,o,n),t.child;case 6:return e===null&&Ui(t),null;case 13:return Du(e,t,n);case 4:return Zi(t,t.stateNode.containerInfo),r=t.pendingProps,e===null?t.child=an(t,null,r,n):fe(e,t,r,n),t.child;case 11:return r=t.type,l=t.pendingProps,l=t.elementType===r?l:De(r,l),zu(e,t,r,l,n);case 7:return fe(e,t,t.pendingProps,n),t.child;case 8:return fe(e,t,t.pendingProps.children,n),t.child;case 12:return fe(e,t,t.pendingProps.children,n),t.child;case 10:e:{if(r=t.type._context,l=t.pendingProps,i=t.memoizedProps,o=l.value,B(Vr,r._currentValue),r._currentValue=o,i!==null)if(Fe(i.value,o)){if(i.children===l.children&&!he.current){t=Ze(e,t,n);break e}}else for(i=t.child,i!==null&&(i.return=t);i!==null;){var a=i.dependencies;if(a!==null){o=i.child;for(var u=a.firstContext;u!==null;){if(u.context===r){if(i.tag===1){u=Je(-1,n&-n),u.tag=2;var f=i.updateQueue;if(f!==null){f=f.shared;var v=f.pending;v===null?u.next=u:(u.next=v.next,v.next=u),f.pending=u}}i.lanes|=n,u=i.alternate,u!==null&&(u.lanes|=n),Ki(i.return,n,t),a.lanes|=n;break}u=u.next}}else if(i.tag===10)o=i.type===t.type?null:i.child;else if(i.tag===18){if(o=i.return,o===null)throw Error(k(341));o.lanes|=n,a=o.alternate,a!==null&&(a.lanes|=n),Ki(o,n,t),o=i.sibling}else o=i.child;if(o!==null)o.return=i;else for(o=i;o!==null;){if(o===t){o=null;break}if(i=o.sibling,i!==null){i.return=o.return,o=i;break}o=o.return}i=o}fe(e,t,l.children,n),t=t.child}return t;case 9:return l=t.type,r=t.pendingProps.children,sn(t,n),l=_e(l),r=r(l),t.flags|=1,fe(e,t,r,n),t.child;case 14:return r=t.type,l=De(r,t.pendingProps),l=De(r.type,l),_u(e,t,r,l,n);case 15:return Lu(e,t,t.type,t.pendingProps,n);case 17:return r=t.type,l=t.pendingProps,l=t.elementType===r?l:De(r,l),nl(e,t),t.tag=1,me(r)?(e=!0,Or(t)):e=!1,sn(t,n),Xa(t,r,l),Ji(t,r,l,n),ho(null,t,r,!0,e,n);case 19:return Ru(e,t,n);case 22:return bu(e,t,n)}throw Error(k(156,t.tag))};function sc(e,t){return As(e,t)}function Wf(e,t,n,r){this.tag=e,this.key=n,this.sibling=this.child=this.return=this.stateNode=this.type=this.elementType=null,this.index=0,this.ref=null,this.pendingProps=t,this.dependencies=this.memoizedState=this.updateQueue=this.memoizedProps=null,this.mode=r,this.subtreeFlags=this.flags=0,this.deletions=null,this.childLanes=this.lanes=0,this.alternate=null}function Te(e,t,n,r){return new Wf(e,t,n,r)}function Mo(e){return e=e.prototype,!(!e||!e.isReactComponent)}function Qf(e){if(typeof e=="function")return Mo(e)?1:0;if(e!=null){if(e=e.$$typeof,e===Al)return 11;if(e===Ul)return 14}return 2}function kt(e,t){var n=e.alternate;return n===null?(n=Te(e.tag,t,e.key,e.mode),n.elementType=e.elementType,n.type=e.type,n.stateNode=e.stateNode,n.alternate=e,e.alternate=n):(n.pendingProps=t,n.type=e.type,n.flags=0,n.subtreeFlags=0,n.deletions=null),n.flags=e.flags&14680064,n.childLanes=e.childLanes,n.lanes=e.lanes,n.child=e.child,n.memoizedProps=e.memoizedProps,n.memoizedState=e.memoizedState,n.updateQueue=e.updateQueue,t=e.dependencies,n.dependencies=t===null?null:{lanes:t.lanes,firstContext:t.firstContext},n.sibling=e.sibling,n.index=e.index,n.ref=e.ref,n}function pl(e,t,n,r,l,i){var o=2;if(r=e,typeof e=="function")Mo(e)&&(o=1);else if(typeof e=="string")o=5;else e:switch(e){case Ut:return Dt(n.children,l,i,t);case Rl:o=8,l|=8;break;case Ol:return e=Te(12,n,t,l|2),e.elementType=Ol,e.lanes=i,e;case $l:return e=Te(13,n,t,l),e.elementType=$l,e.lanes=i,e;case Bl:return e=Te(19,n,t,l),e.elementType=Bl,e.lanes=i,e;case ms:return hl(n,l,i,t);default:if(typeof e=="object"&&e!==null)switch(e.$$typeof){case ps:o=10;break e;case hs:o=9;break e;case Al:o=11;break e;case Ul:o=14;break e;case nt:o=16,r=null;break e}throw Error(k(130,e==null?e:typeof e,""))}return t=Te(o,n,t,l),t.elementType=e,t.type=r,t.lanes=i,t}function Dt(e,t,n,r){return e=Te(7,e,r,t),e.lanes=n,e}function hl(e,t,n,r){return e=Te(22,e,r,t),e.elementType=ms,e.lanes=n,e.stateNode={isHidden:!1},e}function Do(e,t,n){return e=Te(6,e,null,t),e.lanes=n,e}function Io(e,t,n){return t=Te(4,e.children!==null?e.children:[],e.key,t),t.lanes=n,t.stateNode={containerInfo:e.containerInfo,pendingChildren:null,implementation:e.implementation},t}function Kf(e,t,n,r,l){this.tag=t,this.containerInfo=e,this.finishedWork=this.pingCache=this.current=this.pendingChildren=null,this.timeoutHandle=-1,this.callbackNode=this.pendingContext=this.context=null,this.callbackPriority=0,this.eventTimes=ai(0),this.expirationTimes=ai(-1),this.entangledLanes=this.finishedLanes=this.mutableReadLanes=this.expiredLanes=this.pingedLanes=this.suspendedLanes=this.pendingLanes=0,this.entanglements=ai(0),this.identifierPrefix=r,this.onRecoverableError=l,this.mutableSourceEagerHydrationData=null}function Ro(e,t,n,r,l,i,o,a,u){return e=new Kf(e,t,n,a,u),t===1?(t=1,i===!0&&(t|=8)):t=0,i=Te(3,null,null,t),e.current=i,i.stateNode=e,i.memoizedState={element:r,isDehydrated:n,cache:null,transitions:null,pendingSuspenseBoundaries:null},Xi(i),e}function Yf(e,t,n){var r=3<arguments.length&&arguments[3]!==void 0?arguments[3]:null;return{$$typeof:Bt,key:r==null?null:""+r,children:e,containerInfo:t,implementation:n}}function ac(e){if(!e)return ft;e=e._reactInternals;e:{if(Ct(e)!==e||e.tag!==1)throw Error(k(170));var t=e;do{switch(t.tag){case 3:t=t.stateNode.context;break e;case 1:if(me(t.type)){t=t.stateNode.__reactInternalMemoizedMergedChildContext;break e}}t=t.return}while(t!==null);throw Error(k(171))}if(e.tag===1){var n=e.type;if(me(n))return Da(e,n,t)}return t}function uc(e,t,n,r,l,i,o,a,u){return e=Ro(n,r,!0,e,l,i,o,a,u),e.context=ac(null),n=e.current,r=pe(),l=yt(n),i=Je(r,l),i.callback=t??null,mt(n,i,l),e.current.lanes=l,zn(e,l,r),xe(e,r),e}function ml(e,t,n,r){var l=t.current,i=pe(),o=yt(l);return n=ac(n),t.context===null?t.context=n:t.pendingContext=n,t=Je(i,o),t.payload={element:e},r=r===void 0?null:r,r!==null&&(t.callback=r),e=mt(l,t,o),e!==null&&(Oe(e,l,o,i),Wr(e,l,o)),o}function gl(e){if(e=e.current,!e.child)return null;switch(e.child.tag){case 5:return e.child.stateNode;default:return e.child.stateNode}}function cc(e,t){if(e=e.memoizedState,e!==null&&e.dehydrated!==null){var n=e.retryLane;e.retryLane=n!==0&&n<t?n:t}}function Oo(e,t){cc(e,t),(e=e.alternate)&&cc(e,t)}function Xf(){return null}var dc=typeof reportError=="function"?reportError:function(e){console.error(e)};function Ao(e){this._internalRoot=e}vl.prototype.render=Ao.prototype.render=function(e){var t=this._internalRoot;if(t===null)throw Error(k(409));ml(e,t,null,null)},vl.prototype.unmount=Ao.prototype.unmount=function(){var e=this._internalRoot;if(e!==null){this._internalRoot=null;var t=e.containerInfo;Pt(function(){ml(null,e,null,null)}),t[Qe]=null}};function vl(e){this._internalRoot=e}vl.prototype.unstable_scheduleHydration=function(e){if(e){var t=Ks();e={blockedOn:null,target:e,priority:t};for(var n=0;n<st.length&&t!==0&&t<st[n].priority;n++);st.splice(n,0,e),n===0&&Gs(e)}};function $o(e){return!(!e||e.nodeType!==1&&e.nodeType!==9&&e.nodeType!==11)}function xl(e){return!(!e||e.nodeType!==1&&e.nodeType!==9&&e.nodeType!==11&&(e.nodeType!==8||e.nodeValue!==" react-mount-point-unstable "))}function fc(){}function Gf(e,t,n,r,l){if(l){if(typeof r=="function"){var i=r;r=function(){var f=gl(o);i.call(f)}}var o=uc(t,r,e,0,null,!1,!1,"",fc);return e._reactRootContainer=o,e[Qe]=o.current,Bn(e.nodeType===8?e.parentNode:e),Pt(),o}for(;l=e.lastChild;)e.removeChild(l);if(typeof r=="function"){var a=r;r=function(){var f=gl(u);a.call(f)}}var u=Ro(e,0,!1,null,null,!1,!1,"",fc);return e._reactRootContainer=u,e[Qe]=u.current,Bn(e.nodeType===8?e.parentNode:e),Pt(function(){ml(t,u,n,r)}),u}function yl(e,t,n,r,l){var i=n._reactRootContainer;if(i){var o=i;if(typeof l=="function"){var a=l;l=function(){var u=gl(o);a.call(u)}}ml(t,o,e,l)}else o=Gf(n,t,e,l,r);return gl(o)}Ws=function(e){switch(e.tag){case 3:var t=e.stateNode;if(t.current.memoizedState.isDehydrated){var n=En(t.pendingLanes);n!==0&&(ui(t,n|1),xe(t,X()),!(R&6)&&(pn=X()+500,pt()))}break;case 13:Pt(function(){var r=Ge(e,1);if(r!==null){var l=pe();Oe(r,e,1,l)}}),Oo(e,1)}},ci=function(e){if(e.tag===13){var t=Ge(e,134217728);if(t!==null){var n=pe();Oe(t,e,134217728,n)}Oo(e,134217728)}},Qs=function(e){if(e.tag===13){var t=yt(e),n=Ge(e,t);if(n!==null){var r=pe();Oe(n,e,t,r)}Oo(e,t)}},Ks=function(){return A},Ys=function(e,t){var n=A;try{return A=e,t()}finally{A=n}},ni=function(e,t,n){switch(t){case"input":if(Yl(e,n),t=n.name,n.type==="radio"&&t!=null){for(n=e;n.parentNode;)n=n.parentNode;for(n=n.querySelectorAll("input[name="+JSON.stringify(""+t)+'][type="radio"]'),t=0;t<n.length;t++){var r=n[t];if(r!==e&&r.form===e.form){var l=Ir(r);if(!l)throw Error(k(90));xs(r),Yl(r,l)}}}break;case"textarea":Cs(e,n);break;case"select":t=n.value,t!=null&&Vt(e,!!n.multiple,t,!1)}},Ps=To,Fs=Pt;var Jf={usingClientEntryPoint:!1,Events:[Hn,qt,Ir,bs,Ts,To]},lr={findFiberByHostInstance:jt,bundleType:0,version:"18.2.0",rendererPackageName:"react-dom"},Zf={bundleType:lr.bundleType,version:lr.version,rendererPackageName:lr.rendererPackageName,rendererConfig:lr.rendererConfig,overrideHookState:null,overrideHookStateDeletePath:null,overrideHookStateRenamePath:null,overrideProps:null,overridePropsDeletePath:null,overridePropsRenamePath:null,setErrorHandler:null,setSuspenseHandler:null,scheduleUpdate:null,currentDispatcherRef:We.ReactCurrentDispatcher,findHostInstanceByFiber:function(e){return e=Rs(e),e===null?null:e.stateNode},findFiberByHostInstance:lr.findFiberByHostInstance||Xf,findHostInstancesForRefresh:null,scheduleRefresh:null,scheduleRoot:null,setRefreshHandler:null,getCurrentFiber:null,reconcilerVersion:"18.2.0-next-9e3b772b8-20220608"};if(typeof __REACT_DEVTOOLS_GLOBAL_HOOK__<"u"){var wl=__REACT_DEVTOOLS_GLOBAL_HOOK__;if(!wl.isDisabled&&wl.supportsFiber)try{vr=wl.inject(Zf),Ae=wl}catch{}}we.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED=Jf,we.createPortal=function(e,t){var n=2<arguments.length&&arguments[2]!==void 0?arguments[2]:null;if(!$o(t))throw Error(k(200));return Yf(e,t,null,n)},we.createRoot=function(e,t){if(!$o(e))throw Error(k(299));var n=!1,r="",l=dc;return t!=null&&(t.unstable_strictMode===!0&&(n=!0),t.identifierPrefix!==void 0&&(r=t.identifierPrefix),t.onRecoverableError!==void 0&&(l=t.onRecoverableError)),t=Ro(e,1,!1,null,null,n,!1,r,l),e[Qe]=t.current,Bn(e.nodeType===8?e.parentNode:e),new Ao(t)},we.findDOMNode=function(e){if(e==null)return null;if(e.nodeType===1)return e;var t=e._reactInternals;if(t===void 0)throw typeof e.render=="function"?Error(k(188)):(e=Object.keys(e).join(","),Error(k(268,e)));return e=Rs(t),e=e===null?null:e.stateNode,e},we.flushSync=function(e){return Pt(e)},we.hydrate=function(e,t,n){if(!xl(t))throw Error(k(200));return yl(null,e,t,!0,n)},we.hydrateRoot=function(e,t,n){if(!$o(e))throw Error(k(405));var r=n!=null&&n.hydratedSources||null,l=!1,i="",o=dc;if(n!=null&&(n.unstable_strictMode===!0&&(l=!0),n.identifierPrefix!==void 0&&(i=n.identifierPrefix),n.onRecoverableError!==void 0&&(o=n.onRecoverableError)),t=uc(t,null,e,1,n??null,l,!1,i,o),e[Qe]=t.current,Bn(e),r)for(e=0;e<r.length;e++)n=r[e],l=n._getVersion,l=l(n._source),t.mutableSourceEagerHydrationData==null?t.mutableSourceEagerHydrationData=[n,l]:t.mutableSourceEagerHydrationData.push(n,l);return new vl(t)},we.render=function(e,t,n){if(!xl(t))throw Error(k(200));return yl(null,e,t,!1,n)},we.unmountComponentAtNode=function(e){if(!xl(e))throw Error(k(40));return e._reactRootContainer?(Pt(function(){yl(null,null,e,!1,function(){e._reactRootContainer=null,e[Qe]=null})}),!0):!1},we.unstable_batchedUpdates=To,we.unstable_renderSubtreeIntoContainer=function(e,t,n,r){if(!xl(n))throw Error(k(200));if(e==null||e._reactInternals===void 0)throw Error(k(38));return yl(e,t,n,!1,r)},we.version="18.2.0-next-9e3b772b8-20220608";function pc(){if(!(typeof __REACT_DEVTOOLS_GLOBAL_HOOK__>"u"||typeof __REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE!="function"))try{__REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE(pc)}catch(e){console.error(e)}}pc(),os.exports=we;var qf=os.exports,hc,mc=qf;hc=mc.createRoot,mc.hydrateRoot;const ep=`
/* ─── Design Tokens ─────────────────────────────────────────────────────── */

.dhc {
  --bg:#F6F8FB; --surface:#FFFFFF; --subtle:#F1F4F9; --well:#F8FAFC;
  --line:#DDE3EC; --line2:#C7D0DC; --hair:#EDF0F5;
  --txt:#0B1623; --txt2:#54657A; --txt3:#6E7E94;
  --brand:#0B6EEF; --brand-on:#FFFFFF; --brand-soft:#EEF4FE; --brand-line:#CBDDF9;
  --crit:#C8232C; --crit-bg:#FDF0F0; --crit-line:#F3C9CB;
  --warn:#B35309; --warn-bg:#FDF5EA; --warn-line:#F0DCBF;
  --ok:#1B7A43; --ok-bg:#EDF7F1; --ok-line:#C5E3D1;
  --mut:#5C6B7F; --mut-bg:#F2F4F7;
  --diff-a:#FDF9F3; --diff-b:#F5F9FE;
  --shadow:0 1px 2px rgba(11,22,35,.05);
  font-family: Inter, system-ui, -apple-system, sans-serif;
  -webkit-font-smoothing: antialiased;
  background: var(--bg);
  color: var(--txt);
  min-height: 100%;
}

.dhc[data-theme="dark"] {
  --bg:#0B1017; --surface:#141A23; --subtle:#1B2230; --well:#10161E;
  --line:#273243; --line2:#36445A; --hair:#1F2838;
  --txt:#E9EEF5; --txt2:#A2B1C4; --txt3:#7C8CA1;
  --brand:#4A93FF; --brand-on:#07101C; --brand-soft:#132236; --brand-line:#23456E;
  --crit:#FF7B72; --crit-bg:#2A1517; --crit-line:#5A2529;
  --warn:#F2B443; --warn-bg:#2A2012; --warn-line:#59431C;
  --ok:#4ED68E; --ok-bg:#122520; --ok-line:#1F4D38;
  --mut:#9AA7B8; --mut-bg:#1B2230;
  --diff-a:#241D10; --diff-b:#111E30;
  --shadow:0 1px 2px rgba(0,0,0,.4);
}

.dhc * { box-sizing: border-box; }
.dhc a { color: var(--brand); }
.dhc :focus-visible { outline: 2px solid var(--brand); outline-offset: 2px; border-radius: 4px; }

/* ─── App header ─────────────────────────────────────────────────────────── */

.dhc-header {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  align-items: center;
  justify-content: space-between;
  padding: 14px 32px;
  background: var(--surface);
  border-bottom: 1px solid var(--line);
}

.dhc-header-left {
  display: flex;
  align-items: center;
  gap: 11px;
}

.dhc-header-logo {
  width: 28px;
  height: 28px;
  border-radius: 7px;
  background: var(--brand);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.dhc-header-title {
  font-size: 15px;
  font-weight: 600;
  letter-spacing: -0.012em;
  margin: 0;
}

.dhc-header-right {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 18px;
}

/* ─── Theme toggle ───────────────────────────────────────────────────────── */

.dhc-theme-group {
  display: inline-flex;
  align-items: center;
  gap: 3px;
  padding: 3px;
  background: var(--subtle);
  border: 1px solid var(--line);
  border-radius: 9px;
}

.dhc-theme-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  min-height: 34px;
  padding: 0 12px;
  font-size: 12px;
  font-weight: 600;
  font-family: inherit;
  border-radius: 7px;
  cursor: pointer;
  border: 1px solid transparent;
  background: transparent;
  color: var(--txt3);
  transition: all 150ms ease;
}

.dhc-theme-btn--active {
  color: var(--txt);
  background: var(--surface);
  border-color: var(--line2);
}

/* ─── Navigation ──────────────────────────────────────────────────────────── */

.dhc-nav {
  display: flex;
  flex-wrap: wrap;
  gap: 2px;
  padding: 0 32px;
  background: var(--surface);
  border-bottom: 1px solid var(--line);
}

.dhc-nav-btn {
  padding: 13px 15px;
  font-size: 13px;
  font-weight: 500;
  font-family: inherit;
  color: var(--txt2);
  text-decoration: none;
  border: none;
  background: none;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  transition: color 150ms ease;
  white-space: nowrap;
}

.dhc-nav-btn:hover { color: var(--txt); }

.dhc-nav-btn--active {
  font-weight: 600;
  color: var(--txt);
  border-bottom-color: var(--brand);
}

.dhc-nav-btn:focus-visible {
  outline: 2px solid var(--brand);
  outline-offset: -2px;
  border-radius: 4px 4px 0 0;
}

/* ─── Screen ──────────────────────────────────────────────────────────────── */

.dhc-screen {
  max-width: 1060px;
  margin: 0 auto;
  padding: 32px;
  display: flex;
  flex-direction: column;
  gap: 22px;
}

.dhc-screen-title {
  margin: 0 0 7px;
  font-size: 24px;
  font-weight: 700;
  letter-spacing: -0.025em;
}

.dhc-screen-subtitle {
  margin: 0;
  font-size: 14px;
  color: var(--txt2);
}

.dhc-section-title {
  margin: 0 0 14px;
  font-size: 18px;
  font-weight: 600;
  letter-spacing: -0.015em;
}

.dhc-overline {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.09em;
  color: var(--txt3);
  text-transform: uppercase;
}

/* ─── Cards ───────────────────────────────────────────────────────────────── */

.dhc-card {
  background: var(--surface);
  border: 1px solid var(--line);
  border-radius: 12px;
  box-shadow: var(--shadow);
  overflow: hidden;
}

.dhc-card-body { padding: 30px 32px; }

/* ─── Buttons ─────────────────────────────────────────────────────────────── */

.dhc-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 7px;
  min-height: 44px;
  padding: 0 17px;
  font-size: 13px;
  font-weight: 600;
  font-family: inherit;
  border-radius: 8px;
  cursor: pointer;
  border: 1px solid;
  white-space: nowrap;
  transition: background 150ms ease, transform 150ms ease, box-shadow 150ms ease;
}

.dhc-btn:focus-visible { outline: 2px solid var(--brand); outline-offset: 2px; }
.dhc-btn:disabled { opacity: 0.45; cursor: not-allowed; }

.dhc-btn--primary {
  color: var(--brand-on);
  background: var(--brand);
  border-color: var(--brand);
}
.dhc-btn--primary:hover:not(:disabled) { filter: brightness(1.1); }

.dhc-btn--secondary {
  font-weight: 500;
  color: var(--txt);
  background: var(--surface);
  border-color: var(--line2);
}
.dhc-btn--secondary:hover:not(:disabled) { background: var(--subtle); }

.dhc-btn--danger {
  color: #fff;
  background: var(--crit);
  border-color: var(--crit);
}

.dhc-btn--ghost {
  font-weight: 500;
  color: var(--txt2);
  background: transparent;
  border-color: var(--line);
}
.dhc-btn--ghost:hover:not(:disabled) { background: var(--subtle); }

.dhc-btn--link {
  background: none;
  border: none;
  color: var(--brand);
  padding: 0;
  min-height: unset;
  font-size: inherit;
  font-weight: 500;
  cursor: pointer;
  text-decoration: none;
}
.dhc-btn--link:hover { text-decoration: underline; }

/* ─── Badges ──────────────────────────────────────────────────────────────── */

.dhc-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 11px;
  font-weight: 600;
  border-radius: 6px;
  padding: 4px 10px;
  border: 1px solid;
  white-space: nowrap;
  flex-shrink: 0;
}

.dhc-badge--crit   { color: var(--crit); background: var(--crit-bg); border-color: var(--crit-line); }
.dhc-badge--warn   { color: var(--warn); background: var(--warn-bg); border-color: var(--warn-line); }
.dhc-badge--info   { color: var(--brand); background: var(--brand-soft); border-color: var(--brand-line); }
.dhc-badge--ne     { color: var(--mut); background: var(--mut-bg); border-color: var(--line); }
.dhc-badge--ok     { color: var(--ok); background: var(--ok-bg); border-color: var(--ok-line); }

.dhc-badge--modif  { color: var(--warn); background: var(--warn-bg); border-color: var(--warn-line); }
.dhc-badge--absent { color: var(--mut); background: var(--mut-bg); border-color: var(--line); }
.dhc-badge--inchange { color: var(--txt3); background: var(--well); border-color: transparent; font-weight: 500; }
.dhc-badge--new    { font-size: 10px; font-weight: 700; letter-spacing: 0.05em; color: var(--ok); background: var(--ok-bg); border-color: var(--ok-line); border-radius: 5px; padding: 3px 7px; }
.dhc-badge--disabled { font-size: 10px; font-weight: 700; letter-spacing: 0.05em; color: var(--mut); background: var(--mut-bg); border-color: var(--line); border-radius: 5px; padding: 3px 7px; }

/* Type badges (component types) */
.dhc-type-badge {
  font-size: 11px;
  font-weight: 600;
  color: var(--txt2);
  background: var(--subtle);
  border: 1px solid var(--line);
  border-radius: 6px;
  padding: 3px 8px;
  white-space: nowrap;
}

/* API name badge */
.dhc-api-name {
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px;
  color: var(--txt3);
  background: var(--well);
  border: 1px solid var(--line);
  border-radius: 6px;
  padding: 3px 8px;
}

/* Copy button for API name */
.dhc-copy-btn {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  min-height: 32px;
  padding: 0 10px;
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px;
  color: var(--txt2);
  background: var(--well);
  border: 1px solid var(--line);
  border-radius: 6px;
  cursor: pointer;
}
.dhc-copy-btn:hover { background: var(--subtle); }

/* ─── Severity Counters (Dashboard) ──────────────────────────────────────── */

.dhc-counters {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 14px;
}

@media (max-width: 800px) {
  .dhc-counters { grid-template-columns: repeat(2, minmax(0, 1fr)); }
}

.dhc-counter {
  background: var(--surface);
  border: 1px solid var(--line);
  border-radius: 12px;
  padding: 18px 20px;
  box-shadow: var(--shadow);
}

.dhc-counter-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 14px;
}

.dhc-counter-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.08em;
  color: var(--txt2);
  text-transform: uppercase;
}

.dhc-counter-row {
  display: flex;
  align-items: baseline;
  gap: 9px;
}

.dhc-counter-value {
  font-size: 34px;
  font-weight: 700;
  font-variant-numeric: tabular-nums;
  line-height: 1;
  letter-spacing: -0.025em;
}

.dhc-counter-delta {
  font-size: 12px;
  font-weight: 600;
  font-variant-numeric: tabular-nums;
}

/* ─── Component counters (Composants screen) ─────────────────────────────── */

.dhc-comp-counters {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 14px;
}

@media (max-width: 800px) {
  .dhc-comp-counters { grid-template-columns: repeat(2, minmax(0, 1fr)); }
}

.dhc-comp-counter {
  background: var(--surface);
  border: 1px solid var(--line);
  border-radius: 12px;
  padding: 16px 18px;
  box-shadow: var(--shadow);
}

.dhc-comp-counter-value {
  font-size: 26px;
  font-weight: 700;
  font-variant-numeric: tabular-nums;
  line-height: 1;
  margin-bottom: 8px;
  letter-spacing: -0.02em;
}

.dhc-comp-counter-label {
  font-size: 12px;
  color: var(--txt2);
}

/* ─── Release bar (Dashboard) ────────────────────────────────────────────── */

.dhc-release-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 18px;
  align-items: center;
  justify-content: space-between;
}

.dhc-release-info {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 12px;
}

.dhc-release-label {
  font-size: 14px;
  font-weight: 600;
}

.dhc-release-time {
  font-size: 13px;
  color: var(--txt2);
  font-variant-numeric: tabular-nums;
}

.dhc-release-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

/* ─── Verdict card (Dashboard) ───────────────────────────────────────────── */

.dhc-verdict {
  display: flex;
  flex-wrap: wrap;
  gap: 28px;
  align-items: flex-start;
  justify-content: space-between;
}

.dhc-verdict-text {
  flex: 999 1 440px;
  min-width: 0;
}

.dhc-verdict-headline {
  margin: 0 0 12px;
  font-size: 28px;
  font-weight: 700;
  line-height: 1.2;
  letter-spacing: -0.025em;
}

.dhc-verdict-desc {
  margin: 0;
  font-size: 15px;
  line-height: 1.6;
  color: var(--txt2);
  max-width: 58ch;
}

/* ─── Finding list items (Dashboard + Constats) ──────────────────────────── */

.dhc-finding-card {
  display: flex;
  flex-wrap: wrap;
  gap: 18px;
  align-items: center;
  padding: 18px 22px;
}

.dhc-finding-card + .dhc-finding-card { border-top: 1px solid var(--hair); }
.dhc-finding-card:last-child { border-bottom: none; }

.dhc-finding-body {
  flex: 999 1 340px;
  min-width: 0;
}

.dhc-finding-message {
  font-size: 14px;
  line-height: 1.5;
  margin-bottom: 8px;
}

.dhc-finding-meta {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
}

.dhc-finding-label {
  font-size: 13px;
  font-weight: 500;
}

.dhc-finding-sub {
  font-size: 12px;
  color: var(--txt3);
  font-variant-numeric: tabular-nums;
}

/* ─── Footer bar (Dashboard) ─────────────────────────────────────────────── */

.dhc-footer-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  align-items: center;
  justify-content: space-between;
  margin-top: 16px;
}

.dhc-footer-stat {
  font-size: 13px;
  color: var(--txt2);
  font-variant-numeric: tabular-nums;
}

/* ─── Filter bar (Constats + Composants) ─────────────────────────────────── */

.dhc-filter-bar {
  background: var(--surface);
  border: 1px solid var(--line);
  border-radius: 12px;
  padding: 16px 20px;
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  align-items: center;
  box-shadow: var(--shadow);
}

.dhc-select {
  background: var(--surface);
  color: var(--txt);
  border: 1px solid var(--line2);
  border-radius: 8px;
  padding: 10px 12px;
  font-size: 13px;
  font-family: inherit;
  min-height: 44px;
  cursor: pointer;
}
.dhc-select:hover { border-color: var(--brand); }
.dhc-select:focus-visible { outline: 2px solid var(--brand); outline-offset: 2px; border-color: var(--brand); }

.dhc-filter-sep {
  width: 1px;
  height: 26px;
  background: var(--line);
  flex-shrink: 0;
}

.dhc-checkbox-label {
  display: inline-flex;
  align-items: center;
  gap: 9px;
  font-size: 13px;
  cursor: pointer;
  min-height: 44px;
}

.dhc-checkbox {
  width: 17px;
  height: 17px;
  accent-color: #0B6EEF;
  cursor: pointer;
}

.dhc-search-input {
  flex: 999 1 260px;
  min-width: 0;
  background: var(--surface);
  color: var(--txt);
  border: 1px solid var(--line2);
  border-radius: 8px;
  padding: 11px 14px;
  font-size: 13px;
  font-family: inherit;
  min-height: 44px;
}
.dhc-search-input:hover { border-color: var(--brand); }
.dhc-search-input:focus-visible { outline: 2px solid var(--brand); outline-offset: 2px; border-color: var(--brand); }

/* ─── Findings groups (Constats screen) ──────────────────────────────────── */

.dhc-group {
  background: var(--surface);
  border: 1px solid var(--line);
  border-radius: 12px;
  overflow: hidden;
  box-shadow: var(--shadow);
}

.dhc-group-header {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  align-items: center;
  padding: 15px 20px;
  background: var(--subtle);
  border-bottom: 1px solid var(--line);
  cursor: pointer;
}
.dhc-group-header:hover { background: var(--well); }

.dhc-group-rule {
  flex: 999 1 240px;
  min-width: 0;
  font-size: 13px;
  font-weight: 500;
}

.dhc-group-info {
  font-size: 12px;
  color: var(--txt3);
  flex-shrink: 0;
  font-variant-numeric: tabular-nums;
}

.dhc-group-count {
  font-size: 13px;
  font-weight: 600;
  flex-shrink: 0;
  font-variant-numeric: tabular-nums;
}

.dhc-group-item {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  align-items: center;
  padding: 18px 20px;
}

.dhc-group-item + .dhc-group-item { border-top: 1px solid var(--hair); }

.dhc-group-item-body {
  flex: 999 1 320px;
  min-width: 0;
}

/* Bulk accept bar */
.dhc-bulk-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: center;
  padding: 16px 20px;
  background: var(--well);
}

.dhc-bulk-label {
  font-size: 12px;
  color: var(--txt2);
  flex-shrink: 0;
}

.dhc-bulk-input {
  flex: 999 1 300px;
  min-width: 0;
  background: var(--surface);
  color: var(--txt);
  border: 1px solid var(--line2);
  border-radius: 8px;
  padding: 11px 13px;
  font-size: 13px;
  font-family: inherit;
  min-height: 44px;
}

/* ─── Pagination ──────────────────────────────────────────────────────────── */

.dhc-pagination {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  align-items: center;
  justify-content: center;
}

.dhc-pagination-info {
  font-size: 13px;
  color: var(--txt2);
  font-variant-numeric: tabular-nums;
}

/* ─── Comparison screen ──────────────────────────────────────────────────── */

.dhc-comp-nav {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  align-items: center;
  justify-content: space-between;
}

.dhc-back-link {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  font-weight: 500;
  text-decoration: none;
  color: var(--txt2);
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  font-family: inherit;
}
.dhc-back-link:hover { color: var(--brand); }

.dhc-comp-pager {
  display: flex;
  align-items: center;
  gap: 10px;
}

.dhc-comp-pager-info {
  font-size: 12px;
  color: var(--txt3);
  font-variant-numeric: tabular-nums;
}

.dhc-pager-btn {
  width: 44px;
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--txt);
  background: var(--surface);
  border: 1px solid var(--line2);
  border-radius: 8px;
  cursor: pointer;
}
.dhc-pager-btn:hover { background: var(--subtle); }
.dhc-pager-btn:disabled {
  color: var(--txt3);
  background: var(--subtle);
  border-color: var(--line);
  cursor: not-allowed;
}

/* Identity card */
.dhc-identity { padding: 24px 28px; }

.dhc-identity-badges {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 9px;
  margin-bottom: 12px;
}

.dhc-identity-title {
  margin: 0 0 10px;
  font-size: 24px;
  font-weight: 700;
  letter-spacing: -0.025em;
}

.dhc-identity-meta {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 12px;
}

.dhc-identity-desc {
  font-size: 13px;
  color: var(--txt2);
}

/* Diff toggle */
.dhc-diff-toggle {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  align-items: center;
  justify-content: space-between;
}

/* Diff table — 3-column grid */
.dhc-diff-head {
  display: grid;
  grid-template-columns: 220px minmax(0, 1fr) minmax(0, 1fr);
  background: var(--subtle);
  border-bottom: 1px solid var(--line);
}

.dhc-diff-head-cell {
  padding: 13px 20px;
}

.dhc-diff-head-cell + .dhc-diff-head-cell {
  border-left: 1px solid var(--line);
}

.dhc-diff-head-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.09em;
  text-transform: uppercase;
  margin-bottom: 3px;
}

.dhc-diff-head-date {
  font-size: 11px;
  color: var(--txt3);
  font-variant-numeric: tabular-nums;
}

.dhc-diff-row {
  display: grid;
  grid-template-columns: 220px minmax(0, 1fr) minmax(0, 1fr);
  border-bottom: 1px solid var(--hair);
}

.dhc-diff-attr {
  padding: 18px 20px;
}

.dhc-diff-attr-name {
  font-size: 13px;
  font-weight: 500;
  margin-bottom: 6px;
}

.dhc-diff-attr-key {
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px;
  color: var(--txt3);
  margin-bottom: 9px;
}

.dhc-diff-cell {
  padding: 18px 20px;
  border-left: 1px solid var(--hair);
}

.dhc-diff-cell--baseline { background: var(--diff-a); }
.dhc-diff-cell--current  { background: var(--diff-b); }

.dhc-diff-val {
  font-size: 15px;
  font-weight: 600;
  margin-bottom: 7px;
}

.dhc-diff-desc {
  font-size: 12px;
  color: var(--txt2);
  line-height: 1.5;
}

/* Collapsed identical row */
.dhc-diff-collapsed {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  align-items: center;
  padding: 15px 20px;
  background: var(--well);
}

.dhc-diff-collapsed-info {
  font-size: 13px;
  color: var(--txt2);
  flex: 999 1 200px;
  min-width: 0;
  font-variant-numeric: tabular-nums;
}

/* Access map in diff cells */
.dhc-access-block { margin-bottom: 14px; }
.dhc-access-block:last-child { margin-bottom: 0; }

.dhc-access-perm-name {
  font-size: 12px;
  font-weight: 500;
  margin-bottom: 8px;
}

.dhc-access-pills {
  display: flex;
  flex-wrap: wrap;
  gap: 5px;
}

.dhc-access-pill {
  font-size: 11px;
  color: var(--txt);
  background: var(--surface);
  border: 1px solid var(--line);
  border-radius: 5px;
  padding: 4px 9px;
}

.dhc-access-pill--new {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  font-weight: 600;
  color: var(--brand-on);
  background: var(--brand);
  border-color: var(--brand);
}

/* Verdict section (comparison) */
.dhc-verdict-section-head {
  padding: 14px 22px;
  background: var(--subtle);
  border-bottom: 1px solid var(--line);
}

.dhc-verdict-row {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  align-items: center;
  padding: 18px 22px;
}

.dhc-verdict-row + .dhc-verdict-row { border-top: 1px solid var(--hair); }

.dhc-verdict-msg {
  flex: 999 1 300px;
  min-width: 0;
  font-size: 14px;
  line-height: 1.5;
}

.dhc-verdict-rule {
  font-size: 12px;
  color: var(--txt3);
  flex-shrink: 0;
}

/* Fingerprint bar */
.dhc-fingerprint {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  align-items: center;
  padding: 14px 18px;
  background: var(--surface);
  border: 1px solid var(--line);
  border-radius: 10px;
}

.dhc-fingerprint-hash {
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px;
  color: var(--txt2);
  flex: 999 1 180px;
  min-width: 0;
  word-break: break-all;
}

.dhc-fingerprint-note {
  font-size: 12px;
  color: var(--txt3);
  flex-shrink: 0;
}

/* ─── Tables (Composants screen) ─────────────────────────────────────────── */

.dhc-table {
  width: 100%;
  border-collapse: collapse;
}

.dhc-table th,
.dhc-table td {
  text-align: left;
  font-variant-numeric: tabular-nums;
}

.dhc-table thead tr {
  background: var(--subtle);
  border-bottom: 1px solid var(--line);
}

.dhc-table th {
  padding: 13px 20px;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.09em;
  color: var(--txt3);
  text-transform: uppercase;
}

.dhc-table td {
  padding: 16px 20px;
}

.dhc-table tbody tr { border-bottom: 1px solid var(--hair); }
.dhc-table tbody tr:last-child { border-bottom: none; }
.dhc-table tbody tr:hover { background: var(--subtle); }

.dhc-table-highlight { background: var(--brand-soft); }
.dhc-table-highlight:hover { background: var(--brand-soft) !important; }

.dhc-table-name {
  font-size: 14px;
  font-weight: 500;
  margin-bottom: 6px;
}

.dhc-table-name-suffix {
  font-weight: 400;
  color: var(--txt3);
}

/* ─── Configuration screen ───────────────────────────────────────────────── */

.dhc-config-head {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  align-items: flex-start;
  justify-content: space-between;
}

.dhc-config-head-text {
  flex: 999 1 460px;
  min-width: 0;
}

.dhc-config-desc {
  margin: 0;
  font-size: 14px;
  color: var(--txt2);
  max-width: 70ch;
}

/* Scope rows */
.dhc-scope-row {
  display: flex;
  flex-wrap: wrap;
  gap: 18px;
  align-items: center;
  padding: 16px 20px;
}

.dhc-scope-row + .dhc-scope-row { border-top: 1px solid var(--hair); }

.dhc-scope-type {
  font-size: 13px;
  font-weight: 600;
  width: 130px;
  flex-shrink: 0;
}

.dhc-scope-desc {
  flex: 999 1 280px;
  min-width: 0;
  font-size: 13px;
  color: var(--txt2);
}

.dhc-scope-count {
  font-size: 12px;
  color: var(--txt3);
  flex-shrink: 0;
  font-variant-numeric: tabular-nums;
}

/* Scope target objects */
.dhc-scope-targets {
  padding-left: 148px;
}

.dhc-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 7px;
  margin-bottom: 11px;
}

.dhc-chip {
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px;
  color: var(--txt2);
  background: var(--well);
  border: 1px solid var(--line);
  border-radius: 6px;
  padding: 5px 10px;
}

.dhc-scope-note {
  margin: 0;
  font-size: 12px;
  color: var(--txt3);
  line-height: 1.6;
  max-width: 76ch;
}

/* Rule rows */
.dhc-rule-type-header {
  padding: 12px 20px;
  background: var(--subtle);
  border-bottom: 1px solid var(--line);
  border-top: 1px solid var(--line);
}

.dhc-rule-type-header:first-child { border-top: none; }

.dhc-rule-row {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  align-items: center;
  padding: 15px 20px;
}

.dhc-rule-row + .dhc-rule-row { border-top: 1px solid var(--hair); }

.dhc-rule-dot {
  width: 8px;
  height: 8px;
  border-radius: 2px;
  flex-shrink: 0;
}
.dhc-rule-dot--crit { background: var(--crit); }
.dhc-rule-dot--warn { background: var(--warn); }
.dhc-rule-dot--info { background: var(--brand); }

.dhc-rule-dot--disabled {
  background: transparent;
  border: 1.5px solid var(--txt3);
}

.dhc-rule-msg {
  flex: 999 1 320px;
  min-width: 0;
  font-size: 13px;
}

.dhc-rule-expr {
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px;
  color: var(--txt3);
  background: var(--well);
  border: 1px solid var(--line);
  border-radius: 6px;
  padding: 5px 9px;
  flex-shrink: 0;
}

/* Disabled rule row */
.dhc-rule-row--disabled {
  background: var(--well);
}

.dhc-rule-msg--disabled {
  color: var(--txt3);
  text-decoration: line-through;
}

.dhc-rule-explain {
  font-size: 12px;
  color: var(--txt3);
  line-height: 1.6;
  max-width: 76ch;
}

.dhc-rules-footer {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  align-items: center;
  justify-content: center;
  margin-top: 16px;
}

.dhc-rules-footer-info {
  font-size: 13px;
  color: var(--txt2);
  font-variant-numeric: tabular-nums;
}

/* ─── Info banner ─────────────────────────────────────────────────────────── */

.dhc-info-banner {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: flex-start;
  background: var(--brand-soft);
  border: 1px solid var(--brand-line);
  border-radius: 10px;
  padding: 15px 18px;
}

.dhc-info-banner-text {
  flex: 999 1 420px;
  min-width: 0;
  font-size: 13px;
  line-height: 1.6;
  color: var(--txt);
}

/* ─── Banners (success/error) ────────────────────────────────────────────── */

.dhc-banner {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 14px 20px;
  border-radius: 10px;
  font-size: 14px;
  border: 1px solid;
}

.dhc-banner--success {
  color: var(--ok);
  background: var(--ok-bg);
  border-color: var(--ok-line);
}

.dhc-banner--error {
  color: var(--crit);
  background: var(--crit-bg);
  border-color: var(--crit-line);
}

.dhc-banner-dismiss {
  margin-left: auto;
  background: none;
  border: none;
  color: inherit;
  cursor: pointer;
  font-size: 18px;
  line-height: 1;
  opacity: 0.6;
  padding: 4px;
  flex-shrink: 0;
}
.dhc-banner-dismiss:hover { opacity: 1; }

/* ─── Dialog ──────────────────────────────────────────────────────────────── */

.dhc-dialog-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.45);
  backdrop-filter: blur(4px);
  -webkit-backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  animation: dhc-fade-in 150ms ease;
}

@keyframes dhc-fade-in {
  from { opacity: 0; }
  to   { opacity: 1; }
}

.dhc-dialog {
  background: var(--surface);
  border-radius: 12px;
  padding: 28px;
  max-width: 480px;
  width: 90%;
  box-shadow: 0 10px 30px rgba(0,0,0,.2);
  animation: dhc-slide-up 250ms ease;
}

@keyframes dhc-slide-up {
  from { transform: translateY(10px); opacity: 0; }
  to   { transform: translateY(0);    opacity: 1; }
}

.dhc-dialog-title {
  font-size: 16px;
  font-weight: 600;
  margin: 0 0 16px;
}

.dhc-dialog-body {
  font-size: 14px;
  color: var(--txt2);
  line-height: 1.6;
  margin-bottom: 24px;
}

.dhc-dialog-actions {
  display: flex;
  gap: 8px;
  justify-content: flex-end;
}

/* ─── States ──────────────────────────────────────────────────────────────── */

.dhc-loading {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 60px 32px;
  color: var(--txt2);
  font-size: 14px;
}

.dhc-spinner {
  width: 20px;
  height: 20px;
  border: 2.5px solid var(--line);
  border-top-color: var(--brand);
  border-radius: 50%;
  animation: dhc-spin 0.7s linear infinite;
  flex-shrink: 0;
}

.dhc-spinner--sm { width: 14px; height: 14px; border-width: 2px; }

@keyframes dhc-spin { to { transform: rotate(360deg); } }

.dhc-error {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 12px;
  padding: 32px;
  font-size: 14px;
  color: var(--crit);
}

.dhc-empty {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px 20px;
  font-size: 14px;
  color: var(--txt3);
}

/* Skeleton */
@keyframes dhc-shimmer {
  0%   { background-position: -400px 0; }
  100% { background-position:  400px 0; }
}

.dhc-skel-cell {
  display: block;
  height: 14px;
  border-radius: 6px;
  background: linear-gradient(90deg, var(--line) 25%, var(--subtle) 50%, var(--line) 75%);
  background-size: 800px 100%;
  animation: dhc-shimmer 1.4s ease infinite;
}

.dhc-skel-row td { padding: 14px 20px; }

/* ─── Dimmed refresh ──────────────────────────────────────────────────────── */

.dhc-content--refreshing {
  opacity: 0.5;
  pointer-events: none;
  transition: opacity 250ms ease;
}

.dhc-refreshing-hint {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  color: var(--txt2);
}

/* ─── Utilities ───────────────────────────────────────────────────────────── */

.dhc-sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0,0,0,0);
  white-space: nowrap;
  border: 0;
}

.dhc-text-muted { color: var(--txt2); }
.dhc-text-mono { font-family: 'JetBrains Mono', monospace; font-size: 11px; color: var(--txt3); }

.dhc-inline-actions { display: flex; gap: 6px; flex-wrap: wrap; }

/* Textarea */
.dhc-textarea {
  width: 100%;
  max-width: 520px;
  padding: 10px 13px;
  border: 1px solid var(--line2);
  border-radius: 8px;
  font-size: 13px;
  font-family: inherit;
  background: var(--surface);
  color: var(--txt);
  resize: vertical;
  box-sizing: border-box;
  min-height: 64px;
}
.dhc-textarea:hover { border-color: var(--brand); }
.dhc-textarea:focus-visible { outline: 2px solid var(--brand); outline-offset: 2px; }

/* Expand row */
.dhc-expand-row td { padding: 0; border-bottom: 2px solid var(--brand); }
.dhc-expand-inner {
  padding: 16px 20px;
  background: var(--brand-soft);
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.dhc-expand-title {
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--brand);
}
.dhc-field-hint { font-size: 11px; color: var(--txt3); }

/* Notice (read-only info) */
.dhc-notice {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 14px 18px;
  background: var(--brand-soft);
  border: 1px solid var(--brand-line);
  border-radius: 10px;
  font-size: 13px;
  line-height: 1.6;
  color: var(--txt);
}

/* Loading overlay */
.dhc-loading-overlay-wrap { position: relative; }
.dhc-loading-overlay {
  position: absolute;
  inset: 0;
  background: rgba(255,255,255,0.65);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 5;
  border-radius: 12px;
}
.dhc[data-theme="dark"] .dhc-loading-overlay { background: rgba(11,16,23,0.65); }
`;function tp(){if(typeof document>"u"||document.querySelector("#dhc-ui-styles"))return;const e=document.createElement("style");e.id="dhc-ui-styles",e.textContent=ep,document.head.appendChild(e)}const gc=[{key:"Critique",shortLabel:"CRIT",countField:"criticalCount",cssClass:"crit",deltaField:"criticalDelta"},{key:"Avertissement",shortLabel:"AVERT",countField:"warningCount",cssClass:"warn",deltaField:"warningDelta"},{key:"Information",shortLabel:"INFO",countField:"informationCount",cssClass:"info",deltaField:"informationDelta"},{key:"Non évaluable",shortLabel:"N/É",countField:"notEvaluableCount",cssClass:"ne",deltaField:"notEvaluableDelta"}],vc=["Ouvert","Corrigé","Accepté"],x={nav:{dashboard:"Tableau de bord",findings:"Constats",comparison:"Comparaison",components:"Composants",config:"Configuration"},dashboard:{title:"Tableau de bord",noDeployment:"Aucun déploiement trouvé. Lancez une capture pour commencer.",captureCurrent:"Capturer l’état actuel",captureBaseline:"Définir la baseline",baselineWarning:"Cette action écrase la référence existante et est irréversible. Les données de baseline actuelles seront perdues.",baselineConfirm:"Confirmer la baseline",cancel:"Annuler",launched:"Capture lancée en arrière-plan. Cliquez sur « Rafraîchir » dès que le job est terminé.",reevaluate:"Réévaluer",reevLaunched:"Réévaluation lancée en arrière-plan. Cliquez sur « Rafraîchir » dès que le job est terminé.",refresh:"Rafraîchir",verdictNew:e=>`${e} nouveau${e>1?"x":""} problème${e>1?"s":""}`,verdictDesc:"détectés depuis la dernière baseline. Consultez les constats ci-dessous ou accédez à la liste complète.",viewNewFindings:e=>`Voir les ${e} nouveaux`,topCritical:"Nouveau sur cette livraison",viewComponent:"Voir le détail",viewAll:"Voir tous les constats",componentCount:e=>`${e} composant${e>1?"s":""} analysé${e>1?"s":""}`},findings:{title:"Constats",subtitle:"Résultats de l’analyse du dernier déploiement, groupés par règle.",filterSev:"Sévérité",filterStatus:"Statut",allSev:"Toutes les sévérités",allStatus:"Tous les statuts",newOnly:"Nouveaux uniquement",hideManaged:"Masquer packages managés",colSev:"Sévérité",colRule:"Règle",colComponent:"Composant",colMessage:"Message",colStatus:"Statut",colActions:"Actions",noFindings:"Aucun constat pour les filtres sélectionnés.",editStatus:"Modifier",justLabel:"Justification",justHint:"La justification est obligatoire pour ce statut.",save:"Enregistrer",cancel:"Annuler",prev:"Précédent",next:"Suivant",page:(e,t)=>`Page ${e} / ${t}`,findingCount:(e,t)=>`${e} constat${e>1?"s":""} affiché${e>1?"s":""} sur ${t}`,viewAll:"Tout afficher",bulkAccept:e=>`Accepter les ${e} masqués`,detail:"Détail"},comparison:{title:e=>e,noComponent:"Composant introuvable.",back:"Retour aux constats",colAttr:"Attribut",colBaseline:"Baseline",colCurrent:"Current",baselineDate:"État de référence",currentDate:"État actuel",absent:"(absent)",noState:"Aucun état capturé pour ce composant.",findingsTitle:"Ce que les règles en ont conclu",noFindings:"Aucun constat pour ce composant.",identicalCount:e=>`${e} attribut${e>1?"s":""} identique${e>1?"s":""} masqué${e>1?"s":""}`,showIdentical:"Afficher",hideIdentical:"Masquer",fingerprint:"Empreintes",prevComponent:"Précédent",nextComponent:"Suivant",componentOf:(e,t)=>`${e} / ${t}`},components:{title:"Composants",subtitle:"Tous les composants surveillés dans le dernier déploiement.",search:"Rechercher un composant…",filterType:"Type",filterState:"État",allTypes:"Tous les types",allStates:"Tous les états",stateUnchanged:"Inchangé",stateModified:"Modifié",stateNoBaseline:"Sans baseline",stateMissing:"Disparu",colName:"Composant",colType:"Type",colState:"État",colFindings:"Constats",colActions:"Actions",noComponents:"Aucun composant trouvé.",viewDetail:"Comparer",unchangedCount:"Inchangés",modifiedCount:"Modifiés",noBaselineCount:"Sans baseline",missingCount:"Disparus"},config:{title:"Configuration",subtitle:"Paramètres de capture et règles d’analyse appliquées par le moteur DHC.",readOnly:"Ces données sont en lecture seule. Modifiez-les via Setup > Custom Metadata Types.",openSetup:"Ouvrir Setup",scopesTitle:"Périmètres de capture",scopeLabel:"Label",scopeType:"Type de composant",scopeSeq:"Séquence",scopeActive:"Actif",scopeTarget:"Objets cibles",scopeNote:e=>`${e} objet${e>1?"s":""} cible${e>1?"s":""}`,rulesTitle:"Règles actives",ruleCode:"Code",ruleAttr:"Attribut",ruleOp:"Opérateur",ruleExpect:"Valeur attendue",ruleSev:"Sévérité",ruleMsg:"Message",noScopes:"Aucun périmètre configuré.",noRules:"Aucune règle active.",yes:"Oui",no:"Non",moreRules:e=>`${e} autre${e>1?"s":""} règle${e>1?"s":""}`,showAll:"Tout afficher"},common:{loading:"Chargement…",error:e=>`Erreur : ${e}`,retry:"Réessayer"}};function np(){return s.jsxs("svg",{width:"16",height:"16",viewBox:"0 0 16 16",fill:"none","aria-hidden":"true",children:[s.jsx("path",{d:"M8 1L2 3.5V7.5C2 11.09 4.56 14.41 8 15.5C11.44 14.41 14 11.09 14 7.5V3.5L8 1Z",fill:"currentColor",opacity:"0.9"}),s.jsx("path",{d:"M7 10.5L4.5 8L5.41 7.09L7 8.67L10.59 5.09L11.5 6L7 10.5Z",fill:"white"})]})}function rp(){return s.jsxs("svg",{width:"14",height:"14",viewBox:"0 0 14 14",fill:"none","aria-hidden":"true",children:[s.jsx("circle",{cx:"7",cy:"7",r:"3",stroke:"currentColor",strokeWidth:"1.5"}),s.jsx("path",{d:"M7 1V2.5M7 11.5V13M1 7H2.5M11.5 7H13M2.76 2.76L3.82 3.82M10.18 10.18L11.24 11.24M11.24 2.76L10.18 3.82M3.82 10.18L2.76 11.24",stroke:"currentColor",strokeWidth:"1.2",strokeLinecap:"round"})]})}function lp(){return s.jsx("svg",{width:"14",height:"14",viewBox:"0 0 14 14",fill:"none","aria-hidden":"true",children:s.jsx("path",{d:"M12.5 8.5A5.5 5.5 0 015.5 1.5 5.5 5.5 0 107.5 12.5a5.48 5.48 0 005-4z",stroke:"currentColor",strokeWidth:"1.2",strokeLinecap:"round",strokeLinejoin:"round"})})}function xc(){return s.jsx("svg",{width:"14",height:"14",viewBox:"0 0 14 14",fill:"none","aria-hidden":"true",children:s.jsx("path",{d:"M11 7H3M3 7L6.5 3.5M3 7L6.5 10.5",stroke:"currentColor",strokeWidth:"1.3",strokeLinecap:"round",strokeLinejoin:"round"})})}function yc(){return s.jsxs("svg",{width:"16",height:"16",viewBox:"0 0 16 16",fill:"none","aria-hidden":"true",children:[s.jsx("circle",{cx:"8",cy:"8",r:"6",stroke:"currentColor",strokeWidth:"1.5"}),s.jsx("path",{d:"M8 5V9M8 11V11.01",stroke:"currentColor",strokeWidth:"1.5",strokeLinecap:"round"})]})}function wc(){return s.jsxs("svg",{width:"16",height:"16",viewBox:"0 0 16 16",fill:"none","aria-hidden":"true",children:[s.jsx("path",{d:"M7.13 2.5L1.5 12.5H14.5L8.87 2.5C8.49 1.83 7.51 1.83 7.13 2.5Z",stroke:"currentColor",strokeWidth:"1.3",strokeLinejoin:"round"}),s.jsx("path",{d:"M8 6.5V9M8 11V11.01",stroke:"currentColor",strokeWidth:"1.3",strokeLinecap:"round"})]})}function kc(){return s.jsxs("svg",{width:"16",height:"16",viewBox:"0 0 16 16",fill:"none","aria-hidden":"true",children:[s.jsx("circle",{cx:"8",cy:"8",r:"6",stroke:"currentColor",strokeWidth:"1.5"}),s.jsx("path",{d:"M8 7V11M8 5V5.01",stroke:"currentColor",strokeWidth:"1.5",strokeLinecap:"round"})]})}function kl(){return s.jsxs("svg",{width:"16",height:"16",viewBox:"0 0 16 16",fill:"none","aria-hidden":"true",children:[s.jsx("circle",{cx:"8",cy:"8",r:"6",stroke:"currentColor",strokeWidth:"1.5"}),s.jsx("path",{d:"M6 6C6 4.9 6.9 4 8 4C9.1 4 10 4.9 10 6C10 7.5 8 7.5 8 9M8 11V11.01",stroke:"currentColor",strokeWidth:"1.2",strokeLinecap:"round"})]})}function ip({open:e}){return s.jsx("svg",{width:"12",height:"12",viewBox:"0 0 12 12",fill:"none","aria-hidden":"true",style:{transition:"transform 150ms ease",transform:e?"rotate(90deg)":"rotate(0)"},children:s.jsx("path",{d:"M4.5 2.5L8 6L4.5 9.5",stroke:"currentColor",strokeWidth:"1.3",strokeLinecap:"round",strokeLinejoin:"round"})})}function Sl(){return s.jsxs("div",{className:"dhc-loading",role:"status","aria-live":"polite",children:[s.jsx("div",{className:"dhc-spinner","aria-hidden":"true"}),s.jsx("span",{children:x.common.loading})]})}function ir({message:e,onRetry:t}){return s.jsxs("div",{className:"dhc-error",role:"alert",children:[s.jsx("span",{children:x.common.error(e)}),t&&s.jsx("button",{className:"dhc-btn dhc-btn--secondary",onClick:t,children:x.common.retry})]})}function et({message:e}){return s.jsx("div",{className:"dhc-empty",children:s.jsx("span",{children:e})})}function op({cols:e=4,rows:t=6}){const n=["60%","40%","75%","50%","65%","45%"];return s.jsx(s.Fragment,{children:Array.from({length:t}).map((r,l)=>s.jsx("tr",{className:"dhc-skel-row","aria-hidden":"true",children:Array.from({length:e}).map((i,o)=>s.jsx("td",{children:s.jsx("span",{className:"dhc-skel-cell",style:{width:n[(l*e+o)%n.length]}})},o))},l))})}const sp={Critique:yc,Avertissement:wc,Information:kc,"Non évaluable":kl},ap={Critique:"crit",Avertissement:"warn",Information:"info","Non évaluable":"ne"};function Bo({severity:e}){const t=ap[e]||"ne",n=sp[e]||kl;return s.jsxs("span",{className:`dhc-badge dhc-badge--${t}`,children:[s.jsx(n,{}),e]})}function Uo({status:e}){const n={Ouvert:"info",Corrigé:"ok",Accepté:"ne","En cours":"info",Terminé:"ok",Échoué:"crit"}[e]||"ne";return s.jsx("span",{className:`dhc-badge dhc-badge--${n}`,children:e})}function Sc({state:e}){const n={Modifié:"modif","Sans baseline":"absent",Inchangé:"inchange",Disparu:"absent"}[e]||"ne";return s.jsx("span",{className:`dhc-badge dhc-badge--${n}`,children:e})}function tt(e){return e?e.body&&e.body.message?e.body.message:e.message?e.message:String(e):"Erreur inconnue"}function Vo(e){if(!e)return"—";try{return new Intl.DateTimeFormat("fr-FR",{day:"2-digit",month:"2-digit",year:"numeric",hour:"2-digit",minute:"2-digit"}).format(new Date(e))}catch{return String(e)}}function Cc(e){if(!e)return null;try{return JSON.parse(e)}catch{return null}}const up={crit:yc,warn:wc,info:kc,ne:kl};function cp({api:e,onNavigate:t}){const[n,r]=P.useState(null),[l,i]=P.useState([]),[o,a]=P.useState(!0),[u,f]=P.useState(!1),[v,g]=P.useState(null),[m,y]=P.useState(!1),[C,S]=P.useState(""),[_,d]=P.useState(null),[c,p]=P.useState(!1),[h,j]=P.useState(!1),N=P.useCallback((E=!1)=>{let $=!1;return E?f(!0):a(!0),g(null),(async()=>{try{const ye=await e.getLatestDeployment();if($)return;if(r(ye),!ye){a(!1),f(!1);return}const mn=await e.getFindings({deploymentId:ye.id,componentId:null,severity:"Critique",status:null,pageSize:5,pageNumber:1});if($)return;i(mn?mn.findings||[]:[]),a(!1),f(!1)}catch(ye){$||(g(tt(ye)),a(!1),f(!1))}})(),()=>{$=!0}},[e]);P.useEffect(()=>N(!1),[N]);function w(E){if(E==="BASELINE"){p(!0);return}L(E)}function L(E){p(!1),j(!0),d(null),y(!1),e.startCapture(E).then(()=>{S(x.dashboard.launched),y(!0),j(!1)}).catch($=>{d(tt($)),j(!1)})}function O(){n&&(j(!0),d(null),y(!1),e.runRuleEngine(n.id).then(()=>{S(x.dashboard.reevLaunched),y(!0),j(!1)}).catch(E=>{d(tt(E)),j(!1)}))}const F=n?(n.criticalDelta||0)+(n.warningDelta||0)+(n.informationDelta||0):0,z=n&&n.componentCount||0;return o?s.jsx(Sl,{}):v&&!n?s.jsx(ir,{message:v,onRetry:()=>N(!1)}):s.jsxs("div",{className:"dhc-screen",children:[m&&s.jsxs("div",{className:"dhc-banner dhc-banner--success",role:"status",children:[C,s.jsx("button",{className:"dhc-banner-dismiss","aria-label":"Fermer",onClick:()=>{y(!1),S("")},children:"×"})]}),_&&s.jsxs("div",{className:"dhc-banner dhc-banner--error",role:"alert",children:[x.common.error(_),s.jsx("button",{className:"dhc-banner-dismiss","aria-label":"Fermer",onClick:()=>d(null),children:"×"})]}),v&&n&&s.jsx("div",{className:"dhc-banner dhc-banner--error",role:"alert",children:x.common.error(v)}),c&&s.jsx("div",{className:"dhc-dialog-overlay",role:"dialog","aria-modal":"true","aria-labelledby":"dlg-baseline-title",children:s.jsxs("div",{className:"dhc-dialog",children:[s.jsx("p",{id:"dlg-baseline-title",className:"dhc-dialog-title",children:x.dashboard.captureBaseline}),s.jsx("p",{className:"dhc-dialog-body",children:x.dashboard.baselineWarning}),s.jsxs("div",{className:"dhc-dialog-actions",children:[s.jsx("button",{className:"dhc-btn dhc-btn--secondary",onClick:()=>p(!1),children:x.dashboard.cancel}),s.jsx("button",{className:"dhc-btn dhc-btn--danger",onClick:()=>L("BASELINE"),autoFocus:!0,children:x.dashboard.baselineConfirm})]})]})}),n?s.jsxs("div",{className:u?"dhc-content--refreshing":void 0,children:[s.jsx("div",{className:"dhc-card",children:s.jsx("div",{className:"dhc-card-body",children:s.jsxs("div",{className:"dhc-release-bar",children:[s.jsxs("div",{className:"dhc-release-info",children:[s.jsx("span",{className:"dhc-release-label",children:n.releaseLabel||"Déploiement"}),s.jsx("span",{className:"dhc-release-time",children:Vo(n.runDate)}),s.jsx(Uo,{status:n.status})]}),s.jsxs("div",{className:"dhc-release-actions",children:[s.jsx("button",{className:"dhc-btn dhc-btn--primary",onClick:()=>w("CURRENT"),disabled:h,children:x.dashboard.captureCurrent}),s.jsx("button",{className:"dhc-btn dhc-btn--secondary",onClick:()=>w("BASELINE"),disabled:h,children:x.dashboard.captureBaseline}),s.jsx("button",{className:"dhc-btn dhc-btn--ghost",onClick:O,disabled:h||!n,title:"Applique les règles actives sans relancer la capture",children:x.dashboard.reevaluate}),m&&s.jsxs(s.Fragment,{children:[s.jsx("button",{className:"dhc-btn dhc-btn--ghost",onClick:()=>N(!0),disabled:h||u,children:x.dashboard.refresh}),u&&s.jsx("span",{className:"dhc-refreshing-hint",children:s.jsx("div",{className:"dhc-spinner dhc-spinner--sm","aria-hidden":"true"})})]})]})]})})}),F>0&&s.jsx("div",{className:"dhc-card",children:s.jsx("div",{className:"dhc-card-body",children:s.jsxs("div",{className:"dhc-verdict",children:[s.jsxs("div",{className:"dhc-verdict-text",children:[s.jsx("h2",{className:"dhc-verdict-headline",children:x.dashboard.verdictNew(F)}),s.jsx("p",{className:"dhc-verdict-desc",children:x.dashboard.verdictDesc})]}),s.jsx("button",{className:"dhc-btn dhc-btn--primary",onClick:()=>t("findings",{deploymentId:n.id}),children:x.dashboard.viewNewFindings(F)})]})})}),s.jsx("div",{className:"dhc-counters",children:gc.map(E=>{const $=up[E.cssClass]||kl,It=n[E.countField]??0,ye=n[E.deltaField]??null;return s.jsxs("div",{className:"dhc-counter",children:[s.jsxs("div",{className:"dhc-counter-header",children:[s.jsx("span",{style:{color:`var(--${E.cssClass==="ne"?"mut":E.cssClass})`},children:s.jsx($,{})}),s.jsx("span",{className:"dhc-counter-label",children:E.key})]}),s.jsxs("div",{className:"dhc-counter-row",children:[s.jsx("span",{className:"dhc-counter-value",style:{color:`var(--${E.cssClass==="ne"?"mut":E.cssClass})`},children:It}),ye!==null&&ye!==0&&s.jsx("span",{className:"dhc-counter-delta",style:{color:ye>0?"var(--crit)":"var(--ok)"},children:ye>0?`+${ye}`:ye})]})]},E.key)})}),s.jsxs("div",{className:"dhc-card",children:[s.jsx("div",{className:"dhc-card-body",style:{paddingBottom:0},children:s.jsx("div",{className:"dhc-overline",style:{marginBottom:18},children:x.dashboard.topCritical})}),l.length===0?s.jsx(et,{message:"Aucun constat critique."}):s.jsx("div",{children:l.map(E=>s.jsxs("div",{className:"dhc-finding-card",children:[s.jsx(Bo,{severity:E.severity}),s.jsxs("div",{className:"dhc-finding-body",children:[s.jsx("div",{className:"dhc-finding-message",children:E.message}),s.jsxs("div",{className:"dhc-finding-meta",children:[E.componentType&&s.jsx("span",{className:"dhc-type-badge",children:E.componentType}),E.componentLabel&&s.jsx("span",{className:"dhc-finding-label",children:E.componentLabel})]})]}),E.componentId&&s.jsx("button",{className:"dhc-btn dhc-btn--link",onClick:()=>t("comparison",{componentId:E.componentId,componentLabel:E.componentLabel||E.componentType||E.componentId,from:{screen:"dashboard",params:{}}}),children:x.dashboard.viewComponent})]},E.id))}),s.jsx("div",{className:"dhc-card-body",style:{paddingTop:14},children:s.jsxs("div",{className:"dhc-footer-bar",children:[s.jsx("span",{className:"dhc-footer-stat",children:x.dashboard.componentCount(z)}),s.jsx("button",{className:"dhc-btn dhc-btn--link",onClick:()=>t("findings",{deploymentId:n.id}),children:x.dashboard.viewAll})]})})]})]}):s.jsxs(s.Fragment,{children:[s.jsx(et,{message:x.dashboard.noDeployment}),s.jsxs("div",{style:{display:"flex",gap:8,flexWrap:"wrap"},children:[s.jsx("button",{className:"dhc-btn dhc-btn--primary",onClick:()=>w("CURRENT"),disabled:h,children:x.dashboard.captureCurrent}),s.jsx("button",{className:"dhc-btn dhc-btn--secondary",onClick:()=>w("BASELINE"),disabled:h,children:x.dashboard.captureBaseline})]})]})]})}const jc=20;function dp({api:e,onNavigate:t,params:n}){const[r,l]=P.useState(n?.deploymentId||null),[i,o]=P.useState({severity:n?.filters?.severity||"",status:n?.filters?.status||"",newOnly:!1,hideManaged:!1}),[a,u]=P.useState(n?.page||1),[f,v]=P.useState(null),[g,m]=P.useState(!0),[y,C]=P.useState(null),[S,_]=P.useState(0),[d,c]=P.useState({});P.useEffect(()=>{if(r)return;let z=!1;return m(!0),e.getLatestDeployment().then(E=>{z||l(E?.id||null)}).catch(E=>{z||(C(tt(E)),m(!1))}),()=>{z=!0}},[e]),P.useEffect(()=>{if(!r)return;let z=!1;return m(!0),C(null),e.getFindings({deploymentId:r,componentId:null,severity:i.severity||null,status:i.status||null,pageSize:jc,pageNumber:a}).then(E=>{z||(v(E),m(!1))}).catch(E=>{z||(C(tt(E)),m(!1))}),()=>{z=!0}},[e,r,i.severity,i.status,a,S]);function p(z,E){o($=>({...$,[z]:E})),u(1)}function h(z,E,$){return e.updateFindingStatus(z,E,$).then(()=>_(It=>It+1))}function j(z,E){t("comparison",{componentId:z,componentLabel:E,from:{screen:"findings",params:{deploymentId:r,filters:i,page:a}}})}function N(z){c(E=>({...E,[z]:!E[z]}))}const w=P.useMemo(()=>{if(!f||!f.findings)return[];const z=new Map;for(const E of f.findings){const $=E.ruleCode||"(sans règle)";z.has($)||z.set($,{ruleCode:$,severity:E.severity,findings:[]}),z.get($).findings.push(E)}return Array.from(z.values())},[f]),L=P.useMemo(()=>{let z=w;return i.newOnly&&(z=z.map(E=>({...E,findings:E.findings.filter($=>$.isNew)})).filter(E=>E.findings.length>0)),i.hideManaged&&(z=z.map(E=>({...E,findings:E.findings.filter($=>!$.isManaged)})).filter(E=>E.findings.length>0)),z},[w,i.newOnly,i.hideManaged]),O=f?Math.max(1,Math.ceil((f.totalCount||0)/jc)):1,F=L.reduce((z,E)=>z+E.findings.length,0);return y&&!f?s.jsx(ir,{message:y,onRetry:()=>_(z=>z+1)}):s.jsxs("div",{className:"dhc-screen",children:[s.jsxs("div",{children:[s.jsx("h1",{className:"dhc-screen-title",children:x.findings.title}),s.jsx("p",{className:"dhc-screen-subtitle",children:x.findings.subtitle})]}),s.jsxs("div",{className:"dhc-filter-bar",children:[s.jsxs("select",{className:"dhc-select",value:i.severity,onChange:z=>p("severity",z.target.value),"aria-label":x.findings.filterSev,children:[s.jsx("option",{value:"",children:x.findings.allSev}),gc.map(z=>s.jsx("option",{value:z.key,children:z.key},z.key))]}),s.jsxs("select",{className:"dhc-select",value:i.status,onChange:z=>p("status",z.target.value),"aria-label":x.findings.filterStatus,children:[s.jsx("option",{value:"",children:x.findings.allStatus}),vc.map(z=>s.jsx("option",{value:z,children:z},z))]}),s.jsx("div",{className:"dhc-filter-sep"}),s.jsxs("label",{className:"dhc-checkbox-label",children:[s.jsx("input",{type:"checkbox",className:"dhc-checkbox",checked:i.newOnly,onChange:z=>o(E=>({...E,newOnly:z.target.checked}))}),x.findings.newOnly]}),s.jsxs("label",{className:"dhc-checkbox-label",children:[s.jsx("input",{type:"checkbox",className:"dhc-checkbox",checked:i.hideManaged,onChange:z=>o(E=>({...E,hideManaged:z.target.checked}))}),x.findings.hideManaged]})]}),y&&f&&s.jsx("div",{className:"dhc-banner dhc-banner--error",role:"alert",children:x.common.error(y)}),g&&!f?s.jsx("div",{className:"dhc-card",children:s.jsx("div",{className:"dhc-table-wrap",children:s.jsxs("table",{className:"dhc-table","aria-label":x.findings.title,"aria-busy":"true",children:[s.jsx("thead",{children:s.jsxs("tr",{children:[s.jsx("th",{children:x.findings.colSev}),s.jsx("th",{children:x.findings.colRule}),s.jsx("th",{children:x.findings.colComponent}),s.jsx("th",{children:x.findings.colMessage}),s.jsx("th",{children:x.findings.colStatus}),s.jsx("th",{children:x.findings.colActions})]})}),s.jsx("tbody",{children:s.jsx(op,{cols:6,rows:8})})]})})}):!f||L.length===0?s.jsx(et,{message:x.findings.noFindings}):s.jsxs(s.Fragment,{children:[s.jsx("div",{style:{display:"flex",flexDirection:"column",gap:14},className:g?"dhc-content--refreshing":void 0,children:L.map(z=>s.jsx(fp,{group:z,isCollapsed:!!d[z.ruleCode],onToggle:()=>N(z.ruleCode),onUpdate:h,onViewComponent:j},z.ruleCode))}),s.jsxs("div",{className:"dhc-pagination",children:[s.jsx("button",{className:"dhc-btn dhc-btn--secondary",onClick:()=>u(z=>z-1),disabled:a<=1||g,children:x.findings.prev}),s.jsx("span",{className:"dhc-pagination-info",children:x.findings.findingCount(F,f.totalCount)}),s.jsx("button",{className:"dhc-btn dhc-btn--secondary",onClick:()=>u(z=>z+1),disabled:a>=O||g,children:x.findings.next})]})]})]})}function fp({group:e,isCollapsed:t,onToggle:n,onUpdate:r,onViewComponent:l}){return s.jsxs("div",{className:"dhc-group",children:[s.jsxs("div",{className:"dhc-group-header",onClick:n,role:"button",tabIndex:0,"aria-expanded":!t,onKeyDown:i=>{(i.key==="Enter"||i.key===" ")&&(i.preventDefault(),n())},children:[s.jsx(ip,{open:!t}),s.jsx(Bo,{severity:e.severity}),s.jsx("span",{className:"dhc-group-rule",children:e.ruleCode}),s.jsxs("span",{className:"dhc-group-count",children:[e.findings.length," constat",e.findings.length>1?"s":""]})]}),!t&&e.findings.map(i=>s.jsx(pp,{finding:i,onUpdate:r,onViewComponent:l},i.id))]})}function pp({finding:e,onUpdate:t,onViewComponent:n}){const[r,l]=P.useState(e.status),[i,o]=P.useState(e.justification||""),[a,u]=P.useState(!1),[f,v]=P.useState(null),g=r!==e.status,m=g&&r!=="Ouvert",y=g&&(!m||i.trim().length>0);function C(){u(!0),v(null),t(e.id,r,i.trim()||null).catch(_=>{v(tt(_)),u(!1)})}function S(){l(e.status),o(e.justification||""),v(null)}return s.jsxs("div",{className:"dhc-group-item",style:{flexDirection:"column",alignItems:"stretch"},children:[s.jsxs("div",{style:{display:"flex",flexWrap:"wrap",gap:14,alignItems:"center"},children:[e.componentType&&s.jsx("span",{className:"dhc-type-badge",children:e.componentType}),s.jsxs("div",{className:"dhc-group-item-body",children:[s.jsx("div",{style:{fontSize:14,fontWeight:500,marginBottom:4},children:e.componentLabel||e.componentId||"—"}),e.componentId&&s.jsx("span",{className:"dhc-api-name",children:e.componentId})]}),s.jsx("label",{htmlFor:`status-${e.id}`,className:"dhc-sr-only",children:x.findings.editStatus}),s.jsx("select",{id:`status-${e.id}`,className:"dhc-select",value:r,onChange:_=>l(_.target.value),disabled:a,style:{minWidth:120},children:vc.map(_=>s.jsx("option",{value:_,children:_},_))}),g?s.jsxs("div",{className:"dhc-inline-actions",children:[s.jsx("button",{className:"dhc-btn dhc-btn--primary",onClick:C,disabled:!y||a,style:{minHeight:36},children:a?"...":x.findings.save}),s.jsx("button",{className:"dhc-btn dhc-btn--secondary",onClick:S,disabled:a,style:{minHeight:36},children:x.findings.cancel})]}):s.jsx(Uo,{status:e.status}),e.componentId&&s.jsx("button",{className:"dhc-btn dhc-btn--link",onClick:()=>n(e.componentId,e.componentLabel||e.componentId),children:x.findings.detail})]}),g&&m&&s.jsxs("div",{className:"dhc-expand-inner",style:{marginTop:10,borderRadius:8},children:[s.jsx("span",{className:"dhc-expand-title",children:x.findings.justLabel}),s.jsx("textarea",{className:"dhc-textarea",rows:3,placeholder:x.findings.justLabel,value:i,onChange:_=>o(_.target.value),disabled:a,autoFocus:!0}),s.jsx("span",{className:"dhc-field-hint",children:x.findings.justHint}),f&&s.jsx("span",{style:{color:"var(--crit)",fontSize:12},role:"alert",children:f})]}),g&&!m&&f&&s.jsx("span",{style:{color:"var(--crit)",fontSize:12,marginTop:8},role:"alert",children:f})]})}function Ho(e,t,n){const r=e!==null&&Object.prototype.hasOwnProperty.call(e,n),l=t!==null&&Object.prototype.hasOwnProperty.call(t,n);return!r&&l?"added":r&&!l?"removed":JSON.stringify(e[n])===JSON.stringify(t[n])?"same":"changed"}function Cl(e){if(e==null)return s.jsx("span",{className:"dhc-text-muted",style:{fontStyle:"italic"},children:"null"});if(typeof e=="boolean")return s.jsx("span",{className:"dhc-diff-val",children:e?"vrai":"faux"});if(typeof e=="object"){const t=Object.entries(e).sort(([n],[r])=>n.localeCompare(r));return t.length===0?s.jsx("span",{className:"dhc-text-muted",children:"{ }"}):s.jsx("div",{children:t.map(([n,r])=>s.jsxs("div",{className:"dhc-access-block",children:[s.jsx("div",{className:"dhc-access-perm-name",children:n}),s.jsx("div",{className:"dhc-access-pills",children:hp(String(r))})]},n))})}return s.jsx("span",{className:"dhc-diff-val",children:String(e)})}function hp(e){if(!e)return null;const t={r:"Lecture",c:"Création",e:"Modification",d:"Suppression"};return e.split("").map((n,r)=>s.jsx("span",{className:"dhc-access-pill",children:t[n]||n.toUpperCase()},r))}function mp({api:e,onNavigate:t,params:n}){const{componentId:r,componentLabel:l,from:i}=n||{},[o,a]=P.useState(null),[u,f]=P.useState([]),[v,g]=P.useState(!0),[m,y]=P.useState(null),[C,S]=P.useState(!1);P.useEffect(()=>{if(!r){g(!1);return}let w=!1;return(async()=>{try{const[O,F]=await Promise.all([e.getComponentDetail(r),e.getLatestDeployment()]);if(w)return;if(a(O),!O||!F){g(!1);return}const z=await e.getFindings({deploymentId:F.id,componentId:r,severity:null,status:null,pageSize:50,pageNumber:1});if(w)return;f(z?z.findings||[]:[]),g(!1)}catch(O){w||(y(tt(O)),g(!1))}})(),()=>{w=!0}},[e,r]);function _(){i?t(i.screen,i.params):t("dashboard",{})}if(v)return s.jsx(Sl,{});if(m)return s.jsx(ir,{message:m,onRetry:()=>t("comparison",n)});if(!r||!o)return s.jsxs("div",{className:"dhc-screen",children:[s.jsxs("button",{className:"dhc-back-link",onClick:_,children:[s.jsx(xc,{})," ",x.comparison.back]}),s.jsx(et,{message:x.comparison.noComponent})]});const d=Cc(o.baselineState),c=Cc(o.currentState),p=Array.from(new Set([...Object.keys(d||{}),...Object.keys(c||{})])).sort(),h=p.filter(w=>Ho(d,c,w)!=="same"),j=p.filter(w=>Ho(d,c,w)==="same"),N=o.hasChanged?"Modifié":o.isAbsent?"Sans baseline":"Inchangé";return s.jsxs("div",{className:"dhc-screen",children:[s.jsx("div",{className:"dhc-comp-nav",children:s.jsxs("button",{className:"dhc-back-link",onClick:_,children:[s.jsx(xc,{})," ",x.comparison.back]})}),s.jsx("div",{className:"dhc-card",children:s.jsxs("div",{className:"dhc-identity",children:[s.jsxs("div",{className:"dhc-identity-badges",children:[o.componentType&&s.jsx("span",{className:"dhc-type-badge",children:o.componentType}),s.jsx(Sc,{state:N}),o.hasChanged&&s.jsx("span",{className:"dhc-badge dhc-badge--new",children:"NEW"})]}),s.jsx("h1",{className:"dhc-identity-title",children:l||o.label||o.apiName}),s.jsxs("div",{className:"dhc-identity-meta",children:[s.jsx("span",{className:"dhc-api-name",children:o.apiName||"—"}),s.jsxs("span",{className:"dhc-identity-desc",children:[o.changeCount??0," changement",(o.changeCount??0)>1?"s":""," détecté",(o.changeCount??0)>1?"s":""]})]})]})}),p.length===0?s.jsx(et,{message:x.comparison.noState}):s.jsxs("div",{className:"dhc-card",children:[s.jsxs("div",{className:"dhc-diff-head",children:[s.jsx("div",{className:"dhc-diff-head-cell",children:s.jsx("div",{className:"dhc-diff-head-label",children:x.comparison.colAttr})}),s.jsxs("div",{className:"dhc-diff-head-cell",children:[s.jsx("div",{className:"dhc-diff-head-label",children:x.comparison.baselineDate}),o.baselineDate&&s.jsx("div",{className:"dhc-diff-head-date",children:Vo(o.baselineDate)})]}),s.jsxs("div",{className:"dhc-diff-head-cell",children:[s.jsx("div",{className:"dhc-diff-head-label",children:x.comparison.currentDate}),o.currentDate&&s.jsx("div",{className:"dhc-diff-head-date",children:Vo(o.currentDate)})]})]}),h.map(w=>{const L=Ho(d,c,w),O=d?d[w]:void 0,F=c?c[w]:void 0;return s.jsxs("div",{className:"dhc-diff-row",children:[s.jsxs("div",{className:"dhc-diff-attr",children:[s.jsx("div",{className:"dhc-diff-attr-name",children:w}),s.jsx("span",{className:`dhc-badge dhc-badge--${L==="added"?"ok":L==="removed"?"crit":"warn"}`,style:{fontSize:10,padding:"2px 7px"},children:L==="added"?"Ajouté":L==="removed"?"Supprimé":"Modifié"})]}),s.jsx("div",{className:"dhc-diff-cell dhc-diff-cell--baseline",children:L==="added"?s.jsx("span",{className:"dhc-text-muted",style:{fontStyle:"italic"},children:x.comparison.absent}):Cl(O)}),s.jsx("div",{className:"dhc-diff-cell dhc-diff-cell--current",children:L==="removed"?s.jsx("span",{className:"dhc-text-muted",style:{fontStyle:"italic"},children:x.comparison.absent}):Cl(F)})]},w)}),j.length>0&&s.jsxs("div",{className:"dhc-diff-collapsed",children:[s.jsx("span",{className:"dhc-diff-collapsed-info",children:x.comparison.identicalCount(j.length)}),s.jsx("button",{className:"dhc-btn dhc-btn--link",onClick:()=>S(w=>!w),children:C?x.comparison.hideIdentical:x.comparison.showIdentical})]}),C&&j.map(w=>{const L=d?d[w]:c?c[w]:void 0;return s.jsxs("div",{className:"dhc-diff-row",style:{opacity:.6},children:[s.jsxs("div",{className:"dhc-diff-attr",children:[s.jsx("div",{className:"dhc-diff-attr-name",children:w}),s.jsx("span",{className:"dhc-badge dhc-badge--ne",style:{fontSize:10,padding:"2px 7px"},children:"Identique"})]}),s.jsx("div",{className:"dhc-diff-cell dhc-diff-cell--baseline",children:Cl(L)}),s.jsx("div",{className:"dhc-diff-cell dhc-diff-cell--current",children:Cl(L)})]},w)})]}),s.jsxs("div",{className:"dhc-card",children:[s.jsx("div",{className:"dhc-verdict-section-head",children:s.jsx("span",{className:"dhc-overline",children:x.comparison.findingsTitle})}),u.length===0?s.jsx(et,{message:x.comparison.noFindings}):s.jsx("div",{children:u.map(w=>s.jsxs("div",{className:"dhc-verdict-row",children:[s.jsx(Bo,{severity:w.severity}),s.jsx("span",{className:"dhc-verdict-msg",children:w.message}),s.jsx("span",{className:"dhc-verdict-rule",children:w.ruleCode||"—"}),s.jsx(Uo,{status:w.status})]},w.id))})]}),(o.baselineHash||o.currentHash)&&s.jsxs("div",{className:"dhc-fingerprint",children:[s.jsx("span",{className:"dhc-overline",style:{flexShrink:0},children:x.comparison.fingerprint}),s.jsxs("span",{className:"dhc-fingerprint-hash",children:[o.baselineHash&&`Baseline: ${o.baselineHash}`,o.baselineHash&&o.currentHash&&" | ",o.currentHash&&`Current: ${o.currentHash}`]})]})]})}function gp({api:e,onNavigate:t}){const[n,r]=P.useState([]),[l,i]=P.useState(!0),[o,a]=P.useState(null),[u,f]=P.useState(""),[v,g]=P.useState(""),[m,y]=P.useState("");P.useEffect(()=>{let h=!1;return i(!0),(async()=>{try{let N=[];if(e.getComponents)N=await e.getComponents()||[];else{const w=await e.getLatestDeployment();w&&e.getDeploymentComponents&&(N=await e.getDeploymentComponents(w.id)||[])}h||(r(N),i(!1))}catch(N){h||(a(tt(N)),i(!1))}})(),()=>{h=!0}},[e]);function C(h){return h.isAbsent||h.isMissing?"Disparu":!h.hasBaseline&&!h.baselineState?"Sans baseline":h.hasChanged?"Modifié":"Inchangé"}const S=P.useMemo(()=>n.map(h=>({...h,state:C(h)})),[n]),_=P.useMemo(()=>{const h=new Set(S.map(j=>j.componentType).filter(Boolean));return Array.from(h).sort()},[S]),d=P.useMemo(()=>{let h=S;if(u){const j=u.toLowerCase();h=h.filter(N=>(N.label||"").toLowerCase().includes(j)||(N.apiName||"").toLowerCase().includes(j))}return v&&(h=h.filter(j=>j.componentType===v)),m&&(h=h.filter(j=>j.state===m)),h},[S,u,v,m]),c=P.useMemo(()=>({unchanged:S.filter(h=>h.state==="Inchangé").length,modified:S.filter(h=>h.state==="Modifié").length,noBaseline:S.filter(h=>h.state==="Sans baseline").length,missing:S.filter(h=>h.state==="Disparu").length}),[S]);function p(h){t("comparison",{componentId:h.id,componentLabel:h.label||h.apiName,from:{screen:"components",params:{}}})}return l?s.jsx(Sl,{}):o?s.jsx(ir,{message:o,onRetry:()=>window.location.reload()}):s.jsxs("div",{className:"dhc-screen",children:[s.jsxs("div",{children:[s.jsx("h1",{className:"dhc-screen-title",children:x.components.title}),s.jsx("p",{className:"dhc-screen-subtitle",children:x.components.subtitle})]}),s.jsxs("div",{className:"dhc-comp-counters",children:[s.jsx(jl,{value:c.unchanged,label:x.components.unchangedCount,color:"var(--txt3)"}),s.jsx(jl,{value:c.modified,label:x.components.modifiedCount,color:"var(--warn)"}),s.jsx(jl,{value:c.noBaseline,label:x.components.noBaselineCount,color:"var(--mut)"}),s.jsx(jl,{value:c.missing,label:x.components.missingCount,color:"var(--crit)"})]}),s.jsxs("div",{className:"dhc-filter-bar",children:[s.jsx("input",{type:"text",className:"dhc-search-input",placeholder:x.components.search,value:u,onChange:h=>f(h.target.value),"aria-label":x.components.search}),s.jsxs("select",{className:"dhc-select",value:v,onChange:h=>g(h.target.value),"aria-label":x.components.filterType,children:[s.jsx("option",{value:"",children:x.components.allTypes}),_.map(h=>s.jsx("option",{value:h,children:h},h))]}),s.jsxs("select",{className:"dhc-select",value:m,onChange:h=>y(h.target.value),"aria-label":x.components.filterState,children:[s.jsx("option",{value:"",children:x.components.allStates}),s.jsx("option",{value:"Inchangé",children:x.components.stateUnchanged}),s.jsx("option",{value:"Modifié",children:x.components.stateModified}),s.jsx("option",{value:"Sans baseline",children:x.components.stateNoBaseline}),s.jsx("option",{value:"Disparu",children:x.components.stateMissing})]})]}),d.length===0?s.jsx(et,{message:x.components.noComponents}):s.jsx("div",{className:"dhc-card",children:s.jsxs("table",{className:"dhc-table","aria-label":x.components.title,children:[s.jsx("thead",{children:s.jsxs("tr",{children:[s.jsx("th",{children:x.components.colName}),s.jsx("th",{children:x.components.colType}),s.jsx("th",{children:x.components.colState}),s.jsx("th",{children:x.components.colFindings}),s.jsx("th",{children:x.components.colActions})]})}),s.jsx("tbody",{children:d.map(h=>s.jsxs("tr",{className:h.state==="Modifié"?"dhc-table-highlight":void 0,children:[s.jsxs("td",{children:[s.jsx("div",{className:"dhc-table-name",children:h.label||h.apiName}),s.jsx("span",{className:"dhc-api-name",children:h.apiName})]}),s.jsx("td",{children:s.jsx("span",{className:"dhc-type-badge",children:h.componentType||"—"})}),s.jsx("td",{children:s.jsx(Sc,{state:h.state})}),s.jsx("td",{style:{fontVariantNumeric:"tabular-nums"},children:h.findingCount??0}),s.jsx("td",{children:s.jsx("button",{className:"dhc-btn dhc-btn--link",onClick:()=>p(h),children:x.components.viewDetail})})]},h.id))})]})})]})}function jl({value:e,label:t,color:n}){return s.jsxs("div",{className:"dhc-comp-counter",children:[s.jsx("div",{className:"dhc-comp-counter-value",style:{color:n},children:e}),s.jsx("div",{className:"dhc-comp-counter-label",children:t})]})}const Nc=10;function vp({api:e}){const[t,n]=P.useState([]),[r,l]=P.useState([]),[i,o]=P.useState(!0),[a,u]=P.useState(null),[f,v]=P.useState(!1);P.useEffect(()=>{let _=!1;return Promise.all([e.getCaptureScopeConfig(),e.getActiveRules()]).then(([d,c])=>{_||(n(d||[]),l(c||[]),o(!1))}).catch(d=>{_||(u(tt(d)),o(!1))}),()=>{_=!0}},[e]);const g=P.useMemo(()=>{const _={};for(const d of r){const c=d.componentType||"(sans type)";_[c]||(_[c]=[]),_[c].push(d)}return _},[r]),m=P.useMemo(()=>Object.keys(g).sort(),[g]),y=P.useMemo(()=>{const _=[];for(const d of m){_.push({isHeader:!0,type:d});for(const c of g[d])_.push({isHeader:!1,rule:c})}return _},[m,g]),C=f?y:y.slice(0,Nc),S=y.length-C.length;return i?s.jsx(Sl,{}):a?s.jsx(ir,{message:a,onRetry:()=>window.location.reload()}):s.jsxs("div",{className:"dhc-screen",children:[s.jsx("div",{className:"dhc-config-head",children:s.jsxs("div",{className:"dhc-config-head-text",children:[s.jsx("h1",{className:"dhc-screen-title",children:x.config.title}),s.jsx("p",{className:"dhc-config-desc",children:x.config.subtitle})]})}),s.jsx("div",{className:"dhc-notice",role:"note",children:s.jsx("span",{children:x.config.readOnly})}),s.jsxs("section",{children:[s.jsx("h2",{className:"dhc-section-title",children:x.config.scopesTitle}),t.length===0?s.jsx(et,{message:x.config.noScopes}):s.jsx("div",{className:"dhc-card",children:t.map((_,d)=>s.jsxs("div",{children:[s.jsxs("div",{className:"dhc-scope-row",children:[s.jsx("span",{className:"dhc-scope-type",children:_.componentType||"—"}),s.jsx("span",{className:"dhc-scope-desc",children:_.label||""}),s.jsx("span",{className:`dhc-badge ${_.isActive?"dhc-badge--ok":"dhc-badge--ne"}`,children:_.isActive?x.config.yes:x.config.no}),_.targetObjects&&s.jsx("span",{className:"dhc-scope-count",children:x.config.scopeNote(_.targetObjects.split(",").filter(Boolean).length)})]}),_.targetObjects&&s.jsx("div",{className:"dhc-scope-row",style:{paddingTop:0},children:s.jsx("div",{className:"dhc-chips",style:{marginLeft:148},children:_.targetObjects.split(",").map(c=>c.trim()).filter(Boolean).map((c,p)=>s.jsx("span",{className:"dhc-chip",children:c},p))})})]},d))})]}),s.jsxs("section",{children:[s.jsx("h2",{className:"dhc-section-title",children:x.config.rulesTitle}),r.length===0?s.jsx(et,{message:x.config.noRules}):s.jsx("div",{className:"dhc-card",children:C.map((_,d)=>{if(_.isHeader)return s.jsx("div",{className:"dhc-rule-type-header",children:s.jsx("span",{className:"dhc-overline",children:_.type})},`h-${_.type}`);const c=_.rule,p=c.isActive===!1,h=p?"dhc-rule-dot--disabled":c.severity==="Critique"?"dhc-rule-dot--crit":c.severity==="Avertissement"?"dhc-rule-dot--warn":"dhc-rule-dot--info";return s.jsxs("div",{className:`dhc-rule-row${p?" dhc-rule-row--disabled":""}`,children:[s.jsx("div",{className:`dhc-rule-dot ${h}`}),s.jsx("span",{className:`dhc-rule-msg${p?" dhc-rule-msg--disabled":""}`,children:c.message||c.code||"—"}),c.attribute&&s.jsxs("span",{className:"dhc-rule-expr",children:[c.attribute,c.operator?` ${c.operator}`:"",c.expectedValue?` "${c.expectedValue}"`:""]}),c.code&&s.jsx("span",{className:"dhc-rule-expr",children:c.code}),p&&s.jsx("span",{className:"dhc-badge dhc-badge--disabled",children:"DÉSACTIVÉE"})]},`r-${d}`)})}),S>0&&s.jsxs("div",{className:"dhc-rules-footer",children:[s.jsx("span",{className:"dhc-rules-footer-info",children:x.config.moreRules(S)}),s.jsx("button",{className:"dhc-btn dhc-btn--link",onClick:()=>v(!0),children:x.config.showAll})]}),f&&y.length>Nc&&s.jsx("div",{className:"dhc-rules-footer",children:s.jsx("button",{className:"dhc-btn dhc-btn--link",onClick:()=>v(!1),children:"Réduire"})})]})]})}const Nl=new Map,xp=[{key:"dashboard",label:x.nav.dashboard},{key:"findings",label:x.nav.findings},{key:"comparison",label:x.nav.comparison},{key:"components",label:x.nav.components},{key:"config",label:x.nav.config}];function yp({theme:e,setTheme:t}){return s.jsxs("div",{className:"dhc-theme-group",role:"radiogroup","aria-label":"Thème",children:[s.jsxs("button",{className:`dhc-theme-btn${e==="light"?" dhc-theme-btn--active":""}`,onClick:()=>t("light"),role:"radio","aria-checked":e==="light",children:[s.jsx(rp,{})," Clair"]}),s.jsxs("button",{className:`dhc-theme-btn${e==="dark"?" dhc-theme-btn--active":""}`,onClick:()=>t("dark"),role:"radio","aria-checked":e==="dark",children:[s.jsx(lp,{})," Sombre"]})]})}function wp({current:e,onNavigate:t}){return s.jsx("nav",{className:"dhc-nav","aria-label":"Navigation DHC",children:xp.map(n=>s.jsx("button",{className:`dhc-nav-btn${e===n.key?" dhc-nav-btn--active":""}`,onClick:()=>t(n.key,{}),"aria-current":e===n.key?"page":void 0,children:n.label},n.key))})}function kp({api:e}){const[t,n]=P.useState({screen:"dashboard",params:{}}),[r,l]=P.useState("light"),[i,o]=P.useState(""),a=P.useCallback((u,f={})=>{n({screen:u,params:f});const v={dashboard:x.nav.dashboard,findings:x.nav.findings,comparison:x.nav.comparison,components:x.nav.components,config:x.nav.config};o(`Écran : ${v[u]||u}`)},[]);return s.jsxs("div",{className:"dhc","data-theme":r,children:[s.jsx("div",{"aria-live":"polite","aria-atomic":"true",className:"dhc-sr-only",children:i}),s.jsxs("header",{className:"dhc-header",role:"banner",children:[s.jsxs("div",{className:"dhc-header-left",children:[s.jsx("div",{className:"dhc-header-logo",children:s.jsx(np,{})}),s.jsx("h1",{className:"dhc-header-title",children:"Deployment Health Check"})]}),s.jsx("div",{className:"dhc-header-right",children:s.jsx(yp,{theme:r,setTheme:l})})]}),s.jsx(wp,{current:t.screen,onNavigate:a}),t.screen==="dashboard"&&s.jsx(cp,{api:e,onNavigate:a}),t.screen==="findings"&&s.jsx(dp,{api:e,onNavigate:a,params:t.params}),t.screen==="comparison"&&s.jsx(mp,{api:e,onNavigate:a,params:t.params}),t.screen==="components"&&s.jsx(gp,{api:e,onNavigate:a}),t.screen==="config"&&s.jsx(vp,{api:e})]})}function Sp(e,t){if(Nl.has(e))return;tp();const n=hc(e);n.render(Uc.createElement(kp,{api:t})),Nl.set(e,n)}function Cp(e){const t=Nl.get(e);t&&(t.unmount(),Nl.delete(e))}window.DHC_UI={mount:Sp,unmount:Cp}})();
