<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Database Schema</title>
    <link rel="stylesheet" href="../css/documentation.css" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-div">
            <h1 class="center-align">Database Design</h1>
            <hr />
            <br />
            

            <h4>Purpose:</h4>
            <p>
                I have designed 6 tables to handle the content in my project. They are discussed below.
            </p>
            <p>
            <ol>
                <li><b>COMMENTS:</b>
                    <p>
                        This table is used to store the user comments. It has its ID, USERNAME of the user that posted the comment,
                        COMMENT as the text, DATE as the date posted, and RECIPE_ID as the id of the recipe. It is linked to recipe
                        table for its ID.
                    </p>
                </li>
                <li>
                    <b>HASHTAGS: </b>
                    <p>
                        This table is used to store the hashtags of the system. It has its ID and VALUE which stores the text of the 
                        hash tag.
                    </p>
                </li>
                <li>
                    <b>ORDER_STATUS: </b>
                    <p>
                        This table contains the 3 order status used - Pending, Completed, Declined
                    </p>
                </li>
                <li>
                    <b>ORDERS:
                    </b>
                    <p>
                        This table contains the order details. It has ID, RECIPE_ID, USERNAME of the requester, ORSER_STATUS_ID that is default 
                        as 1-Pending, DATE as the date requested and QUANTIY as quantity requested.
                    </p>
                </li>
                <li>
                    <b>RECIPE</b>
                    <p>
                        This is the main table that stores the recipe. It has ID, NAME, USERNAME, DATE, and IMAGE which stores the image location.
                    </p>
                </li>
                <li>
                    <b>RECIPE_HASHTAGS</b>
                    <p>
                        This table stores the recipe_id and hashtags_id mappings for every recipe.
                    </p>
                </li>
                
            </ol>
            </p>
            <h4>Screen shots</h4>
            <p>Table and Relationships</p>
            <img src="../images/database.jpg" title="Database" alt="Database" class="image" />

            
        </div>
    </form>
</body>
</html>
