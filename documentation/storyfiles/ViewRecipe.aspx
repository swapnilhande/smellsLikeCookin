<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>View Recipes</title>
    <link rel="stylesheet" href="../css/documentation.css" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-div">
            <h1 class="center-align">View Recipes</h1>
            <hr />
            <br />
            <h4>File Name:</h4>
            <p>ViewRecipes.aspx</p>

            <h4>Purpose:</h4>
            <p>
                This page of <b><i>Smells Like Cookin'</i></b> shows the recipe and its details. This page works on query parameters
                where in the query parameter is the recipe id of the recipe that is to be viewed. If the logged in user is the owner of the
                requested recipe, then he can edit or delete the recipe, else those buttons are disabled.
            </p>
            <p>
            The page is divided into multiple sections.
            <ol>
                <li><b>Recipe Name:</b>
                    <p>
                        This is the name of the recipe that was saved. In case the query parameters are invalid, it displays invalid 
                        recipe.
                    </p>
                </li>
                <li>
                    <b>Ingredients: </b>
                    <p>
                        This is an ordered list that displays the ingredients for the recipe. It reads the corresponding ingredients xml
                        from the server and displays the values. The ingredients have been given a max-height after which a scroll bar appears
                        so that the page doesnt become very long to read. This area is read-only.
                    </p>
                </li>
                <li>
                    <b>Image:</b>
                    <p>The image of the recipe is displayed here. In case the image is not uploaded by the user a default image is
                        displayed which shows "No Image Uploaded". The image url is fetched from the database and can be the physical
                        location if uploaded by the user or just the url of the source as specified by the user.
                    </p>
                </li>
                <li>
                    <b>
                        Request Order:
                    </b>
                    <p>The request order is used to place an order to the owner user. The text box has a validator that enforces
                        only integer values to be submitted. Clicking the request order button adds an order workflow to the owner
                        user. This button is also in a logged in template and so is visible only to logged in user.
                    </p>
                </li>
                <li>
                    <b>Edit and Delete Buttons</b>
                    <p>
                        These buttons are only visible if the current logged in user owns the recipe. These buttons enable the user
                        to edit the recipe or delete it. Deleting it removes the recipe and its related entries in database such as orders, hash tags,
                        comments etc. Editing the recipe redirects it to AddRecipe page where the user can edit the recipe and save it again.
                    </p>
                </li>
                <li>
                    <b>Procedures:</b>
                    <p>This is an ordered list that displays the procedures to make the recipe. It reads the corresponding procedures xml
                        from the server and displays the values. The procedures have been given a max-height after which a scroll bar appears
                        so that the page doesnt become very long to read. This area is read-only.</p>
                </li>
                <li>
                    <b>Hash tags:</b>
                    <p>This area displays the hash tags that were added by the creator which describes the recipe or relates to it.
                        This hash tag can be used while browsing recipes.
                    </p>
                </li>
                <li>
                    <b>Comments:</b>
                    <p>This area displays the comments that are made to this recipe. The user comments are shown in quotes, along with
                        the username of the user that commented with the date when it was commented.
                    </p>
                    <p>There is a logged in template which allows only logged in users to comment about the recipe. The comments are
                        encoded to prevent unwanted behavior. The comments are stored in database against the recipe.
                    </p>
                </li>
            </ol>
            </p>
            <h4>Screen shots</h4>
            <p>No edit delete buttons visible to anonymous/not owner user:</p>
            <img src="../images/viewrecipe_1.jpg" title="Homepage" alt="Homepage Screenshot" class="image" />

            <p>No text box to comment for anonymous user:</p>
            <img src="../images/viewrecipe_2.jpg" title="Homepage" alt="Homepage Screenshot" class="image" />

            <p>Edit and delete buttons for the owner:</p>
            <img src="../images/viewrecipe_3.jpg" title="Homepage" alt="Homepage Screenshot" class="image" />

            <p>Request button validator for invalid entry and comment text box for logged in user:</p>
            <img src="../images/viewrecipe_4.jpg" title="Homepage" alt="Homepage Screenshot" class="image" />

            <h4>Key Functionalities</h4>
            <ul>
                <li>Ability to see recipe name, ingredients, procedures and image.</li>
                <li>Ability to place an order of quantity to the owner user.</li>
                <li>Ability to the owner user to edit or delete the recipe.</li>
                <li>Ability to see comments made to the recipe.</li>
                <li>Ability to a logged in user to post comments.</li>
            </ul>

            <h4>Future Scope:</h4>
            <p>
                Ability to delete a posted comment is a feature that can enhance the user experience. Having a pagination in comments
                section will optimize the page's performance.
            </p>

            <h4>References</h4>
            <ul>
                <li><a href="../../../experiments/asp.net/exp5Xml.aspx" target="_blank">Experiment 5 - XML</a>  </li>
                <li><a href="../../../experiments/jquery/exp6Sortable.aspx" target="_blank">Experiment 6 - Sortable</a> </li>
                <li><a href="../../../experiments/asp.net/exp7FileUpload.aspx" target="_blank">Experiment 7 - File Upload</a> </li>
                <li><a href="../../../experiments/jquery/exp8TaskList.aspx" target="_blank">Experiment 8 - Task List</a>  </li>
                <li><a href="../../../experiments/asp.net/exp12Hash.aspx" target="_blank">Experiment 12 - Hashes</a>  </li>
                <li><a href="http://net4.ccs.neu.edu/home/rasala/experiments/fakecomments/simulation.aspx" target="_blank">Prof.Rasala Fake Comments Experiment</a></li>
            </ul>
        </div>
    </form>
</body>
</html>
