import ContactForm from "./components/ContactForm";
import SocialMedidaLinks from "./components/SocialMediaLinks";

export default function Contact(props) {
    return (
        <section>
            <div className="py-4 lg:py-12 pe-2 ps-2 mx-auto max-w-screen-lg">
                <h2 className="mb-4 text-4xl tracking-tight font-extrabold text-center dark:text-gray-900">Liên hệ</h2>
                <p className="mb-8 lg:mb-5 font-light text-center text-gray-400 dark:text-gray-3000 sm:text-xl">Chúng tôi mong muốn lắng nghe ý kiến của quý khách. Vui lòng gửi mọi yêu cầu thắc mắc theo thông tin bên dưới, chúng tôi sẽ liên lạc với bạn sớm nhất có thể. </p>
                <div className="flex flex-col">
                    <ContactForm />
                    <SocialMedidaLinks />
                </div>
            </div>
        </section>
    );
}
