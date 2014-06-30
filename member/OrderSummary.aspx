<%@ Page Language="C#" MasterPageFile="~/project/member/MasterPage.master" EnableEventValidation="false" %>

<%@ Import Namespace="System.Data.SqlClient" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
    <title>Order Summary</title>
    <link rel="stylesheet" href="../css/OrderSummary.css" type="text/css" />
    <script>
        $(document).ready(function () {
            //$(".in-status").hover(function () {
            //    $(".buttons-div").show();
            //    $(".in-status").hide();
            //});
            //$(".buttons-div").mouseleave(function () {
            //    $(".buttons-div").hide();
            //    $(".in-status").show();
            //});

            $(".in-order-ul li").mouseenter(function () {
                // alert("hi");
                $(".buttons-div", this).show();
                $(".in-status", this).hide();
            });
            $(".in-order-ul li").mouseleave(function () {
                // alert("hi");
                $(".buttons-div", this).hide();
                $(".in-status", this).show();
            });

            $(".out-order-ul li").mouseenter(function () {
                // alert("hi");
                $(".buttons-div", this).show();
                $(".out-status", this).hide();
            });
            $(".out-order-ul li").mouseleave(function () {
                // alert("hi");
                $(".buttons-div", this).hide();
                $(".out-status", this).show();
            });
        });
    </script>

    <script runat="server">
    
        protected static string loggedInUser;
        protected static string connectionString = ConfigurationManager.ConnectionStrings["swapnilhCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            loggedInUser = HttpContext.Current.User.Identity.Name;
            OutOrders.DataSource = Get_OutOrders_DataSource();
            OutOrders.DataBind();

            DoneOutOrders.DataSource = Get_DoneOutOrders_DataSource();
            DoneOutOrders.DataBind();

            InOrders.DataSource = Get_InOrders_DataSource();
            InOrders.DataBind();

            DoneInOrders.DataSource = Get_DoneInOrders_DataSource();
            DoneInOrders.DataBind();
        }

        protected SqlDataSource Get_OutOrders_DataSource()
        {
            try
            {
                SqlDataSource outOrderSource = new SqlDataSource();
                outOrderSource.ConnectionString = connectionString;
                outOrderSource.SelectCommand = "SELECT O.ID, O.RECIPE_ID, R.NAME, R.USERNAME, OS.STATUS,  CONVERT(VARCHAR(20), O.DATE, 100) AS DATE, O.QUANTITY "
                + " FROM swapnilh.ORDERS O, swapnilh.ORDER_STATUS OS, swapnilh.RECIPE R " +
                " WHERE O.ORDER_STATUS_ID = OS.ID " +
                " AND O.RECIPE_ID = R.ID " +
                " AND O.USERNAME = @username" +
                " AND O.ORDER_STATUS_ID = 1";
                // hashdata.SelectCommand = "SELECT H.VALUE FROM swapnilh.HASHTAGS H";
                outOrderSource.SelectParameters.Add(new Parameter("username", System.TypeCode.String, loggedInUser));
                OutOrderStatus.Text = "";
                return outOrderSource;
            }
            catch (Exception)
            {
                OutOrderStatus.Text = "Error Loading Orders Requested From Database.";
                return null;
            }
        }

        protected SqlDataSource Get_DoneOutOrders_DataSource()
        {
            try
            {
                SqlDataSource outOrderSource = new SqlDataSource();
                outOrderSource.ConnectionString = connectionString;
                outOrderSource.SelectCommand = "SELECT O.ID, O.RECIPE_ID, R.NAME, R.USERNAME, OS.STATUS,  CONVERT(VARCHAR(20), O.DATE, 100) AS DATE, O.QUANTITY "
                + " FROM swapnilh.ORDERS O, swapnilh.ORDER_STATUS OS, swapnilh.RECIPE R " +
                " WHERE O.ORDER_STATUS_ID = OS.ID " +
                " AND O.RECIPE_ID = R.ID " +
                " AND O.USERNAME = @username" +
                " AND O.ORDER_STATUS_ID <> 1";

                // hashdata.SelectCommand = "SELECT H.VALUE FROM swapnilh.HASHTAGS H";
                outOrderSource.SelectParameters.Add(new Parameter("username", System.TypeCode.String, loggedInUser));
                DoneOutOrderStatus.Text = "";
                return outOrderSource;
            }
            catch (Exception)
            {
                DoneOutOrderStatus.Text = "Error Loading Processed Orders Requested From Database.";
                return null;
            }
        }

        protected SqlDataSource Get_InOrders_DataSource()
        {
            try
            {
                SqlDataSource outOrderSource = new SqlDataSource();
                outOrderSource.ConnectionString = connectionString;
                outOrderSource.SelectCommand = "SELECT O.ID, O.RECIPE_ID, R.NAME, O.USERNAME, OS.STATUS,  CONVERT(VARCHAR(20), O.DATE, 100) AS DATE, O.QUANTITY "
                + " FROM swapnilh.ORDERS O, swapnilh.ORDER_STATUS OS, swapnilh.RECIPE R " +
                " WHERE O.ORDER_STATUS_ID = OS.ID " +
                " AND O.RECIPE_ID = R.ID " +
                " AND R.USERNAME = @username" +
                " AND O.ORDER_STATUS_ID = 1";
                // hashdata.SelectCommand = "SELECT H.VALUE FROM swapnilh.HASHTAGS H";
                outOrderSource.SelectParameters.Add(new Parameter("username", System.TypeCode.String, loggedInUser));
                InOrderStatus.Text = "";
                return outOrderSource;
            }
            catch (Exception)
            {
                InOrderStatus.Text = "Error Loading Orders Requested From Database.";
                return null;
            }
        }

        protected SqlDataSource Get_DoneInOrders_DataSource()
        {
            try
            {
                SqlDataSource inOrderDoneSource = new SqlDataSource();
                inOrderDoneSource.ConnectionString = connectionString;
                inOrderDoneSource.SelectCommand = "SELECT O.ID, O.RECIPE_ID, R.NAME, O.USERNAME, OS.STATUS,  CONVERT(VARCHAR(20), O.DATE, 100) AS DATE, O.QUANTITY "
                + " FROM swapnilh.ORDERS O, swapnilh.ORDER_STATUS OS, swapnilh.RECIPE R " +
                " WHERE O.ORDER_STATUS_ID = OS.ID " +
                " AND O.RECIPE_ID = R.ID " +
                " AND R.USERNAME = @username" +
                " AND O.ORDER_STATUS_ID <> 1";
                // hashdata.SelectCommand = "SELECT H.VALUE FROM swapnilh.HASHTAGS H";
                inOrderDoneSource.SelectParameters.Add(new Parameter("username", System.TypeCode.String, loggedInUser));
                DoneInOrderStatus.Text = "";
                return inOrderDoneSource;
            }
            catch (Exception)
            {
                DoneInOrderStatus.Text = "Error Loading Processed Orders From Database.";
                return null;
            }
        }

        protected void WithdrawBtn_Click(Object sender, EventArgs e)
        {
            LinkButton selectedOrder = (LinkButton)sender;
            string sqlIns = "DELETE swapnilh.ORDERS WHERE ID = @orderid";
            SqlConnection conn = new SqlConnection(connectionString);
            conn.Open();
            try
            {
                SqlCommand cmdIns = conn.CreateCommand();
                //new SqlCommand(sqlIns, conn.Connection);
                cmdIns.CommandText = sqlIns;
                cmdIns.Parameters.AddWithValue("@orderid", selectedOrder.CommandArgument);
                cmdIns.ExecuteNonQuery();
                OutButtonStatus.Text = "";

            }
            catch (Exception)
            {
                OutButtonStatus.Text = "Error Withdrawing Request";
            }
            finally
            {
                conn.Close();
            }

            OutOrders.DataSource = Get_OutOrders_DataSource();
            OutOrders.DataBind();

            DoneOutOrders.DataSource = Get_DoneOutOrders_DataSource();
            OutOrders.DataBind();

        }

        protected void CompleteBtn_Click(Object sender, EventArgs e)
        {
            LinkButton selectedOrder = (LinkButton)sender;
            string sqlIns = "UPDATE swapnilh.ORDERS SET ORDER_STATUS_ID = 2 WHERE ID = @orderid";
            SqlConnection conn = new SqlConnection(connectionString);
            conn.Open();
            try
            {
                SqlCommand cmdIns = conn.CreateCommand();
                //new SqlCommand(sqlIns, conn.Connection);
                cmdIns.CommandText = sqlIns;
                cmdIns.Parameters.AddWithValue("@orderid", selectedOrder.CommandArgument);
                cmdIns.ExecuteNonQuery();
                InButtonStatus.Text = "";

            }
            catch (Exception)
            {
                InButtonStatus.Text = "Error Processing the Request";
            }
            finally
            {
                conn.Close();
            }

            InOrders.DataSource = Get_InOrders_DataSource();
            InOrders.DataBind();

            DoneInOrders.DataSource = Get_DoneInOrders_DataSource();
            DoneInOrders.DataBind();
        }

        protected void DeclineBtn_Click(Object sender, EventArgs e)
        {
            LinkButton selectedOrder = (LinkButton)sender;
            string sqlIns = "UPDATE swapnilh.ORDERS SET ORDER_STATUS_ID = 3 WHERE ID = @orderid";
            SqlConnection conn = new SqlConnection(connectionString);
            conn.Open();
            try
            {
                SqlCommand cmdIns = conn.CreateCommand();
                //new SqlCommand(sqlIns, conn.Connection);
                cmdIns.CommandText = sqlIns;
                cmdIns.Parameters.AddWithValue("@orderid", selectedOrder.CommandArgument);
                cmdIns.ExecuteNonQuery();
                InButtonStatus.Text = "";

            }
            catch (Exception)
            {
                InButtonStatus.Text = "Error Processing the Request";
            }
            finally
            {
                conn.Close();
            }

            InOrders.DataSource = Get_OutOrders_DataSource();
            InOrders.DataBind();

            DoneInOrders.DataSource = Get_DoneInOrders_DataSource();
            DoneInOrders.DataBind();
        }
    </script>
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="body">
    <div class="container_12">
        <div class="grid_12"><p>    </p></div>
        <div class="grid_6 order-out-div">
            <div class="order-out-title">
                <label>Samples I Have Requested</label>
            </div>
            <hr />
            <div class="grid_5" style="text-align:center">Order</div>
            <div class="grid_3">Status</div>
            <div class="grid_4" style="text-align:center">Date</div>
            <br />
            <hr />
            <p>
                <asp:Label runat="server" ID="OutOrderStatus"></asp:Label></p>
            <p>
                <asp:Label runat="server" ID="DoneOutOrderStatus"></asp:Label></p>
            <ul class="out-order-ul">
                <asp:Repeater runat="server" ID="OutOrders">
                    <ItemTemplate>
                        <li>
                            <div class="grid_5">
                                <asp:Label ID="OutOrder" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "NAME")%>' />
                                <asp:Label ID="Label3" runat="server" Text="to" />
                                <asp:Label ID="Label2" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "USERNAME")%>' />
                            </div>
                            <div class="grid_3">
                                <asp:Label ID="OutStatus" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "STATUS")%>' CssClass="out-status" />
                                <div class="buttons-div">
                                    <asp:LinkButton ID="WithdrawBtn" runat="server" Text="Withdraw" CssClass="withdraw-btn"
                                        CommandArgument='<%# DataBinder.Eval(Container.DataItem, "ID")%>' OnClick="WithdrawBtn_Click" />
                                </div>
                            </div>
                            <div class="grid_4">
                                <asp:Label ID="OutDate" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "DATE")%>' />
                            </div>
                        </li>
                        <li></li>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Repeater runat="server" ID="DoneOutOrders">
                    <ItemTemplate>
                        <li>
                            <div class="grid_5">
                                <asp:Label ID="OutOrder" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "NAME")%>' />
                                <asp:Label ID="Label3" runat="server" Text="to" />
                                <asp:Label ID="Label2" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "USERNAME")%>' />
                            </div>
                            <div class="grid_3">
                                <asp:Label ID="OutStatus" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "STATUS")%>' />
                            </div>
                            <div class="grid_4">
                                <asp:Label ID="OutDate" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "DATE")%>' />
                            </div>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
            <p>
                <asp:Label runat="server" ID="OutButtonStatus"></asp:Label></p>
        </div>

        <div class="grid_6 order-in-div">
            <div class="order-in-title">
                <label>Samples Requested To Me</label>
            </div>
             <hr />
              
            <div class="grid_5" style="text-align:center">Order</div>
            <div class="grid_3">Date</div>
            <div class="grid_4" style="text-align:center">Status</div>
            <br />
            <hr />
            <p>
                <asp:Label runat="server" ID="InOrderStatus"></asp:Label></p>
            <p>
                <asp:Label runat="server" ID="DoneInOrderStatus"></asp:Label></p>
            <ul class="in-order-ul">
                <%--<li>&nbsp;</li>--%>
                <asp:Repeater runat="server" ID="InOrders">
                    <ItemTemplate>
                        <li>
                            <div class="grid_5">
                                <asp:Label ID="Label1" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "NAME")%>' />
                                <asp:Label ID="Label4" runat="server" Text="From" />
                                <asp:Label ID="Label5" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "USERNAME")%>' />
                            </div>
                            <div class="grid_3">
                                <asp:Label ID="Label6" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "DATE")%>' />
                            </div>
                            <div class="grid_4">
                                <asp:Label ID="InStatus" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "STATUS")%>' CssClass="in-status" />
                                <div class="buttons-div">
                                    <asp:LinkButton ID="CompleteBtn" runat="server" Text="Complete" CssClass="complete-btn"
                                        CommandArgument='<%# DataBinder.Eval(Container.DataItem, "ID")%>' OnClick="CompleteBtn_Click" />
                                    <asp:LinkButton ID="DeclineBtn" runat="server" Text="Decline" CssClass="decline-btn"
                                        CommandArgument='<%# DataBinder.Eval(Container.DataItem, "ID")%>' OnClick="DeclineBtn_Click" />
                                </div>
                            </div>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:Repeater runat="server" ID="DoneInOrders">
                    <ItemTemplate>
                        <li>
                            <div class="grid_5">
                                <asp:Label ID="Label1" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "NAME")%>' />
                                <asp:Label ID="Label4" runat="server" Text="From" />
                                <asp:Label ID="Label5" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "USERNAME")%>' />
                            </div>
                            <div class="grid_3">
                                <asp:Label ID="Label6" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "DATE")%>' />
                            </div>
                            <div class="grid_4">
                                <asp:Label ID="InStatus" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "STATUS")%>' />
                            </div>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
            <p>
                <asp:Label runat="server" ID="InButtonStatus"></asp:Label></p>
        </div>
    </div>
</asp:Content>
