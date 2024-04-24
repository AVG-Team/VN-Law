import { useState } from "react";

export function ContactForm() {
    const [name, setName] = useState("");
    const [email, setEmail] = useState("");
    const [message, setMessage] = useState("");

    const handleSubmit = (event) => {
        event.preventDefault();
        alert(`Form submitted:\nName: ${name}\nEmail: ${email}\nMessage: ${message}`);
        resetForm();
    };

    const resetForm = () => {
        setName("");
        setEmail("");
        setMessage("");
    };

    return (
        <form
            onSubmit={handleSubmit}
            action="#"
            className="w-full lg:w-8/12 border-solid border-2 rounded p-4 space-y-8 lg:pr-5 order-2 lg:order-1"
        >
            <div>
                <label htmlFor="name" className="block mb-1 text-sm font-medium">
                    Họ và tên
                </label>
                <input
                    type="text"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    id="name"
                    className="block p-3 w-full text-sm  rounded-lg border shadow-sm focus:ring-primary-3000 "
                    placeholder="Nhập họ và tên"
                    required
                />
            </div>
            <div>
                <label htmlFor="email" className="block mb-1 text-sm font-medium">
                    Email
                </label>
                <input
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    id="email"
                    className="shadow-sm  border  text-sm rounded-lg focus:ring-primary-3000  block w-full p-2.5"
                    placeholder="Nhập địa chỉ email"
                    required
                />
            </div>
            <div className="sm:col-span-2">
                <label htmlFor="message" className="block mb-1 text-sm font-medium">
                    Nội dung
                </label>
                <textarea
                    id="message"
                    value={message}
                    onChange={(e) => setMessage(e.target.value)}
                    rows="6"
                    className="block p-2.5 w-full text-sm  rounded-lg shadow-sm border  focus:ring-primary-3000 "
                    placeholder="Nhập nội dung"
                    required
                ></textarea>
            </div>
            <button
                type="submit"
                className="py-3 px-5 text-sm font-medium bg-[#4F46E5] text-center text-white rounded-lg sm:w-fit hover:bg-primary-700 focus:ring-4 focus:outline-none focus:ring-primary-800 dark:bg-primary-700 dark:hover:bg-primary-800 dark:focus:ring-primary-800 lg:float-left lg:mr-2 flex justify-center mx-auto"
            >
                Gửi tin nhắn
            </button>
        </form>
    );
}
