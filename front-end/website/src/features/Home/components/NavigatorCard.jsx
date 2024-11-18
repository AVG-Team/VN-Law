import PropTypes from "prop-types";
import Lottie from "lottie-react";
import { Button, Card, CardActions, CardContent, CardHeader } from "@mui/material";

export default function NavigatorCard({ item }) {
    NavigatorCard.propTypes = {
        item: PropTypes.shape({
            title: PropTypes.string.isRequired,
            animationData: PropTypes.object.isRequired,
            link: PropTypes.string.isRequired,
        }).isRequired,
    };
    return (
        <Card className="m-3 p-8 border-none shadow-md !rounded-xl">
            <CardHeader
                title={item.title}
                titleTypographyProps={{ fontSize: "1.2rem", fontWeight: "semibold" }}
                className="text-lg text-center border-b-2 border-gray-200 text-blue-950 whitespace-nowrap"
            />
            <CardContent className="flex items-center justify-center p-5">
                <Lottie style={{ width: 200, height: 150, margin: "auto" }} animationData={item.animationData} />
            </CardContent>
            <CardActions className="flex justify-center ">
                <div className="flex justify-center">
                    <Button
                        className="!bg-[#41C9E2] !text-white hover:!bg-indigo-500 !px-5 !py-2 !text-base !rounded-xl"
                        type="primary"
                        href={item.link}
                    >
                        Truy Cập
                    </Button>
                </div>
            </CardActions>
        </Card>
    );
}
