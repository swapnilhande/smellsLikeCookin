<%@ Page Language="C#" MasterPageFile="~/project/MasterPage.master" EnableEventValidation="false"%>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Services" %>
<%@ Import Namespace="edu.neu.ccis.rasala" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <title>Browse Recipes</title>
    <link rel="stylesheet" href="css/BrowseRecipes.css" type="text/css" />
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

        });
    </script>
    <script runat="server">
    
        protected static string connectionString = ConfigurationManager.ConnectionStrings["swapnilhCS"].ConnectionString;
        protected static string queryUserName;
        //protected static string resultRecipeQuery = "SELECT DISTINCT R.ID, COUNT(C.ID) AS COMMENTS, 'ViewRecipe.aspx?'+ CAST(R.ID AS VARCHAR(MAX)) AS RECIPEPAGE, R.NAME, R.USERNAME, CONVERT(VARCHAR(20), R.DATE, 100) AS DATE, CASE WHEN R.IMAGE IS NULL THEN 'http://placehold.it/300&text=No+Image+Uploaded' ELSE R.IMAGE END AS IMAGE FROM swapnilh.RECIPE R LEFT OUTER JOIN swapnilh.COMMENTS C ON C.RECIPE_ID = R.ID GROUP BY R.ID, R.NAME, R.USERNAME, R.DATE, R.IMAGE";
        //protected static string userResultRecipeQuery = "SELECT DISTINCT R.ID, COUNT(C.ID) AS COMMENTS, 'ViewRecipe.aspx?'+ CAST(R.ID AS VARCHAR(MAX)) AS RECIPEPAGE, R.NAME, R.USERNAME, CONVERT(VARCHAR(20), R.DATE, 100) AS DATE, CASE WHEN R.IMAGE IS NULL THEN 'http://placehold.it/300&text=No+Image+Uploaded' ELSE R.IMAGE END AS IMAGE FROM swapnilh.RECIPE R LEFT OUTER JOIN swapnilh.COMMENTS C ON C.RECIPE_ID = R.ID AND R.USERNAME = @username GROUP BY R.ID, R.NAME, R.USERNAME, R.DATE, R.IMAGE";
        protected static string resultRecipeQuery ;
        protected static string userResultRecipeQuery ;
        protected static string loggedInUser;
        protected static Boolean isUserBrowse;
        
        protected void Page_Load(Object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //resultSize = 20;
                //offset = 0;
                resultRecipeQuery = "WITH CTE_TAB ( ID, RECIPEPAGE, USERPAGE, NAME, USERNAME, DATE, IMAGE) AS (SELECT DISTINCT R.ID, 'ViewRecipe.aspx?'+ CAST(R.ID AS VARCHAR(MAX)) AS RECIPEPAGE, 'BrowseRecipes.aspx?'+ CAST(R.USERNAME AS VARCHAR(MAX)) AS USERPAGE,  R.NAME, R.USERNAME, CONVERT(VARCHAR(20), R.DATE, 100) AS DATE, CASE WHEN R.IMAGE IS NULL OR R.IMAGE = '' THEN 'http://placehold.it/300&text=No+Image+Uploaded' ELSE R.IMAGE END AS IMAGE FROM swapnilh.RECIPE R INNER JOIN swapnilh.RECIPE_HASHTAGS RH ON R.ID = RH.RECIPE_ID ) SELECT CT.ID, COUNT(C.ID) AS COMMENTS, CT.RECIPEPAGE, CT.USERPAGE, CT.NAME, CT.USERNAME, CT.DATE, CT.IMAGE FROM CTE_TAB CT LEFT OUTER JOIN swapnilh.COMMENTS C ON CT.ID = C.RECIPE_ID GROUP BY CT.ID, CT.NAME, CT.USERNAME, CT.DATE, CT.IMAGE, CT.RECIPEPAGE, CT.USERPAGE";
                userResultRecipeQuery = "WITH CTE_TAB ( ID, RECIPEPAGE, USERPAGE, NAME, USERNAME, DATE, IMAGE) AS (SELECT DISTINCT R.ID, 'ViewRecipe.aspx?'+ CAST(R.ID AS VARCHAR(MAX)) AS RECIPEPAGE, 'BrowseRecipes.aspx?'+ CAST(R.USERNAME AS VARCHAR(MAX)) AS USERPAGE,  R.NAME, R.USERNAME, CONVERT(VARCHAR(20), R.DATE, 100) AS DATE, CASE WHEN R.IMAGE IS NULL OR R.IMAGE = '' THEN 'http://placehold.it/300&text=No+Image+Uploaded' ELSE R.IMAGE END AS IMAGE FROM swapnilh.RECIPE R INNER JOIN swapnilh.RECIPE_HASHTAGS RH ON R.ID = RH.RECIPE_ID WHERE R.USERNAME = @username) SELECT CT.ID, COUNT(C.ID) AS COMMENTS, CT.RECIPEPAGE, CT.USERPAGE, CT.NAME, CT.USERNAME, CT.DATE, CT.IMAGE FROM CTE_TAB CT LEFT OUTER JOIN swapnilh.COMMENTS C ON CT.ID = C.RECIPE_ID GROUP BY CT.ID, CT.NAME, CT.USERNAME, CT.DATE, CT.IMAGE, CT.RECIPEPAGE, CT.USERPAGE";
                loggedInUser = HttpContext.Current.User.Identity.Name;
                isUserBrowse = false;
                    
                
                string[] parts = RequestTools.QueryParts(Request);
                int n = parts.Length;

                if (n == 1)
                {
                    queryUserName = parts[0];
                    isUserBrowse = true;
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

                        HashTagsStatus.Text = "Error Loading Hash Tags From Database.";
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
                        
                        ResultsStatus.Text = "Error Loading Recipes from Database";
                    }
                }
                else
                {

                    try
                    {
                        SqlDataSource hashdata = new SqlDataSource();
                        hashdata.ConnectionString = connectionString;
                        hashdata.SelectCommand = "SELECT ID, VALUE FROM swapnilh.Hashtags";
                        hashtags.DataSource = hashdata;
                        hashtags.DataBind();
                        HashTagsStatus.Text = "";
                    }
                    catch (Exception)
                    {
                        
                        HashTagsStatus.Text = "Error Loading Hash Tags From Database.";
                    }

                    try
                    {
                        SqlDataSource recipedata = new SqlDataSource();
                        recipedata.ConnectionString = connectionString;
                        recipedata.SelectCommand = resultRecipeQuery;
                        recipes.DataSource = recipedata;
                        recipes.DataBind();
                        ResultsStatus.Text = "";
                    }
                    catch (Exception)
                    {
                        
                        ResultsStatus.Text = "Error Loading Recipes from Database";
                    }
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
            
            string query;
            if (isUserBrowse)
            {
                query = userResultRecipeQuery;
            }
            else
            {
                query = resultRecipeQuery;
            }
            int size = hashtags.Items.Count;
            Boolean foundSelected = false;
            for (int i = 0; i < size; i++)
            {
                LinkButton button = ((LinkButton)hashtags.Items[i].FindControl("hashtag"));

                if (button.CssClass.Contains("hashtags-sel"))
                {
                    if (!foundSelected)
                    {
                        if (isUserBrowse)
                        {
                            query = "WITH CTE_TAB ( ID, RECIPEPAGE, USERPAGE, NAME, USERNAME, DATE, IMAGE) AS (SELECT DISTINCT R.ID, 'ViewRecipe.aspx?'+ CAST(R.ID AS VARCHAR(MAX)) AS RECIPEPAGE, 'BrowseRecipes.aspx?'+ CAST(R.USERNAME AS VARCHAR(MAX)) AS USERPAGE,  R.NAME, R.USERNAME, CONVERT(VARCHAR(20), R.DATE, 100) AS DATE, CASE WHEN R.IMAGE IS NULL OR R.IMAGE = '' THEN 'http://placehold.it/300&text=No+Image+Uploaded' ELSE R.IMAGE END AS IMAGE FROM swapnilh.RECIPE R INNER JOIN swapnilh.RECIPE_HASHTAGS RH ON R.ID = RH.RECIPE_ID WHERE R.USERNAME = @username RH.HASHTAGS_ID IN (";  
                        }
                        else
                        {
                            query = "WITH CTE_TAB ( ID, RECIPEPAGE, USERPAGE, NAME, USERNAME, DATE, IMAGE) AS (SELECT DISTINCT R.ID, 'ViewRecipe.aspx?'+ CAST(R.ID AS VARCHAR(MAX)) AS RECIPEPAGE, 'BrowseRecipes.aspx?'+ CAST(R.USERNAME AS VARCHAR(MAX)) AS USERPAGE, R.NAME, R.USERNAME, CONVERT(VARCHAR(20), R.DATE, 100) AS DATE, CASE WHEN R.IMAGE IS NULL OR R.IMAGE = '' THEN 'http://placehold.it/300&text=No+Image+Uploaded' ELSE R.IMAGE END AS IMAGE FROM swapnilh.RECIPE R INNER JOIN swapnilh.RECIPE_HASHTAGS RH ON R.ID = RH.RECIPE_ID WHERE RH.HASHTAGS_ID IN (";
                        }
                        foundSelected = true;
                    }

                    query += button.CommandArgument + ", ";
                    
                }

            }

            if (foundSelected)
            {
                query = query.Substring(0, query.Length - 2);
                query += ")) SELECT CT.ID, COUNT(C.ID) AS COMMENTS, CT.RECIPEPAGE,CT.USERPAGE, CT.NAME, CT.USERNAME, CT.DATE, CT.IMAGE FROM CTE_TAB CT LEFT OUTER JOIN swapnilh.COMMENTS C ON CT.ID = C.RECIPE_ID GROUP BY CT.ID, CT.NAME, CT.USERNAME, CT.DATE, CT.IMAGE, CT.RECIPEPAGE, CT.USERPAGE";
            }

            try
            {
                SqlDataSource data = new SqlDataSource();
                data.ConnectionString = connectionString;
                data.SelectCommand = query;
                if (isUserBrowse)
                {
                    data.SelectParameters.Add(new Parameter("username", System.TypeCode.String, queryUserName));
                }
                recipes.DataSource = data;
                recipes.DataBind();
                ResultsStatus.Text = "";
            }
            catch (Exception)
            {

                ResultsStatus.Text = "Error Loading Recipes from Database.";
            }
        }
                    
    </script>
