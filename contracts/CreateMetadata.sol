// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./Base64.sol";
import "@openzeppelin-contracts/utils/Strings.sol";
import "./BokkyPooBahsDateTimeLibrary.sol";
import "@openzeppelin-contracts/token/ERC20/extensions/IERC20Metadata.sol";

/**
 * @title Creates metadata for on-chain SVG PDC NFT
 * @notice Implements SVG Metadata
 * @author Venkatesh, PDC Finance
 **/

contract CreateMetadata {
    /**
     * @notice Converts wei to ether string with 2 decimal places
     * @param amountInWei Amount in wei
     * @return Amount in string
     */
    function weiToEtherString(uint256 amountInWei)
        public
        pure
        returns (string memory)
    {
        uint256 amountInFinney = amountInWei / 1e15; // 1 finney == 1e15
        return
            string(
                abi.encodePacked(
                    Strings.toString(amountInFinney / 1000), //left of decimal
                    ".",
                    Strings.toString((amountInFinney % 1000) / 100), //first decimal
                    Strings.toString(((amountInFinney % 1000) % 100) / 10) // first decimal
                )
            );
    }

    /**
     * @notice Converts unix timestamp to date & time string
     * @param _timestamp Unix timestamp
     * @return Date and time in string
     */
    function dateTimetoString(uint256 _timestamp)
        public
        pure
        returns (string memory)
    {
        (
            uint256 year,
            uint256 month,
            uint256 day,
            uint256 hour,
            uint256 minute,
            uint256 second
        ) = BokkyPooBahsDateTimeLibrary.timestampToDateTime(_timestamp);
        return
            string(
                abi.encodePacked(
                    Strings.toString(year),
                    "-",
                    Strings.toString(month),
                    "-",
                    Strings.toString(day),
                    " ",
                    Strings.toString(hour),
                    "Hr ",
                    Strings.toString(minute),
                    "Mins UTC"
                )
            );
    }

    /**
     * @notice Get token symbol of an ERC-20 token
     * @param _token ERC-20 token address
     * @return _symbol ERC-20 token symbol
     */
    function getTokenSymbol(address _token)
        public
        view
        returns (string memory _symbol)
    {
        IERC20Metadata tokencontract = IERC20Metadata(_token);
        _symbol = tokencontract.symbol();
        return _symbol;
    }

    /**
     * @notice Builds SVG Image
     * @param _token ERC 20 token name of PDC
     * @param _receiver Address of PDC receiver
     * @param _amount Amount of the PDC
     * @param _date Maturity date of the PDC
     * @param tokenId Token ID of PDC NFT
     * @return base64 encoded SVG image
     */
    function buildImage(
        address _token,
        address _receiver,
        uint256 _amount,
        uint256 _date,
        uint256 tokenId
    ) public view returns (string memory) {
        string memory _receiverString = Strings.toHexString(_receiver);
        string memory _amountString = weiToEtherString(_amount);
        string memory _dateString = dateTimetoString(_date);
        string memory _issueDate = dateTimetoString(block.timestamp);
        string memory _issuerAddress = Strings.toHexString(msg.sender);
        string memory _tokenIdString = Strings.toString(tokenId);
        string memory _tokenSymbolString = getTokenSymbol(_token);
        return
            Base64.encode(
                bytes(
                    abi.encodePacked(
                        '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1134.7197884942116 561.3660961926566" width="1134.7197884942116" height="561.3660961926566">',
                        '<rect x="0" y="0" width="1134.7197884942116" height="561.3660961926566" fill="#ffffff"></rect>',
                        '<g stroke-linecap="round" transform="translate(12.137744661466968 14.488101709584953) rotate(360.46405271159534 555.2221495856388 266.19494638674337)">',
                        '<path d="M-0.73 0.69 C379.8 -4.19, 758.96 -4.99, 1109.89 0.57 M0.04 0.28 C305.02 -0.57, 610.71 -0.96, 1110.43 0.17 M1111.08 -0.57 C1107.95 134.21, 1108.06 268.48, 1110.6 532.33 M1110.53 0.25 C1110.18 134.97, 1110.93 269.53, 1110.08 532.68 M1109.95 531.68 C679.89 528.54, 250.14 527.61, -0.29 532.81 M1110.34 532.68 C766.47 529.78, 422.2 529.65, 0.31 532.03 M-0.09 532.05 C1.21 410.94, 1.07 291.52, -0.31 0.37 M0.21 532.47 C2.17 361.24, 1.91 190.5, -0.07 0.05" stroke="#000000" stroke-width="2" fill="none"></path>',
                        "</g>",
                        '<g transform="translate(61.238558391017705 37.16423060471652) rotate(0 124 21)">',
                        '<text x="0" y="34" font-family="Helvetica, Segoe UI Emoji" font-size="36px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">PDC Finance</text>',
                        "</g>",
                        '<g transform="translate(55.92846434748117 84.50758062408204) rotate(0 125.5 11.5)">',
                        '<text x="0" y="18" font-family="Helvetica, Segoe UI Emoji" font-size="20px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">Post-Dated Crypto Payment</text>',
                        "</g>",
                        '<g transform="translate(557.0721586379582 48.80188614010672) rotate(0 105.5 16.5)">',
                        '<text x="0" y="26" font-family="Helvetica, Segoe UI Emoji" font-size="28px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">Payment Date    </text>',
                        "</g>",
                        '<g transform="translate(70.53133691011544 171.93480876083777) rotate(0 44.5 16.5)">',
                        '<text x="0" y="26" font-family="Helvetica, Segoe UI Emoji" font-size="28px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">Pay to </text>',
                        "</g>",
                        '<g transform="translate(176.73382547635856 173.26229429075215) rotate(0 345.5 17)">',
                        '<text x="0" y="27" font-family="Cascadia, Segoe UI Emoji" font-size="28px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">',
                        _receiverString,
                        "</text>",
                        "</g>",
                        '<g transform="translate(66.21680004256041 241.46201895378204) rotate(0 49.5 16.5)">',
                        '<text x="0" y="26" font-family="Helvetica, Segoe UI Emoji" font-size="28px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">Amount</text>',
                        "</g>",
                        '<g transform="translate(193.9916690988216 241.96201895378204) rotate(0 28 16.5)">',
                        '<text x="0" y="26" font-family="Helvetica, Segoe UI Emoji" font-size="28px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">',
                        _tokenSymbolString,
                        "</text>",
                        "</g>",
                        '<g stroke-linecap="round" transform="translate(620.129134214355 264.5866751855201) rotate(0 175.89792232913305 43.14474831971302)">',
                        '<path d="M-0.15 1.16 C111.63 -0.73, 224.82 -0.45, 352.04 0.33 M0.5 -0.57 C124.76 1.81, 248.39 1.87, 351.93 0.64 M352.3 -0.15 C350.26 18.27, 352.29 35.72, 353.73 86.17 M351.1 -0.87 C352.8 23.31, 351.31 48.1, 351.49 86.48 M352.21 87.1 C279.61 83.04, 205.55 84.27, -1.16 87.48 M351.38 86.62 C230.84 87.92, 110.63 88.46, 0.18 86.46 M0.16 86.44 C-0.61 55.98, -0.09 30.07, -1.19 -1.51 M0.68 85.31 C-0.5 61.86, -1.34 34.8, -0.19 0.05" stroke="#000000" stroke-width="2" fill="none"></path>',
                        "</g>",
                        '<g stroke-linecap="round">',
                        '<g transform="translate(698.453489788476 267.2416968866419) rotate(0 -0.24611870013177395 43.959137865991465)">',
                        '<path d="M-0.99 -1.46 C-0.4 28.62, -1.13 52.78, -0.12 89.38 M0.26 0.94 C0.03 27.9, 0.41 57.35, 0.5 88.29" stroke="#000000" stroke-width="2" fill="none"></path>',
                        "</g>",
                        "</g>",
                        '<g transform="translate(626.7667897497449 291.4125830772148) rotate(0 25.5 17)">',
                        '<text x="0" y="27" font-family="Cascadia, Segoe UI Emoji" font-size="28px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">',
                        _tokenSymbolString,
                        "</text>",
                        "</g>",
                        '<g transform="translate(718.3664563946468 291.7444354692086) rotate(0 66.5 17)">',
                        '<text x="0" y="27" font-family="Cascadia, Segoe UI Emoji" font-size="28px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">',
                        _amountString,
                        "</text>",
                        "</g>",
                        '<g transform="translate(66.21680004256041 307.838574307684) rotate(0 52.5 16.5)">',
                        '<text x="0" y="26" font-family="Helvetica, Segoe UI Emoji" font-size="28px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">Network</text>',
                        "</g>",
                        '<g transform="translate(200.62932463421203 309.9979881915315) rotate(0 116 17)">',
                        '<text x="0" y="27" font-family="Cascadia, Segoe UI Emoji" font-size="28px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">Poylgon Mumbai</text>',
                        "</g>",
                        '<g transform="translate(59.579144507169985 367.2456217342019) rotate(0 75.5 16.5)">',
                        '<text x="0" y="26" font-family="Helvetica, Segoe UI Emoji" font-size="28px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">Issued Date</text>',
                        "</g>",
                        '<g transform="translate(235.47701619501004 366.41806024234825) rotate(0 107.5 17)">',
                        '<text x="0" y="27" font-family="Cascadia, Segoe UI Emoji" font-size="28px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">',
                        _issueDate,
                        "</text>",
                        "</g>",
                        '<g transform="translate(678.5405231823056 384.19337131312864) rotate(0 53.5 12)">',
                        '<text x="0" y="19" font-family="Cascadia, Segoe UI Emoji" font-size="20px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">Signed By</text>',
                        "</g>",
                        '<g transform="translate(399.7590919785039 424.3250570275727) rotate(0 345.5 17)">',
                        '<text x="0" y="27" font-family="Cascadia, Segoe UI Emoji" font-size="28px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">',
                        _issuerAddress,
                        "</text>",
                        "</g>",
                        '<g transform="translate(106.04273325490158 508.6494126016946) rotate(0 48 12)">',
                        '<text x="0" y="19" font-family="Cascadia, Segoe UI Emoji" font-size="20px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">Token ID</text>',
                        "</g>",
                        '<g transform="translate(211.91342007044386 508.81316802697506) rotate(0 36 12)">',
                        '<text x="0" y="19" font-family="Cascadia, Segoe UI Emoji" font-size="20px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">',
                        _tokenIdString,
                        "</text>",
                        "</g>",
                        '<g transform="translate(759.1274746669578 48.03284152582796) rotate(0 34 17)">',
                        '<text x="0" y="27" font-family="Cascadia, Segoe UI Emoji" font-size="28px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">',
                        _dateString,
                        "</text>",
                        "</g>",
                        '<g transform="translate(293.6456976110162 241.52479114649054) rotate(0 140.5 17)">',
                        '<text x="0" y="27" font-family="Cascadia, Segoe UI Emoji" font-size="28px" fill="#000000" text-anchor="start" style="white-space: pre;" direction="ltr">',
                        _amountString,
                        "</text>",
                        "</g>",
                        "</svg>"
                    )
                )
            );
    }

    /**
     * @notice Builds Metadata for PDC NFT
     * @param _token ERC 20 token name of PDC
     * @param _receiver Address of PDC receiver
     * @param _amount Amount of the PDC
     * @param _date Maturity date of the PDC
     * @param tokenId Token ID of PDC NFT
     * @return base64 encoded json metadata
     */
    function buildMetadata(
        address _token,
        address _receiver,
        uint256 _amount,
        uint256 _date,
        uint256 tokenId
    ) public view returns (string memory) {
        string memory _amountString = Strings.toString(_amount);
        string memory _dateString = Strings.toString(_date);
        string memory _issuerAddress = Strings.toHexString(msg.sender);
        string memory _tokenSymbolString = getTokenSymbol(_token);
        string memory _issueDate = Strings.toString(block.timestamp);
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "PDCtest",
                                '", "description":"',
                                "PDCtest",
                                '", "image": "',
                                "data:image/svg+xml;base64,",
                                buildImage(
                                    _token,
                                    _receiver,
                                    _amount,
                                    _date,
                                    tokenId
                                ),
                                '", "attributes": ',
                                "[",
                                '{"display_type": "date", ',
                                '"trait_type": "IssuedDate",',
                                '"value":"',
                                _issueDate,
                                '"},',
                                '{"display_type": "date", ',
                                '"trait_type": "PaymenDate",',
                                '"value":"',
                                _dateString,
                                '"},',
                                '{"trait_type": "Payer",',
                                '"value":"',
                                _issuerAddress,
                                '"},',
                                '{"trait_type": "Token",',
                                '"value":"',
                                _tokenSymbolString,
                                '"},',
                                '{"trait_type": "Amount",',
                                '"value":"',
                                _amountString,
                                '"}',
                                "]",
                                "}"
                            )
                        )
                    )
                )
            );
    }
}
