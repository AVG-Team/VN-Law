import{r,j as e}from"./index-9L6wJ83p.js";function x(){const[t,a]=r.useState(""),[s,n]=r.useState(""),[i,o]=r.useState(""),d=l=>{l.preventDefault(),alert(`Form submitted:
Name: ${t}
Email: ${s}
Message: ${i}`),m()},m=()=>{a(""),n(""),o("")};return e.jsxs("form",{onSubmit:d,action:"#",className:"w-full lg:w-8/12 border-solid border-2 rounded p-4 space-y-8 lg:pr-5 order-2 lg:order-1",children:[e.jsxs("div",{children:[e.jsx("label",{htmlFor:"name",className:"block mb-1 text-sm font-medium",children:"Họ và tên"}),e.jsx("input",{type:"text",value:t,onChange:l=>a(l.target.value),id:"name",className:"block p-3 w-full text-sm  rounded-lg border shadow-sm focus:ring-primary-3000 ",placeholder:"Nhập họ và tên",required:!0})]}),e.jsxs("div",{children:[e.jsx("label",{htmlFor:"email",className:"block mb-1 text-sm font-medium",children:"Email"}),e.jsx("input",{type:"email",value:s,onChange:l=>n(l.target.value),id:"email",className:"shadow-sm  border  text-sm rounded-lg focus:ring-primary-3000  block w-full p-2.5",placeholder:"Nhập địa chỉ email",required:!0})]}),e.jsxs("div",{className:"sm:col-span-2",children:[e.jsx("label",{htmlFor:"message",className:"block mb-1 text-sm font-medium",children:"Nội dung"}),e.jsx("textarea",{id:"message",value:i,onChange:l=>o(l.target.value),rows:"6",className:"block p-2.5 w-full text-sm  rounded-lg shadow-sm border  focus:ring-primary-3000 ",placeholder:"Nhập nội dung",required:!0})]}),e.jsx("button",{type:"submit",className:"py-3 px-5 text-sm font-medium bg-[#4F46E5] text-center text-white rounded-lg sm:w-fit hover:bg-primary-700 focus:ring-4 focus:outline-none focus:ring-primary-800 dark:bg-primary-700 dark:hover:bg-primary-800 dark:focus:ring-primary-800 lg:float-left lg:mr-2 flex justify-center mx-auto",children:"Gửi tin nhắn"})]})}const h=[{platform:"Facebook",url:"https://www.facebook.com/avg.team"},{platform:"Github",url:"https://github.com/AVG-Team"}];function u({title:t,titleId:a,...s},n){return r.createElement("svg",Object.assign({xmlns:"http://www.w3.org/2000/svg",viewBox:"0 0 24 24",fill:"currentColor","aria-hidden":"true","data-slot":"icon",ref:n,"aria-labelledby":a},s),t?r.createElement("title",{id:a},t):null,r.createElement("path",{fillRule:"evenodd",d:"M19.902 4.098a3.75 3.75 0 0 0-5.304 0l-4.5 4.5a3.75 3.75 0 0 0 1.035 6.037.75.75 0 0 1-.646 1.353 5.25 5.25 0 0 1-1.449-8.45l4.5-4.5a5.25 5.25 0 1 1 7.424 7.424l-1.757 1.757a.75.75 0 1 1-1.06-1.06l1.757-1.757a3.75 3.75 0 0 0 0-5.304Zm-7.389 4.267a.75.75 0 0 1 1-.353 5.25 5.25 0 0 1 1.449 8.45l-4.5 4.5a5.25 5.25 0 1 1-7.424-7.424l1.757-1.757a.75.75 0 1 1 1.06 1.06l-1.757 1.757a3.75 3.75 0 1 0 5.304 5.304l4.5-4.5a3.75 3.75 0 0 0-1.035-6.037.75.75 0 0 1-.354-1Z",clipRule:"evenodd"}))}const c=r.forwardRef(u);function g({title:t,titleId:a,...s},n){return r.createElement("svg",Object.assign({xmlns:"http://www.w3.org/2000/svg",viewBox:"0 0 24 24",fill:"currentColor","aria-hidden":"true","data-slot":"icon",ref:n,"aria-labelledby":a},s),t?r.createElement("title",{id:a},t):null,r.createElement("path",{fillRule:"evenodd",d:"M8.25 6.75a3.75 3.75 0 1 1 7.5 0 3.75 3.75 0 0 1-7.5 0ZM15.75 9.75a3 3 0 1 1 6 0 3 3 0 0 1-6 0ZM2.25 9.75a3 3 0 1 1 6 0 3 3 0 0 1-6 0ZM6.31 15.117A6.745 6.745 0 0 1 12 12a6.745 6.745 0 0 1 6.709 7.498.75.75 0 0 1-.372.568A12.696 12.696 0 0 1 12 21.75c-2.305 0-4.47-.612-6.337-1.684a.75.75 0 0 1-.372-.568 6.787 6.787 0 0 1 1.019-4.38Z",clipRule:"evenodd"}),r.createElement("path",{d:"M5.082 14.254a8.287 8.287 0 0 0-1.308 5.135 9.687 9.687 0 0 1-1.764-.44l-.115-.04a.563.563 0 0 1-.373-.487l-.01-.121a3.75 3.75 0 0 1 3.57-4.047ZM20.226 19.389a8.287 8.287 0 0 0-1.308-5.135 3.75 3.75 0 0 1 3.57 4.047l-.01.121a.563.563 0 0 1-.373.486l-.115.04c-.567.2-1.156.349-1.764.441Z"}))}const f=r.forwardRef(g);function p(t){switch(t){case"Facebook":return e.jsxs("svg",{width:"37px",height:"37px",viewBox:"0 0 16 16",xmlns:"http://www.w3.org/2000/svg",fill:"none",children:[e.jsx("g",{id:"SVGRepo_bgCarrier"}),e.jsx("g",{id:"SVGRepo_tracerCarrier"}),e.jsxs("g",{id:"SVGRepo_iconCarrier",children:[e.jsx("path",{fill:"#1877F2",d:"M15 8a7 7 0 00-7-7 7 7 0 00-1.094 13.915v-4.892H5.13V8h1.777V6.458c0-1.754 1.045-2.724 2.644-2.724.766 0 1.567.137 1.567.137v1.723h-.883c-.87 0-1.14.54-1.14 1.093V8h1.941l-.31 2.023H9.094v4.892A7.001 7.001 0 0015 8z"}),e.jsx("path",{fill:"#ffffff",d:"M10.725 10.023L11.035 8H9.094V6.687c0-.553.27-1.093 1.14-1.093h.883V3.87s-.801-.137-1.567-.137c-1.6 0-2.644.97-2.644 2.724V8H5.13v2.023h1.777v4.892a7.037 7.037 0 002.188 0v-4.892h1.63z"})]})]});case"Github":return e.jsx("svg",{fill:"currentColor",width:"35px",height:"35px",viewBox:"0 0 16 16",xmlns:"http://www.w3.org/2000/svg","aria-hidden":"true",children:e.jsx("path",{d:"M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"})});default:return e.jsx(c,{})}}function b(){return e.jsxs("div",{className:"flex flex-row justify-center order-1 w-full mx-auto mt-5 text-center lg:w-4/12 dark:text-gray-900 lg:flex-col gap-7 lg:mt-0 lg:order-2",children:[e.jsxs("div",{children:[e.jsx("div",{className:"flex items-center w-16 h-16 p-4 mx-auto bg-gray-300 rounded-md",children:e.jsx(f,{})}),e.jsx("p",{className:"pt-3 text-lg font-bold",children:"Thông tin:"}),e.jsx("p",{children:"AVG Team"})]}),e.jsxs("div",{children:[e.jsx("div",{className:"flex items-center w-16 h-16 p-4 mx-auto bg-gray-300 rounded-md",children:e.jsx(c,{})}),e.jsx("p",{className:"pt-3 text-lg font-bold",children:"Liên kết:"}),e.jsx("div",{className:"flex justify-center pb-5 lg:flex-row",children:h.map(t=>e.jsx("a",{className:"px-2",href:t.url,target:"blank",children:p(t.platform)},t.platform))})]})]})}function j(t){return e.jsxs("section",{children:[e.jsxs("div",{className:"max-w-screen-lg py-4 mx-auto lg:py-12 pe-2 ps-2",children:[e.jsx("h2",{className:"mb-4 text-4xl font-extrabold tracking-tight text-center dark:text-gray-900",children:"Liên hệ"}),e.jsxs("p",{className:"mb-8 font-light text-center text-gray-400 lg:mb-5 dark:text-gray-3000 sm:text-xl",children:["Chúng tôi mong muốn lắng nghe ý kiến của bạn. Vui lòng gửi mọi yêu cầu thắc mắc theo thông tin bên dưới, chúng tôi sẽ liên lạc với bạn sớm nhất có thể."," "]}),e.jsxs("div",{className:"flex flex-col lg:flex-row",children:[e.jsx(x,{}),e.jsx(b,{})]})]}),e.jsx("div",{className:"w-full mx-auto max-w-container",children:e.jsx("iframe",{src:"https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3918.427642206537!2d106.78279807580208!3d10.855042689298537!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x317527c3debb5aad%3A0x5fb58956eb4194d0!2zxJDhuqFpIEjhu41jIEh1dGVjaCBLaHUgRQ!5e0!3m2!1sen!2s!4v1713204707972!5m2!1sen!2s",title:"Google Maps",width:"100%",height:"300px",style:{border:0,allowFullScreen:!0,loading:"lazy",referrerpolicy:"no-referrer-when-downgrade"}})})]})}export{j as default};