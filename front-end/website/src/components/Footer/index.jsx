import Logo from "../../assets/images/logo/logo2.png";
export default function Footer() {
    return (
        <footer className="w-full p-6 px-4 mx-auto mt-10 max-w-container sm:px-6 lg:px-8">
            <div className="py-10 border-t border-slate-900/5">
                <img src={Logo} alt="logo-ct" className="mx-auto w-52 text-slate-900" />
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
