<%@ Page Language="C#" MasterPageFile="~/project/member/MasterPage.master" EnableEventValidation="false" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Services" %>
<%@ Import Namespace="edu.neu.ccis.rasala" %>
<%@ Import Namespace="System.IO" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>My Recipes</title>
    <link rel="stylesheet" href="../css/BrowseRecipes.css" type="text/css" />
    <script>
        $(document).ready(function () {
            $(".hashtags-unsel").click(function () {
                $(this).toggleClass("hashtags-sel");

            });

            $(".results li").click(function () {
                $(".toggle-expand", this).toggleClass("hide");
                $(".toggle-collapse", this).toggleClass("hide");
                $(".recipe-details-div", this).slideToggle("slow");

            });

            $(".results li").mouseenter(function () {
                $(".unhide", this).removeClass("hide");
            });
            $(".results li").mouseleave(function () {
                $(".unhide", this).addClass("hide");
            });

        });
    </script>
    <script runat="server">
    
        protected static string connectionString = ConfigurationManager.ConnectionStrings["swapnilhCS"].ConnectionString;
        protected static string queryUserName;
        protected static string userResultRecipeQuery = "SELECT DISTINCT R.ID, COUNT(C.ID) AS COMMENTS, '../ViewRecipe.aspx?'+ CAST(R.ID AS VARCHAR(MAX)) AS RECIPEPAGE,'../BrowseRecipes.aspx?'+ CAST(R.USERNAME AS VARCHAR(MAX)) AS USERPAGE, R.NAME, R.USERNAME, CONVERT(VARCHAR(20), R.DATE, 100) AS DATE, CASE WHEN R.IMAGE IS NULL OR R.IMAGE = '' THEN 'http://placehold.it/300&text=No+Image+Uploaded' ELSE R.IMAGE END AS IMAGE FROM swapnilh.RECIPE R LEFT OUTER JOIN swapnilh.COMMENTS C ON C.RECIPE_ID = R.ID WHERE R.USERNAME = @username GROUP BY R.ID, R.NAME, R.USERNAME, R.DATE, R.IMAGE";
        protected static Boolean isUserBrowse = false;

        protected void Page_Load(Object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                queryUserName = HttpContext.Current.User.Identity.Name;
                try
                {
                    SqlDataSource hashdata = new SqlDataSource();
                    hashdata.ConnectionString = connectionString;
                    hashdata.SelectCommand = "SELECT DISTINCT H.ID, H.VALUE " +
                        "FROM swapnilh.HASHTAGS H, swapnilh.RECIPE_HASHTAGS RH, swapnilh.RECIPE R " +
                        "WHERE RH.HASHTAGS_ID = H.ID AND RH.RECIPE_ID = R.ID AND R.USERNAME = @username";
                    hashdata.SelectParameters.Add(new Parameter("username", System.TypeCode.String, queryUserName));
                    hashtags.DataSource = hashdata;
                    hashtags.DataBind();
                    HashTagsStatus.Text = "";
                }
                catch (Exception)
                {
                    HashTagsStatus.Text = "Error Loading Hash Tags from Database";
                }

                try
                {
                    SqlDataSource recipedata = new SqlDataSource();
                    recipedata.ConnectionString = connectionString;
                    recipedata.SelectCommand = userResultRecipeQuery;
                    recipedata.SelectParameters.Add(new Parameter("username", System.TypeCode.String, queryUserName));
                    recipes.DataSource = recipedata;
                    recipes.DataBind();
                    ResultsStatus.Text = "";
                }
                catch (Exception)
                {
                    ResultsStatus.Text = "Error Loading Recipes from Database.";
                }
            }
        }



        protected void hashtags_ItemCommand(Object sender, RepeaterCommandEventArgs e)
        {
            LinkButton selectedButton = ((LinkButton)e.Item.FindControl("hashtag"));
            if (selectedButton.CssClass.Contains("hashtags-sel"))
            {
                selectedButton.CssClass = "grid_2 hashtags-unsel";
            }
            else
            {
                selectedButton.CssClass = "grid_2 hashtags-unsel hashtags-sel";
            }

            string query = userResultRecipeQuery;
            int size = hashtags.Items.Count;
            Boolean foundSelected = false;
            for (int i = 0; i < size; i++)
            {
                LinkButton button = ((LinkButton)hashtags.Items[i].FindControl("hashtag"));
                if (button.CssClass.Contains("hashtags-sel"))
                {
                    if (!foundSelected)
                    {
                        query = "WITH CTE_TAB ( ID, RECIPEPAGE, USERPAGE, NAME, USERNAME, DATE, IMAGE) AS ( SELECT DISTINCT R.ID, '../ViewRecipe.aspx?'+ CAST(R.ID AS VARCHAR(MAX)) AS RECIPEPAGE, '../BrowseRecipes.aspx?'+ CAST(R.USERNAME AS VARCHAR(MAX)) AS USERPAGE, R.NAME, R.USERNAME, CONVERT(VARCHAR(20), R.DATE, 100) AS DATE, CASE WHEN R.IMAGE IS NULL OR R.IMAGE = '' THEN 'http://placehold.it/300&text=No+Image+Uploaded' ELSE R.IMAGE END AS IMAGE FROM swapnilh.RECIPE AS R INNER JOIN swapnilh.RECIPE_HASHTAGS AS RH ON R.ID = RH.RECIPE_ID AND RH.HASHTAGS_ID IN ( ";
                        foundSelected = true;
                    }
                    query += button.CommandArgument + ", ";
                }
            }

            if (foundSelected)
            {
                query = query.Substring(0, query.Length - 2);
                query += ")) SELECT CT.ID, COUNT(C.ID) AS COMMENTS, CT.RECIPEPAGE, CT.USERPAGE, CT.NAME, CT.USERNAME, CT.DATE, CT.IMAGE FROM CTE_TAB CT LEFT OUTER JOIN swapnilh.COMMENTS C ON CT.ID = C.RECIPE_ID GROUP BY CT.ID, CT.NAME, CT.USERNAME, CT.DATE, CT.IMAGE, CT.RECIPEPAGE,CT.USERPAGE";
            }

            try
            {
                SqlDataSource data = new SqlDataSource();
                data.ConnectionString = connectionString;
                data.SelectCommand = query;
                data.SelectParameters.Add(new Parameter("username", System.TypeCode.String, queryUserName));
                recipes.DataSource = data;
                recipes.DataBind();
                ResultsStatus.Text = "";
            }
            catch (Exception)
            {
                ResultsStatus.Text = "Error Loading Results From Database.";
            }
        }

        protected void DeleteBtn_Click(object sender, EventArgs e)
        {
            LinkButton selectedButton = (LinkButton)sender;
            string filename = selectedButton.CommandArgument;
            string ingredientsFileName = "../Recipes/" + filename + "_ingredients.xml";
            string proceduresFileName = "../Recipes/" + filename + "_procedures.xml";
            string imageFileName = "../images/Recipes/" + filename + "_image.jpeg";
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
                ResultsStatus.Text = "";
            }
            catch (Exception)
            {
                ResultsStatus.Text = "Error Deleting Recipe.";
            }
            finally
            {
                conn.Close();
            }

            try
            {
                if (File.Exists(MapPath(imageFileName)))
                {
                    File.Delete(MapPath(imageFileName));
                }
            }
            catch (Exception)
            {
               
            }
            
            if (File.Exists(MapPath(ingredientsFileName)))
            {
                File.Delete(MapPath(ingredientsFileName));
            }
            if (File.Exists(MapPath(proceduresFileName)))
            {
                File.Delete(MapPath(proceduresFileName));
            }
            Response.Redirect("MyRecipes.aspx");

            //try
            //{
            //    SqlDataSource hashdata = new SqlDataSource();
            //    hashdata.ConnectionString = connectionString;
            //    hashdata.SelectCommand = "SELECT DISTINCT H.ID, H.VALUE " +
            //        "FROM swapnilh.HASHTAGS H, swapnilh.RECIPE_HASHTAGS RH, swapnilh.RECIPE R " +
            //        "WHERE RH.HASHTAGS_ID = H.ID AND RH.RECIPE_ID = R.ID AND R.USERNAME = @username";
            //    hashdata.SelectParameters.Add(new Parameter("username", System.TypeCode.String, queryUserName));
            //    hashtags.DataSource = hashdata;
            //    hashtags.DataBind();
            //    HashTagsStatus.Text = "";
            //}
            //catch (Exception)
            //{
            //    HashTagsStatus.Text = "Error Loading Hashtags From Database.";
            //}

            //try
            //{
            //    SqlDataSource recipedata = new SqlDataSource();
            //    recipedata.ConnectionString = connectionString;
            //    recipedata.SelectCommand = userResultRecipeQuery;
            //    recipedata.SelectParameters.Add(new Parameter("username", System.TypeCode.String, queryUserName));
            //    recipes.DataSource = recipedata;
            //    recipes.DataBind();
            //    ResultsStatus.Text = "";
            //}
            //catch (Exception)
            //{
            //    ResultsStatus.Text = "Error Loading Recipes From Database";
            //}
        }
        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="container_12">
        <div class="grid_12 hash-background">
            <p>Select the below hash tags to filter the results accordingly:</p>
            <asp:Label runat="server" ID="HashTagsStatus" CssClass="error-status"></asp:Label>
            <asp:Repeater runat="server" ID="hashtags" OnItemCommand="hashtags_ItemCommand">
                <ItemTemplate>
                    <asp:LinkButton ID="hashtag" CssClass="grid_2 hashtags-unsel"
                        Text='<%# DataBinder.Eval(Container.DataItem, "VALUE")%>'
                        CommandArgument='<%# DataBinder.Eval(Container.DataItem, "ID")%>' runat="server" />
                </ItemTemplate>
            </asp:Repeater>
        </div>
