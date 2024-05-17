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
        <Card className="m-3 shadow-md">
            <CardHeader
                title={item.title}
                titleTypographyProps={{ fontSize: "1.15rem", fontWeight: "semibold" }}
                className="text-lg text-center border-b-2 border-gray-200 text-blue-950"
            />
            <CardContent className="p-5">
                <Lottie style={{ width: 200, height: 150, margin: "auto" }} animationData={item.animationData} />
            </CardContent>
            <CardActions className="flex justify-center ">
                <div className="flex justify-center">
                    <Button className="!bg-indigo-600 !text-white hover:!bg-indigo-500" type="primary" href={item.link}>
                        Truy Cập
                    </Button>
                </div>
            </CardActions>
        </Card>
    );
}
