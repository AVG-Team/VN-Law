import bct_signed_06 from "~/mock/VBQPPL/06-bct.signed.pdf";
import pt_signed_28 from "~/mock/VBQPPL/28-pt.signed.pdf";
import cp_signed_47 from "~/mock/VBQPPL/47-cp.signed.pdf";
import nd_signed_59 from "~/mock/VBQPPL/59-nd.signed.pdf";
import tb_vpcp_signed_153 from "~/mock/VBQPPL/153-tb-vpcp.signed.pdf";
import tb_vpcp_signed_163 from "~/mock/VBQPPL/163-tb-vpcp.signed.pdf";
import vpcp_signed_188 from "~/mock/VBQPPL/188-vpcp.signed.pdf";
import nn_signed_255 from "~/mock/VBQPPL/255-nn.signed.pdf";
import ttg_signed_288 from "~/mock/VBQPPL/288-ttg.signed.pdf";
import ttg_signed_299 from "~/mock/VBQPPL/299-ttg.signed.pdf";
import kgvx_signed_2450 from "~/mock/VBQPPL/2450-kgvx.signed.pdf";
import qhdp_signed_2470 from "~/mock/VBQPPL/2470-qhdp.signed.pdf";

export default function linkFile(nameFile) {
    switch (nameFile) {
        case "06-bct.signed.pdf":
            return bct_signed_06;
        case "28-pt.signed.pdf":
            return pt_signed_28;
        case "47-cp.signed.pdf":
            return cp_signed_47;
        case "59-nd.signed.pdf":
            return nd_signed_59;
        case "153-tb-vpcp.signed.pdf":
            return tb_vpcp_signed_153;
        case "163-tb-vpcp.signed.pdf":
            return tb_vpcp_signed_163;
        case "188-vpcp.signed.pdf":
            return vpcp_signed_188;
        case "255-nn.signed.pdf":
            return nn_signed_255;
        case "288-ttg.signed.pdf":
            return ttg_signed_288;
        case "299-ttg.signed.pdf":
            return ttg_signed_299;
        case "2450-kgvx.signed.pdf":
            return kgvx_signed_2450;
        case "2470-qhdp.signed.pdf":
            return qhdp_signed_2470;
        default:
            return "";
    }
}