<%--
        <div class="grid_12">&nbsp;</div>--%>
        <div class="grid_12 recipe-bar">
            <asp:Label runat="server" ID="recipe_bar">Recipes</asp:Label>
        </div>
        <asp:Label runat="server" ID="ResultsStatus" CssClass="error-status"></asp:Label>
        <div class="grid_12">
            <ol class="results">
                <asp:Repeater runat="server" ID="recipes">
                    <ItemTemplate>
                        <li>
                            <asp:Image ID="Image1" runat="server" ImageUrl="../images/toggle_expand.png" CssClass="toggle-expand" />
                            <asp:Image ID="Image2" runat="server" ImageUrl="../images/toggle.png" CssClass="toggle-collapse hide" />
                            <asp:Label runat="server" ID="RecipeName" Text='<%# DataBinder.Eval(Container.DataItem, "Name")%>' />
                            <div class="grid_12 recipe-details-div hide">
                                <asp:Image CssClass="recipe-image" runat="server" ID="RecipeImage" ImageUrl='<%# DataBinder.Eval(Container.DataItem, "Image")%>' />
                                <div class="grid_4 recipe-details">
                                    <h4>Recipe Details</h4>
                                    <p>
                                        " <%# DataBinder.Eval(Container.DataItem, "Name")%> "
                                    </p>
                                    Created On:
                                    <asp:Label runat="server" ID="RecipeDate" Text='<%# DataBinder.Eval(Container.DataItem, "Date")%>'></asp:Label><br />
                                    Created By:
                                    <asp:HyperLink CssClass="recipe-user-link" runat="server" ID="RecipeUser" Text='<%# DataBinder.Eval(Container.DataItem, "UserName")%>' NavigateUrl='<%# DataBinder.Eval(Container.DataItem, "USERPAGE")%>' Target="_blank"></asp:HyperLink>
                                    <p>
                                        There are <%# DataBinder.Eval(Container.DataItem, "COMMENTS")%> comments about this recipe!
                                    </p>
                                    <asp:HyperLink CssClass="recipe-name-link"
                                        runat="server" ID="LinkButton1" Text='View Recipe'
                                        NavigateUrl='<%# DataBinder.Eval(Container.DataItem, "RECIPEPAGE")%>'
                                        Target="_blank" />
                                    <asp:LinkButton Text="Delete" CssClass="delete-button" ID="RecipeDelete" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "ID")%>' OnClick="DeleteBtn_Click"></asp:LinkButton>
                                </div>
                            </div>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ol>

            <%--<asp:Button runat="server" Text="Show More Results" />--%>
        </div>
    </div>
</asp:Content>
