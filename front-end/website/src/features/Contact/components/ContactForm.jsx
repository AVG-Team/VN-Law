import { useState } from "react";

export function ContactForm (){
    const [name, setName] = useState('');
    const [email, setEmail] = useState('');
    const [message, setMessage] = useState('');

    const handleSubmit = (event) => {
        event.preventDefault();
        alert(`Form submitted:\nName: ${name}\nEmail: ${email}\nMessage: ${message}`);
        resetForm();
    }

    const resetForm = () => {
        setName('');
        setEmail('');
        setMessage('');
    }

    return (
        <form onSubmit={handleSubmit} action="#" className="w-full lg:w-8/12 mx-auto border-solid border-2 p-4 space-y-8 lg:pr-5">
            <div>
                <label htmlFor="name" className="block mb-1 text-sm font-medium dark:text-gray-900">Họ và tên</label>
                <input type="text" value={name} onChange={(e) => setName(e.target.value)} id="name" className="block p-3 w-full text-sm bg-gray-700 rounded-lg border border-gray-600 shadow-sm focus:ring-primary-3000 focus:border-primary-3000 dark:bg-gray-200 dark:border-gray-300 dark:placeholder-gray-400 dark:text-gray-900 dark:focus:ring-primary-3000 dark:focus:border-primary-3000 dark:shadow-sm-light" placeholder="Nhập họ và tên" required/>
            </div>
            <div>
                <label htmlFor="email" className="block mb-1 text-sm font-medium dark:text-gray-900">Email</label>
                <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} id="email" className="shadow-sm bg-gray-700 border border-gray-600 text-sm rounded-lg focus:ring-primary-3000 focus:border-primary-3000 block w-full p-2.5 dark:bg-gray-200 dark:border-gray-300 dark:placeholder-gray-400 dark:text-gray-900 dark:focus:ring-primary-3000 dark:focus:border-primary-3000 dark:shadow-sm-light" placeholder="Nhập địa chỉ email" required/>
            </div>
            <div className="sm:col-span-2">
                <label htmlFor="message" className="block mb-1 text-sm font-medium dark:text-gray-900">Nội dung</label>
                <textarea id="message" value={message} onChange={(e) => setMessage(e.target.value)} rows="6" className="block p-2.5 w-full text-sm bg-gray-700 rounded-lg shadow-sm border border-gray-600 focus:ring-primary-3000 focus:border-primary-3000 dark:bg-gray-200 dark:border-gray-300 dark:placeholder-gray-400 dark:text-gray-900 dark:focus:ring-primary-3000 dark:focus:border-primary-3000" placeholder="Nhập nội dung" required></textarea>
            </div>
            <button type="submit" className="py-3 px-5 text-sm font-medium bg-[#4F46E5] text-center text-white rounded-lg sm:w-fit hover:bg-primary-700 focus:ring-4 focus:outline-none focus:ring-primary-800 dark:bg-primary-700 dark:hover:bg-primary-800 dark:focus:ring-primary-800 lg:float-left lg:mr-2 flex justify-center mx-auto">Gửi tin nhắn</button>
        </form>
    );
}

export default ContactForm;
