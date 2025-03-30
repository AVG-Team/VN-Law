// Code to export all routes from the publicRoutes and privateRoutes files
import publicRoutes from "./publicRoutes";
import privateRoutes from "./privateRoutes";

const routes = [...publicRoutes, ...privateRoutes];

export default routes;
