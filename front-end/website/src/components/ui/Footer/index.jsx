import Logo from "~/assets/images/logo/logo.png";
export default function Footer() {
    return (
        <footer className="w-full p-6 px-4 mt-auto bg-white">
            <div className="py-10 border-t border-slate-900/5">
                <div className="flex items-center justify-center space-x-4">
                    <img
                        src={Logo}
                        alt="logo-ct"
                        className="w-24 mx-auto rounded-full text-slate-900" // thêm ở đây
                    />
                </div>

                <p className="mt-5 text-sm leading-6 text-center text-slate-500">
                    &copy; AVG TEAM 2023. All rights reserved.
                </p>
                <div className="flex items-center justify-center mt-16 space-x-4 text-sm font-semibold leading-6 text-slate-700">
                    <a href="#s">Privacy policy</a>
                    <div className="w-px h-4 bg-slate-500/20"></div>
                    <a href="#s">Contact us</a>
                </div>
            </div>
        </footer>
    );
}
