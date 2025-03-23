export default function Navbar() {
    return (
        <div className="fixed flex items-center justify-between max-w-screen-lg px-10 py-4 transform -translate-x-1/2 bg-white rounded-full shadow-lg top-4 left-1/2">
            <div className="grid items-center grid-cols-3">
                <div className="text-2xl font-bold">LegalWise</div>

                <div></div>

                <div className="flex justify-end text-gray-600 gap-x-12">
                    <a href="/" className="hover:text-black whitespace-nowrap">
                        Legal Forms
                    </a>
                    <a href="/" className="hover:text-black whitespace-nowrap">
                        Services
                    </a>
                    <a href="/" className="hover:text-black whitespace-nowrap">
                        State Laws
                    </a>
                    <a href="/" className="hover:text-black whitespace-nowrap">
                        Learn
                    </a>
                    <a href="/" className="hover:text-black whitespace-nowrap">
                        Blogs
                    </a>
                </div>
            </div>
        </div>
    );
}