</asp:Content>
<asp:Content ContentPlaceHolderID="body" runat="server">
    <div class="container_12">
        <div class="grid_12 hash-background">
            <label class="grid_12"> &nbsp;&nbsp;Select the below hash tags to filter the results accordingly:</label>
            <p>&nbsp;</p>
            <asp:Label runat="server" ID="HashTagsStatus" CssClass="error-status"></asp:Label>
            <asp:Repeater runat="server" ID="hashtags" OnItemCommand="hashtags_ItemCommand">
                <ItemTemplate>
                    <asp:LinkButton ID="hashtag" CssClass="grid_2 hashtags-unsel"
                        Text='<%# DataBinder.Eval(Container.DataItem, "VALUE")%>'
                        CommandArgument='<%# DataBinder.Eval(Container.DataItem, "ID")%>' runat="server" />

                </ItemTemplate>
            </asp:Repeater>
            <p>&nbsp;</p>
        </div>
        <div class="grid_12 recipe-bar">
            <asp:Label runat="server" ID="recipe_bar">Recipes</asp:Label>
        </div>
        <div class="grid_12">
            <asp:Label runat="server" ID="ResultsStatus" CssClass="error-status"></asp:Label>
            <ol class="results">
                <asp:Repeater runat="server" ID="recipes">
                    <ItemTemplate>
                        <li>
                            <asp:Image runat="server" ImageUrl="images/toggle_expand.png" CssClass="toggle-expand"/>
                            <asp:Image runat="server" ImageUrl="images/toggle.png" CssClass="toggle-collapse hide"/>
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
                                    <asp:HyperLink CssClass="recipe-user-link" runat="server" ID="RecipeUser" Text='<%# DataBinder.Eval(Container.DataItem, "UserName")%>' Target="_blank" NavigateUrl='<%# DataBinder.Eval(Container.DataItem, "USERPAGE")%>'></asp:HyperLink>
                                    <p>
                                        There are <%# DataBinder.Eval(Container.DataItem, "COMMENTS")%> comments about this recipe!
                                    </p>
                                    <asp:HyperLink CssClass="recipe-name-link" 
                                        runat="server" ID="LinkButton1" Text='View Recipe' 
                                        NavigateUrl='<%# DataBinder.Eval(Container.DataItem, "RECIPEPAGE")%>'
                                        Target="_blank" />
                                    
                            
                                </div>
                            </div>
                            <%--<asp:LinkButton Text="Delete" CssClass="unhide hide" ID="RecipeDelete" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "ID")%>' OnClick="RecipeDelete_Click"></asp:LinkButton>--%>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ol>
            <%--<asp:Button runat="server" Text="Show More Results" />--%>
        </div>
    </div>
</asp:Content>
