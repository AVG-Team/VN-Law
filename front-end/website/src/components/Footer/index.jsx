import { Typography } from "@material-tailwind/react";
import Logo from "../../assets/images/logo/logo2.png";
export default function Footer() {
    return (
        <footer className="w-full p-6 bg-gray-200">
            <div className="flex flex-row flex-wrap items-center justify-center text-center bg-gray-200 gap-y-6 gap-x-12 md:justify-between">
                <img src={Logo} alt="logo-ct" className="w-48 " />
                <ul className="flex flex-wrap items-center gap-y-2 gap-x-8">
                    <li>
                        <Typography
                            as="a"
                            href="#"
                            color="blue-gray"
                            className="font-normal transition-colors hover:text-blue-500 focus:text-blue-500"
                        >
                            About Us
                        </Typography>
                    </li>
                    <li>
                        <Typography
                            as="a"
                            href="#"
                            color="blue-gray"
                            className="font-normal transition-colors hover:text-blue-500 focus:text-blue-500"
                        >
                            License
                        </Typography>
                    </li>
                    <li>
                        <Typography
                            as="a"
                            href="#"
                            color="blue-gray"
                            className="font-normal transition-colors hover:text-blue-500 focus:text-blue-500"
                        >
                            Contribute
                        </Typography>
                    </li>
                    <li>
                        <Typography
                            as="a"
                            href="#"
                            color="blue-gray"
                            className="font-normal transition-colors hover:text-blue-500 focus:text-blue-500"
                        >
                            Contact Us
                        </Typography>
                    </li>
                </ul>
            </div>
            <hr className="my-8 border-blue-gray-50" />
            <Typography color="blue-gray" className="font-normal text-center">
                &copy; AVG TEAM 2023. All rights reserved.
            </Typography>
        </footer>
    );
}
