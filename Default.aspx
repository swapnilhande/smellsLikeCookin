<%@ Page Language="C#" MasterPageFile="~/project/MasterPage.master" EnableEventValidation="false"%>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <title>Smells Like Cookin'</title>
    <link rel="stylesheet" href="css/HomePage.css" type="text/css" />
    <script>
        
        //$("#slideshow  div:gt(0)").hide();
        //setInterval(function () {
        //    $('#slideshow > div:first')
        //      .fadeOut()
        //      .next()
        //      .fadeIn()
        //      .end()
        //      .appendTo('#slideshow');
        //}, 2500);
    </script>
    <script runat="server">
    
        protected static string connectionString = ConfigurationManager.ConnectionStrings["swapnilhCS"].ConnectionString;
        protected static string resultRecipeQuery = "SELECT DISTINCT R.ID, COUNT(C.ID) AS COMMENTS, 'ViewRecipe.aspx?'+ CAST(R.ID AS VARCHAR(MAX)) AS RECIPEPAGE, 'BrowseRecipes.aspx?'+ CAST(R.USERNAME AS VARCHAR(MAX)) AS USERPAGE, R.NAME, R.USERNAME, CONVERT(VARCHAR(20), R.DATE, 100) AS DATE, CASE WHEN R.IMAGE IS NULL OR R.IMAGE = '' THEN 'http://placehold.it/300&text=No+Image+Uploaded' ELSE R.IMAGE END AS IMAGE FROM swapnilh.RECIPE R LEFT OUTER JOIN swapnilh.COMMENTS C ON C.RECIPE_ID = R.ID  GROUP BY R.ID, R.NAME, R.USERNAME, R.DATE, R.IMAGE ORDER BY DATE DESC";

        protected void Page_Load(object sender, EventArgs e)
        {
            Load_Top_Contributors();
            Load_Top_Requested();
            Load_Top_Commented();
            Load_Recent_Orders();
            Load_Cooking_Activity();
        }

        protected void Load_Top_Contributors()
        {
            try
            {
                SqlDataSource hashdata = new SqlDataSource();
                hashdata.ConnectionString = connectionString;
                hashdata.SelectCommand = "SELECT USERNAME, COUNT(USERNAME) AS USERS, 'BrowseRecipes.aspx?'+ CAST(USERNAME AS VARCHAR(MAX)) AS USERPAGE FROM swapnilh.RECIPE GROUP BY USERNAME ORDER BY USERS DESC";
                TopContributors.DataSource = hashdata;
                TopContributors.DataBind();
                TopContriStatus.Text = "";
            }
            catch (Exception)
            {
                TopContriStatus.Text = "Error Loading Top Contributors From Database.";
            }
        }

        protected void Load_Top_Requested()
        {
            try
            {
                SqlDataSource hashdata = new SqlDataSource();
                hashdata.ConnectionString = connectionString;
                hashdata.SelectCommand = "SELECT RECIPE.ID, RECIPE.NAME, COUNT(RECIPE.ID) AS ORDERCOUNT, 'ViewRecipe.aspx?'+ CAST(RECIPE.ID AS VARCHAR(MAX)) AS RECIPEPAGE FROM swapnilh.RECIPE INNER JOIN swapnilh.ORDERS ON RECIPE.ID = ORDERS.RECIPE_ID GROUP BY RECIPE.ID, RECIPE.NAME ORDER BY ORDERCOUNT DESC";
                TopRequests.DataSource = hashdata;
                TopRequests.DataBind();
                TopRequestStatus.Text = "";
            }
            catch (Exception)
            {
                
                TopRequestStatus.Text = "Error Loading Top Requested Recipes From Database.";
            }
        }

        protected void Load_Top_Commented()
        {
            try
            {
                SqlDataSource hashdata = new SqlDataSource();
                hashdata.ConnectionString = connectionString;
                hashdata.SelectCommand = "SELECT RECIPE.ID, RECIPE.NAME, 'ViewRecipe.aspx?'+ CAST(RECIPE.ID AS VARCHAR(MAX)) AS RECIPEPAGE, COUNT(RECIPE.ID) AS COMMENTCOUNT FROM swapnilh.RECIPE INNER JOIN swapnilh.COMMENTS ON RECIPE.ID = COMMENTS.RECIPE_ID GROUP BY RECIPE.ID, RECIPE.NAME ORDER BY COMMENTCOUNT DESC";
                TopComments.DataSource = hashdata;
                TopComments.DataBind();
                TopCommentsStatus.Text = "";
            }
            catch (Exception)
            {
                
                TopCommentsStatus.Text = "Error Loading Top Commented Recipe From Database.";
            }
        }

        protected void Load_Recent_Orders()
        {
            try
            {
                SqlDataSource hashdata = new SqlDataSource();
                hashdata.ConnectionString = connectionString;
                hashdata.SelectCommand = "SELECT RECIPE.ID, RECIPE.NAME, ORDERS.USERNAME, ORDERS.DATE, 'ViewRecipe.aspx?'+ CAST(RECIPE.ID AS VARCHAR(MAX)) AS RECIPEPAGE, 'BrowseRecipes.aspx?'+ CAST(ORDERS.USERNAME AS VARCHAR(MAX)) AS USERPAGE FROM swapnilh.RECIPE INNER JOIN swapnilh.ORDERS ON RECIPE.ID = ORDERS.RECIPE_ID ORDER BY ORDERS.DATE DESC";
                RecentOrders.DataSource = hashdata;
                RecentOrders.DataBind();
                RecentOrdersStatus.Text = "";
            }
            catch (Exception)
            {
                
                RecentOrdersStatus.Text = "Error Loading Recent Orders From Database.";
            }
        }

        protected void Load_Cooking_Activity()
        {
            try
            {
                SqlDataSource hashdata = new SqlDataSource();
                hashdata.ConnectionString = connectionString;
                hashdata.SelectCommand = resultRecipeQuery;
                CookingActivity.DataSource = hashdata;
                CookingActivity.DataBind();
                CookingActivityStatus.Text = "";
            }
            catch (Exception)
            {
                
                CookingActivityStatus.Text = "Error Loading Cooking Activity From Database.";
            }
        }
            
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="body" runat="server">
    <div class="container_12">
        <div class="grid_3 left-pane">
            <div class="top-contri-bar">
                <label class="top-contri-title">Top Contributors</label>
            </div>
            <p><asp:Label runat="server" ID="TopContriStatus" CssClass="error-status"></asp:Label></p>
            <ul>
                <asp:Repeater ID="TopContributors" runat="server">
                    <ItemTemplate>
                        <li class="top-contri-li">
                            <asp:HyperLink runat="server" ID="TopContriUser" Text='<%# DataBinder.Eval(Container.DataItem, "USERNAME")%>' Target="_blank" NavigateUrl='<%# DataBinder.Eval(Container.DataItem, "USERPAGE")%>'></asp:HyperLink>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
                
            </ul>
            
            <p></p>
            <div class="top-contri-bar">
                <label class="top-contri-title">Top Requested Recipes</label>
            </div>
            <p><asp:Label runat="server" ID="TopRequestStatus" CssClass="error-status"></asp:Label></p>
            <ul>
                <asp:Repeater ID="TopRequests" runat="server">
                    <ItemTemplate>
                        <li class="top-contri-li">
                            <asp:HyperLink runat="server" ID="TopReqRecipe" Text='<%# DataBinder.Eval(Container.DataItem, "NAME")%>' Target="_blank" NavigateUrl='<%# DataBinder.Eval(Container.DataItem, "RECIPEPAGE")%>'></asp:HyperLink>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
            
        </div>
        <div class="grid_6 center-pane">
            <div class="top-contri-bar">
                <b>Cooking Activity</b>
            </div>
            <p><asp:Label runat="server" ID="CookingActivityStatus" CssClass="error-status"></asp:Label></p>
                
            <%--<div>--%>
                <asp:Repeater runat="server" ID="CookingActivity">
                    <ItemTemplate>
                        <%--<div>--%>
                        <div class="recipe-details grid_12">
                            "<asp:HyperLink ID="Label1" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "NAME")%>' Target="_blank" NavigateUrl='<%# DataBinder.Eval(Container.DataItem, "RECIPEPAGE")%>'></asp:HyperLink>"
                            <i> <label class="recipe-user">- by </label><asp:HyperLink ID="Label2" CssClass="recipe-user" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "USERNAME")%>' Target="_blank" NavigateUrl='<%# DataBinder.Eval(Container.DataItem, "USERPAGE")%>'/></i>
                            
                        </div>
                            <div>
                        <asp:Image ID="Image1" ImageUrl='<%# DataBinder.Eval(Container.DataItem, "IMAGE")%>' CssClass="image grid_12" runat="server" />
                        </div>
                        <div class="grid_12"><p></p></div>
                         <%--</div>--%>
                    </ItemTemplate>
                    
                </asp:Repeater>
            <%--</div>--%>
        </div>
        <div class="grid_3 left-pane">
            <div class="top-contri-bar">
                <label class="top-contri-title">Top Commented Recipes</label>
            </div>
            <p><asp:Label runat="server" ID="TopCommentsStatus" CssClass="error-status"></asp:Label></p>
            <ul>
                <asp:Repeater ID="TopComments" runat="server">
                    <ItemTemplate>
                        <li class="top-contri-li">
                            <asp:HyperLink runat="server" ID="TopCommentedRecipe" Text='<%# DataBinder.Eval(Container.DataItem, "NAME")%>' Target="_blank" NavigateUrl='<%# DataBinder.Eval(Container.DataItem, "RECIPEPAGE")%>'></asp:HyperLink>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
            
            <p></p>
            <div class="top-contri-bar">
                <b>Recent Orders</b>
            </div>
            <p><asp:Label runat="server" ID="RecentOrdersStatus" CssClass="error-status"></asp:Label></p>
            <ul>
                <asp:Repeater ID="RecentOrders" runat="server">
                    <ItemTemplate>
                        <li class="top-contri-li">
                            <asp:HyperLink runat="server" ID="TopCommentedRecipe" Text='<%# DataBinder.Eval(Container.DataItem, "NAME")%>' Target="_blank" NavigateUrl='<%# DataBinder.Eval(Container.DataItem, "RECIPEPAGE")%>'></asp:HyperLink>
                            <i><br /> <label class="recipe-user">- by</label>
                            <label class="recipe-user"><asp:HyperLink runat="server" ID="HyperLink1" CssClass="recipe-user1" Text='<%# DataBinder.Eval(Container.DataItem, "USERNAME")%>' Target="_blank" NavigateUrl='<%# DataBinder.Eval(Container.DataItem, "USERPAGE")%>'></asp:HyperLink></label></i>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
            

        </div>
    </div>
</asp:Content>


