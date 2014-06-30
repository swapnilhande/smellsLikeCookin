<%@ Page Language="C#" MasterPageFile="~/project/MasterPage.master" EnableEventValidation="false" ValidateRequest="false"%>

<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Services" %>
<%@ Import Namespace="edu.neu.ccis.rasala" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Xml.Linq" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
    <title>View Recipes</title>
    <link rel="stylesheet" href="css/ViewRecipe.css" type="text/css" />
    <link rel="stylesheet" href="css/BrowseRecipes.css" type="text/css" />
    <script runat="server">
    
        protected static string filename;
        protected static string ingredientsFileName;
        protected static string proceduresFileName;
        protected static string imageFileName;
        protected static string loggedInUser;
        protected static string connectionString = ConfigurationManager.ConnectionStrings["swapnilhCS"].ConnectionString;
        protected static ArrayList allIngredientsList;
        protected static ArrayList allProceduresList;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                ArrayList allIngredientsList = new ArrayList();
                ArrayList allProceduresList = new ArrayList();
                RecipeImage.ImageUrl = "http://placehold.it/450&text=No+Image+To+Display";
                RecipeName.Text = "Invalid Recipe";
                string[] parts = RequestTools.QueryParts(Request);
                int n = parts.Length;

                if (n == 1)
                {

                    filename = parts[0];
                    ingredientsFileName = "Recipes/" + filename + "_ingredients.xml";
                    proceduresFileName = "Recipes/" + filename + "_procedures.xml";
                    imageFileName = "images/Recipes/" + filename + "_image.jpeg";
                    loggedInUser = HttpContext.Current.User.Identity.Name;
                    string recipeName = "";
                    try
                    {
                        using (var con = new SqlConnection(connectionString))
                        {
                            var cmd = "SELECT NAME FROM swapnilh.RECIPE WHERE ID='" + filename + "'";
                            using (var insertCommand = new SqlCommand(cmd, con))
                            {
                                con.Open();
                                recipeName = (string)insertCommand.ExecuteScalar();
                                con.Close();
                            }
                        }
                        RecipeNameStatus.Text = "";
                    }
                    catch (Exception)
                    {
                        RecipeNameStatus.Text = "Error Getting Recipe Name from Database.";
                    }

                    try
                    {
                        using (var con = new SqlConnection(connectionString))
                        {
                            var cmd = "SELECT IMAGE FROM swapnilh.RECIPE WHERE ID='" + filename + "'";
                            using (var insertCommand = new SqlCommand(cmd, con))
                            {
                                con.Open();
                                imageFileName = (string)insertCommand.ExecuteScalar();
                                con.Close();
                            }
                        }
                    }
                    catch (Exception)
                    {
                       
                    }

                    if (imageFileName != null && !imageFileName.Equals(""))
                    {
                        RecipeImage.ImageUrl = imageFileName;
                       
                    }

                    if (recipeName != null && !recipeName.Equals(""))
                    {
                        RecipeName.Text = recipeName;

                        if (File.Exists(MapPath(ingredientsFileName)))
                        {
                            XDocument ingredFile = XDocument.Load(MapPath(ingredientsFileName));
                            var allIngredients = from r in ingredFile.Descendants("Ingredient")
                                                 select r.Element("Name").Value;
                            allIngredientsList = new ArrayList();
                            foreach (var r in allIngredients)
                            {
                                allIngredientsList.Add(r.ToString());
                            }
                            Ingredients.DataSource = allIngredientsList;
                            Ingredients.DataBind();
                        }

                        if (File.Exists(MapPath(proceduresFileName)))
                        {
                            XDocument procFile = XDocument.Load(MapPath(proceduresFileName));
                            var allProcedures = from r in procFile.Descendants("Procedure")
                                                select r.Element("Name").Value;
                            allProceduresList = new ArrayList();
                            foreach (var r in allProcedures)
                            {
                                allProceduresList.Add(r.ToString());
                            }
                            Procedures.DataSource = allProceduresList;
                            Procedures.DataBind();
                        }



                        try
                        {
                            SqlDataSource hashdata = new SqlDataSource();
                            hashdata.ConnectionString = connectionString;
                            hashdata.SelectCommand = "SELECT DISTINCT H.VALUE FROM swapnilh.HASHTAGS H, swapnilh.RECIPE_HASHTAGS RH WHERE RH.RECIPE_ID=@RecipeId AND RH.HASHTAGS_ID = H.ID";
                            hashdata.SelectParameters.Add(new Parameter("RecipeId", System.TypeCode.Int32, filename.ToString()));
                            hashtags.DataSource = hashdata;
                            hashtags.DataBind();
                            HashtagsStatus.Text = "";
                        }
                        catch (Exception)
                        {
                            HashtagsStatus.Text = "Error Loading Hashtags From Database.";
                        }

                        Populate_Comments();
                        if (!Check_Recipe_And_User(parts[0]))
                        {
                            DeleteBtn.CssClass = "hide";
                            EditBtn.CssClass = "hide";
                        }
                        else
                        {
                            TextBox requestBox = (TextBox)RequestOrderView.FindControl("OrderBox");
                            requestBox.CssClass = "hide";
                            Button requestBtn = (Button)RequestOrderView.FindControl("RequestOrderBtn");
                            requestBtn.CssClass = "hide";
                            Label requestLabel = (Label)RequestOrderView.FindControl("OrderLabel");
                            requestLabel.CssClass = "hide";
                            EditBtn.NavigateUrl = "member/AddRecipe.aspx?" + filename;
                        }
                    }
                }
            }
        }

        protected Boolean Check_Recipe_And_User(string recipeid)
        {
            string sqlIns = "SELECT CASE WHEN EXISTS " +
                            " (SELECT * " +
                            " FROM swapnilh.RECIPE " +
                            " WHERE USERNAME = @username AND ID = @recipeid) " +
                            " THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS Status";
            //string sqlIns = "SELECT NAME FROM swapnilh.RECIPE WHERE (USERNAME = @username) AND (ID = @recipeid)";
            SqlConnection conn = new SqlConnection(connectionString);
            conn.Open();
            try
            {
                SqlCommand cmdIns = conn.CreateCommand();
                cmdIns.CommandText = sqlIns;
                cmdIns.Parameters.AddWithValue("@username", loggedInUser);
                cmdIns.Parameters.AddWithValue("@recipeid", recipeid);
                //string Name = Convert.ToString(cmdIns.ExecuteScalar());
                Boolean isValidRecipe = Convert.ToBoolean(cmdIns.ExecuteScalar());
                cmdIns.Dispose();
                cmdIns = null;
                return isValidRecipe;
            }
            catch (Exception)
            {
                //SavingStatus.Text = "Error Fetching Recipe! " + ex.ToString();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }

        protected void Populate_Comments()
        {
            try
            {
                SqlDataSource commentdata = new SqlDataSource();
                commentdata.ConnectionString = connectionString;
                commentdata.SelectCommand = "SELECT COMMENT, USERNAME, CONVERT(VARCHAR(20), DATE, 100) AS DATE FROM swapnilh.COMMENTS WHERE RECIPE_ID=@RecipeId";
                // hashdata.SelectCommand = "SELECT H.VALUE FROM swapnilh.HASHTAGS H";
                commentdata.SelectParameters.Add(new Parameter("RecipeId", System.TypeCode.Int32, filename.ToString()));
                Comments.DataSource = commentdata;
                Comments.DataBind();
                CommentStatus.Text = "";
            }
            catch (Exception)
            {
                CommentStatus.Text = "Error Loading Comments From Database.";
            }
        }

        protected void DeleteBtn_Click(object sender, EventArgs e)
        {
            string sqlIns = "DELETE FROM swapnilh.RECIPE WHERE ID = @recipeid";
            SqlConnection conn = new SqlConnection(connectionString);
            conn.Open();
            try
            {
                SqlCommand cmdIns = conn.CreateCommand();
                cmdIns.CommandText = sqlIns;
                cmdIns.Parameters.AddWithValue("@recipeid", filename);
                cmdIns.ExecuteScalar();
                cmdIns.Dispose();
                cmdIns = null;
                if (File.Exists(MapPath(imageFileName)))
                {
                    File.Delete(MapPath(imageFileName));
                }
                if (File.Exists(MapPath(ingredientsFileName)))
                {
                    File.Delete(MapPath(ingredientsFileName));
                }
                if (File.Exists(MapPath(proceduresFileName)))
                {
                    File.Delete(MapPath(proceduresFileName));
                }
                Response.Redirect("member/MyRecipes.aspx");
            }
            catch (Exception)
            {
                ButtonStatus.Text = "Error Processing Request";
            }
            finally
            {
                conn.Close();
            }

        }

        protected void PostBtn_Click(object sender, EventArgs e)
        {
            TextBox commentBox = (TextBox)LoginCommentView.FindControl("CommentBox");
            if (commentBox.Text.Trim().Equals(""))
            {
                return;
            }
            string sqlIns = "INSERT INTO swapnilh.COMMENTS (USERNAME, COMMENT, DATE, RECIPE_ID) VALUES (@username, @comment, @date, @recipeid)";
            SqlConnection conn = new SqlConnection(connectionString);
            conn.Open();
            try
            {
                SqlCommand cmdIns = conn.CreateCommand();
                //new SqlCommand(sqlIns, conn.Connection);
                cmdIns.CommandText = sqlIns;
                cmdIns.Parameters.AddWithValue("@username", loggedInUser);
                cmdIns.Parameters.AddWithValue("@comment", Server.HtmlEncode(commentBox.Text.Trim()));
                cmdIns.Parameters.AddWithValue("@date", DateTime.Now);
                cmdIns.Parameters.AddWithValue("@recipeid", filename);

                cmdIns.ExecuteNonQuery();
                cmdIns.Dispose();
                cmdIns = null;
                CommentStatus.Text = "Comment Posted!";
                commentBox.Text = "";
            }
            catch (Exception)
            {
                CommentStatus.Text = "Error Saving Comments! ";
            }
            finally
            {
                conn.Close();
            }
            Populate_Comments();
        }

        protected void RequestOrderBtn_Click(Object sender, EventArgs e)
        {
            //OrderStatus.Text = "Order Requested";
            TextBox quantityBox = (TextBox)RequestOrderView.FindControl("OrderBox");
            if (quantityBox.Text.Trim().Equals(""))
            {
                return;
            }

            string sqlIns = "INSERT INTO swapnilh.ORDERS (RECIPE_ID, USERNAME, ORDER_STATUS_ID, DATE, QUANTITY) VALUES (@recipeid, @username, @orderstatusid, @date, @quantity)";
            SqlConnection conn = new SqlConnection(connectionString);
            conn.Open();
            try
            {
                SqlCommand cmdIns = conn.CreateCommand();
                //new SqlCommand(sqlIns, conn.Connection);
                cmdIns.CommandText = sqlIns;
                cmdIns.Parameters.AddWithValue("@recipeid", filename);
                cmdIns.Parameters.AddWithValue("@username", loggedInUser);
                cmdIns.Parameters.AddWithValue("@orderstatusid", "1");
                cmdIns.Parameters.AddWithValue("@date", DateTime.Now);
                cmdIns.Parameters.AddWithValue("@quantity", Server.HtmlEncode(quantityBox.Text.Trim()));
                cmdIns.ExecuteNonQuery();
                quantityBox.Text = "Order Requested";
                //quantityBox.Text = "";


            }
            catch (Exception ex)
            {
                if (quantityBox != null)
                {
                    quantityBox.Text = "Error Placing Order! " ;
                }
            }
            finally
            {
                conn.Close();
            }
        }
    </script>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="body">
    <div class="container_12 outer-container">
                      <div class="grid_12">
            <p></p>
        </div>
        <div class="grid_12 recipe-name-bar">
            <div class="recipe-name-stitch">
                <asp:Label CssClass="recipe-name" runat="server" ID="RecipeName">RECIPE NAME</asp:Label>
                <asp:Label CssClass="error-status" runat="server" ID="RecipeNameStatus"></asp:Label>
            </div>
        </div>
           <div class="grid_12">
            <p></p>
        </div>
       

        <div class="grid_6 ingredients-div">
            <div class="center-align">
                <h5 class="ingredients-title">INGREDIENTS</h5>
            </div>
            <p><asp:Label CssClass="error-status" runat="server" ID="IngredientsStatus"></asp:Label></p>
            <ol class="ingredients">
                <asp:Repeater runat="server" ID="Ingredients">
                    <ItemTemplate>
                        <li>
                            <asp:Label runat="server" ID="Ingredient" Text='<%# Container.DataItem %>'></asp:Label>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ol>
        </div>
        <div class="grid_6">
            <asp:Image runat="server" ID="RecipeImage" CssClass="grid_12 recipe-image" AlternateText="Recipe Image"/>
            <div class="grid_12">
                <p><asp:Label CssClass="error-status" runat="server" ID="ButtonStatus"></asp:Label></p>
                <asp:HyperLink runat="server" ID="EditBtn" Text="Edit Recipe" CssClass="edit-recipe grid_5" Target="_blank" />
                <asp:Button runat="server" ID="DeleteBtn" Text="Delete Recipe" CssClass="delete-recipe grid_5" OnClick="DeleteBtn_Click" />
                <asp:LoginView runat="server" ID="RequestOrderView">
                    <LoggedInTemplate>
                        <div class="grid_12">
                            <asp:Label runat="server" ID="OrderLabel" Text="Enter Quantity: " CssClass="grid_3 order-box"></asp:Label>
                            <asp:TextBox runat="server" ID="OrderBox" CssClass="order-box grid_5" MaxLength="3"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="OrderBox"
                                ErrorMessage="Only integer numbers allowed"
                                ValidationExpression="\d+$"
                                ForeColor="Red" />
                            <asp:Button runat="server" ID="RequestOrderBtn" Text="Request Order" CssClass="grid_7 request-order" OnClick="RequestOrderBtn_Click" />
                            <asp:Label runat="server" ID="OrderStatus" CssClass="grid_12"></asp:Label>
                        </div>
                    </LoggedInTemplate>
                </asp:LoginView>
            </div>
        </div>
        <div class="grid_12">
            <p></p>
        </div>
        <div class="grid_12 ingredients-div">
            <h4 class="center-align ingredients-title">Procedure</h4>
            <p><asp:Label CssClass="error-status" runat="server" ID="ProcedureStatus"></asp:Label></p>
            <ol class="ingredients">
                <asp:Repeater runat="server" ID="Procedures">
                    <ItemTemplate>
                        <li>
                            <asp:Label runat="server" ID="Procedure" Text='<%# Container.DataItem %>'></asp:Label>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ol>
        </div>
        <div class="grid_12">
            <p></p>
        </div>
        <div class="grid_12 ingredients-div">
            <h4 class="center-align ingredients-title">Related Hash Tags</h4>
            <p><asp:Label CssClass="error-status" runat="server" ID="HashtagsStatus"></asp:Label></p>
            <asp:Repeater runat="server" ID="hashtags">
                <ItemTemplate>
                    <asp:Label ID="hashtag" CssClass="grid_2 hashtags-sel"
                        Text='<%# DataBinder.Eval(Container.DataItem, "VALUE")%>'
                        runat="server" />
                </ItemTemplate>
            </asp:Repeater>
            <p>&nbsp;</p>
        </div>
        <div class="grid_12">
            <p></p>
        </div>
        <div class="grid_12 comments-div">
            <h4 class="comments-title">Comments</h4>
            <asp:LoginView runat="server" ID="LoginCommentView">
                <LoggedInTemplate>
                    <asp:TextBox runat="server" CssClass="comments-textbox" MaxLength="150" ID="CommentBox"></asp:TextBox>
                    <asp:Button runat="server" Text="Post" CssClass="post-button" ID="PostBtn" OnClick="PostBtn_Click" />
                </LoggedInTemplate>
                <AnonymousTemplate>
                    <div class="login-to-post"><asp:LoginStatus runat="server" /> To Post Comments</div>
                </AnonymousTemplate>
            </asp:LoginView>

            <br />
            <asp:Label runat="server" ID="CommentStatus" CssClass="grid_12"></asp:Label>
            <ul class="comments">
                <asp:Repeater runat="server" ID="Comments">
                    <ItemTemplate>
                        <li>
                            <div class="grid_12">
                                
                               <i>"<asp:Label ID="Comment"
                                    Text='<%# DataBinder.Eval(Container.DataItem, "COMMENT")%>'
                                    runat="server" />"</i> - by 
                                <asp:Label ID="CommentUser"
                                    Text='<%# DataBinder.Eval(Container.DataItem, "USERNAME")%>'
                                    runat="server" />
                                <asp:Label ID="CommentDate"
                                    Text='<%# DataBinder.Eval(Container.DataItem, "DATE")%>'
                                    runat="server" CssClass="posted-date"/>
                            </div>
                            
                            <div class="grid_2">&nbsp;</div>
                            <%--<div class="grid_3">
                                <asp:Label ID="CommentDate"
                                    Text='<%# DataBinder.Eval(Container.DataItem, "DATE")%>'
                                    runat="server" />
                            </div>--%>
                        </li>
                        
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
        </div>
    </div>
</asp:Content>
