import { ContactForm } from "./components/ContactForm";
import { SocialMedidaLinks } from "./components/SocialMediaLinks";

export default function Contact(props) {
    return (
        <section>
            <div className="max-w-screen-lg mx-auto mt-10 bg-white border border-gray-300 rounded-lg lg:p-12">
                <h2 className="mb-4 text-4xl font-extrabold tracking-tight text-center dark:text-gray-900">Liên hệ</h2>
                <p className="mb-8 font-light text-center text-gray-400 lg:mb-5 dark:text-gray-3000 sm:text-xl">
                    Chúng tôi mong muốn lắng nghe ý kiến của bạn. Vui lòng gửi mọi yêu cầu thắc mắc theo thông tin bên
                    dưới, chúng tôi sẽ liên lạc với bạn sớm nhất có thể.{" "}
                </p>
                <div className="flex flex-col lg:flex-row">
                    <ContactForm />
                    <SocialMedidaLinks />
                </div>
            </div>
            <div className="w-full mx-auto mt-10 max-w-containe">
                <iframe
                    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3918.427642206537!2d106.78279807580208!3d10.855042689298537!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x317527c3debb5aad%3A0x5fb58956eb4194d0!2zxJDhuqFpIEjhu41jIEh1dGVjaCBLaHUgRQ!5e0!3m2!1sen!2s!4v1713204707972!5m2!1sen!2s"
                    title="Google Maps"
                    width="100%"
                    height="400px"
                    style={{
                        border: 0,
                        allowFullScreen: true,
                        loading: "lazy",
                        referrerpolicy: "no-referrer-when-downgrade",
                    }}
                />
            </div>
        </section>
    );
}
