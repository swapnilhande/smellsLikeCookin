<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Add Recipes</title>
    <link rel="stylesheet" href="../css/documentation.css" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-div">
            <h1 class="center-align">Add Recipes</h1>
            <hr />
            <br />
            <h4>File Name:</h4>
            <p>AddRecipes.aspx</p>

            <h4>Purpose:</h4>
            <p>
                This page of <b><i>Smells Like Cookin'</i></b> adds the recipe and its details. This page also doubles up as
                an edit recipe page when the recipe id is given as the query parameters. Before the recipe is available to edit
                the recipe id is checked against the logged in user and displays error if you are not the owner of the recipe.
            </p>
            <p>
                The page is divided into multiple sections.
            <ol>
                <li><b>Recipe Name:</b>
                    <p>
                        This is an input box for adding recipe name. Upon saving recipe value should be present in the name else
                        recipe doesn't save. Values entered in this field are HTML encoded.
                    </p>
                </li>
                <li>
                    <b>Ingredients: </b>
                    <p>
                        This is another good feature that was suggested by Professor Rasala to be included in my project, a neat trick
                         that Professor Jose explained in class - sortable lists. User
                        can enter the ingredients and it forms a list below. There appears a "x" button which removes the ingredients 
                        from the list. The best part is that this list is sortable. User can drag the ingredients to re arrange their order
                        . Any change to the order makes a save arrangement button to appear which would save the new arrangement.
                    </p>
                    <p>
                        Since the order is on client side, when clicking save the new order of the list is posted to the server
                        through ajax post and it is saved on the server. All entries are HTML encoded.
                    </p>
                </li>
                <li>
                    <b>Procedure:</b>
                    <p>
                        The functionality and working of this list is similar to ingredients but it is used to store the procedure
                        to make the recipe. All entries are HTML encoded.
                    </p>
                </li>
                <li>
                    <b>Image:
                    </b>
                    <p>
                        Since Professor Rasala suggested to use external image links rather than storing it on the database,
                        I have given two options to the user:
                        <ol>
                            <li>Provide the location of the image that is served by some user. This url if valid, will be stored in
                                the database and image will be served from that server. The textbox has a textchanged event which
                                makes a HTTP request to the entry and sees if its a valid url, else displays error.
                            </li>
                            <li>Alternatively, upload an image to the server. This file upload control only allows popular
                                extensions of .jpeg, .jpg, .png and .gif. 
                            </li>
                        </ol>
                        In case user has entered in both places, error message is displayed.
                    </p>
                </li>
                <li>
                    <b>Hash tags</b>
                    <p>
                        These buttons enable user to make the recipe better searchable which was seen in the browserecipe and 
                        myrecipe pages. These hash tags show what the recipe is all about. The selected hash tags are stored in
                        the database.
                    </p>
                </li>
                <li>
                    <b>Save Button:</b>
                    <p>
                        This button saves the recipe to the database against the logged in user. Recipe name, atleast one ingredient,
                         atleast one procedure must be present to save a recipe else error message is displayed.
                        Hash tags selections are optional. Image is optional, but if a file is selected to be uploaded and image
                        url is also given, error message is displayed.
                    </p>
                </li>
                <li>
                    <b>Clear buttons</b>
                    <p>
                        The clear buttons are used to clear the corresponding views in which they are located. The clear all button 
                        clears everything.
                    </p>
                </li>
                <li>
                    <b>Comments:</b>
                    <p>
                        This area displays the comments that are made to this recipe. The user comments are shown in quotes, along with
                        the username of the user that commented with the date when it was commented.
                    </p>
                    <p>
                        There is a logged in template which allows only logged in users to comment about the recipe. The comments are
                        encoded to prevent unwanted behavior. The comments are stored in database against the recipe.
                    </p>
                </li>
            </ol>
            </p>
            <h4>Screen shots</h4>
            <p>Dragging ingredients to sort them:</p>
            <img src="../images/addrecipe_1.jpg" title="Add Recipe" alt="Add Recipe" class="image" />

            <p>Save ingredients order button appears when order changes:</p>
            <img src="../images/addrecipe_2.jpg" title="Add Recipe" alt="Add Recipe" class="image" />

            <p>Adding image url shows the preview of image:</p>
            <img src="../images/addrecipe_3.jpg" title="Add Recipe" alt="Add Recipe" class="image" />

            <h4>Key Functionalities</h4>
            <ul>
                <li>Ability to add recipe name, ingredients, procedures and image.</li>
                <li>Ability to sort ingredients and procedures, and delete them as per convenience.</li>
                <li>Ability to include image by an image url.</li>
                <li>Ability to select hash tags for the recipe.</li>
            </ul>

            <h4>Future Scope:</h4>
            <p>
                Ability to preview the image that is uploaded before the recipe is saved by the user.
            </p>

            <h4>References</h4>
            <ul>
                <li><a href="../../../experiments/asp.net/exp5Xml.aspx" target="_blank">Experiment 5 - XML</a>  </li>
                <li><a href="../../../experiments/jquery/exp6Sortable.aspx" target="_blank">Experiment 6 - Sortable</a> </li>
                <li><a href="../../../experiments/asp.net/exp7FileUpload.aspx" target="_blank">Experiment 7 - File Upload</a> </li>
                <li><a href="../../../experiments/jquery/exp8TaskList.aspx" target="_blank">Experiment 8 - Task List</a>  </li>
                <li><a href="../../../experiments/asp.net/exp12Hash.aspx" target="_blank">Experiment 12 - Hashes</a>  </li>
            </ul>
        </div>
    </form>
</body>
</html>
