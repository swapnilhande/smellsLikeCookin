<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Order Summary</title>
    <link rel="stylesheet" href="../css/documentation.css" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-div">
            <h1 class="center-align">Order Summary</h1>
            <hr />
            <br />
            <h4>File Name:</h4>
            <p>OrderSummary.aspx</p>

            <h4>Purpose:</h4>
            <p>
                This page of <b><i>Smells Like Cookin'</i></b> shows summary of orders requested by and for the logged in user.
           The page is basically divided into two sections.
            <ol>
                <li><b>Samples I Have Requested:</b>
                    <p>
                        This section of the page shows all the samples that the logged in user has requested to other members.
                        The Order part shows which recipe has been requested to which user. The status is the current status of the 
                        the request which is one of the following - Pending, Completed, Declined. All orders unless processed are
                        in pending status. The user that requests the order can withdraw the request by hovering over the status that 
                        then displays the Withdraw button.
                    </p>
                    <p>
                        Clicking the withdraw button will remove the request from current users workflow as well as the requested users
                        workflow.
                    </p>
                </li>
                <li>
                    <b>Samples Requested To Me: </b>
                    <p>
                        This section of the page shows all the samples that other members have requested to the current logged in user.
                        When hovering over "Pending" status two buttons appear - "Complete" and "Decline". Clicking Complete shall mark 
                        that request as completed, while decline will decline the request. These buttons process the request, upon which the
                        request gets freezed and is no more available to complete or decline. 
                    </p>
                    <p>
                        The status of these requests are also reflected the requester user's workflow.
                    </p>
                </li>
            </ol>
            </p>
            <h4>Screen shots</h4>
            <p>Withdraw button in the samples requested by me section</p>
            <img src="../images/ordersummary_1.jpg" title="Homepage" alt="Homepage Screenshot" class="image" />

            <p>Complete and Decline buttons in samples requested to me section</p>
            <img src="../images/ordersummary_2.jpg" title="Homepage" alt="Homepage Screenshot" class="image" />
            
            
            <h4>Key Functionalities</h4>
            <ul>
                <li>Ability to see all order requests and details by me and to me.</li>
                <li>Ability to withdraw requests made by me.</li>
                <li>Ability to complete and decline the requests for the logged in user.</li>
            </ul>

            <h4>Future Scope:</h4>
            <p>
                Can include an send email functionality to notify the user about the current status if any changes occur.
            </p>
        </div>
    </form>
</body>
</html>
