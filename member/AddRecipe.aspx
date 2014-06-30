<%@ Page Language="C#" MasterPageFile="~/project/member/MasterPage.master" EnableEventValidation="false" ValidateRequest="false" %>


<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Web.Services" %>
<%@ Import Namespace="edu.neu.ccis.rasala" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Xml.Linq" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <title>Add/Edit Recipe</title>
    <link rel="stylesheet" type="text/css" href="../css/addRecipe.css" />
    <link rel="stylesheet" href="../css/BrowseRecipes.css" type="text/css" />



    <script>
        $(document).ready(function () {
            $(".clear-all-fields").click(function () {
                $(".hashtags-sel").removeClass("hashtags-sel");
            });

            $(".ingredientslist").sortable({
                //update: function (event, ui) {
                //    if ($("#SaveIngredientsBtn").hasClass("save-ingredient-order-hidden")) {
                //        $("#SaveIngredientsBtn").removeClass("save-ingredient-order-hidden");
                //    }

                //}
            });


            //To show the delete cross on hover
            $(".ingredientslist li").mouseenter(function () {
                $("label", this).removeClass("hidden");
            });
            $(".ingredientslist li").mouseleave(function () {
                $("label", this).addClass("hidden");
            });

            $(".procedureslist").sortable({
                //update: function (event, ui) {
                //    if ($("#SaveProceduresBtn").hasClass("save-procedure-order-hidden")) {
                //        $("#SaveProceduresBtn").removeClass("save-procedure-order-hidden");
                //    }

                //}
            });

            //To show the delete cross on hover
            $(".procedureslist li").mouseenter(function () {
                $("label", this).removeClass("hidden");
            });
            $(".procedureslist li").mouseleave(function () {
                $("label", this).addClass("hidden");
            });

            // To delete the list item on click
            //$('.delete-ingredients').click(function () {
            //    $(this).closest('li').remove();
            //    if ($("#SaveIngredientsBtn").hasClass("save-ingredient-order-hidden")) {
            //        $("#SaveIngredientsBtn").removeClass("save-ingredient-order-hidden");
            //    }
            //});

            //$('.delete-procedures').click(function () {
            //    $(this).closest('li').remove();
            //    if ($("#SaveProceduresBtn").hasClass("save-procedure-order-hidden")) {
            //        $("#SaveProceduresBtn").removeClass("save-procedure-order-hidden");
            //    }
            //});

            $("#SaveIngredientsBtn").click(function () {
                var text = [];
                $(".ingredientslist li span").each(function (index) {
                    text.push($(this).text());
                });

                $.ajax({
                    url: 'AddRecipe.aspx/SaveIngredients',
                    type: "POST",
                    data: "{'ingredients': '" + JSON.stringify(text) + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        alert(data.d);

                        $("#SaveIngredientsBtn").addClass("save-ingredient-order-hidden");
                    },
                    error: function (err) {
                        alert("Error in saving");
                    }

                });
            });

            //$(".add-ingredients").click(function () {
            //   // alert($(".ingredient-box").val());
            //    $.ajax({
            //        url: 'Copy%20of%20AddRecipe.aspx/AddIngredientAjax',
            //        type: "POST",
            //        data: "{'ingredients': " + JSON.stringify($(".ingredient-box").val()) + "}",
            //        contentType: "application/json; charset=utf-8",
            //        dataType: "json",
            //        success: function (data) {
            //            $(".ingredient-box").val("");
            //           // $(".ingredientslist").append('<li><span>' + data.d + '</span><label class="delete-ingredients"><img src="images/remove.png" width="20" height="20"></label></li>');
            //            //$("#SaveProceduresBtn").addClass("save-procedure-order-hidden");
            //        },
            //        error: function (err) {
            //            alert("Error in saving");
            //        }

            //    });

            //});

            $("#SaveProceduresBtn").click(function () {
                var text = [];
                $(".procedureslist li span").each(function (index) {
                    text.push($(this).text());
                });

                $.ajax({
                    url: 'AddRecipe.aspx/SaveProcedures',
                    type: "POST",
                    data: "{'procedures': '" + JSON.stringify(text) + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        alert(data.d);
                        $("#SaveProceduresBtn").addClass("save-procedure-order-hidden");
                    },
                    error: function (err) {
                        alert("Error in saving");
                    }

                });
            });
        });
    </script>
    <script runat="server">
    
        public static string filename;
        public static string ingredientsFileName;
        public static string proceduresFileName;
        public static string imageFileName;
        protected static string loggedInUser;
        protected static string connectionString = ConfigurationManager.ConnectionStrings["swapnilhCS"].ConnectionString;
        protected static ArrayList allIngredientsList;
        protected static ArrayList allProceduresList;
        protected static string defaultImageURL = "http://placehold.it/300&text=Upload+Image+Here";
        protected static Boolean isValidImageUrl;

        protected void Page_Load(object sender, EventArgs e)
        {
           Bind_Current_Ingredients_And_Procedures();
             SavingStatus.Text ="";
            hashtagsStatus.Text = "";
            if (!IsPostBack)
            {
                allIngredientsList = new ArrayList();
                allProceduresList = new ArrayList();
                loggedInUser = User.Identity.Name;
                isValidImageUrl = true;
                string[] parts = RequestTools.QueryParts(Request);
                uploadedImage.ImageUrl = "http://placehold.it/300&text=Upload+Image+Here";

                try 
	            {	        
		            SqlDataSource hashdata = new SqlDataSource();
                    hashdata.ConnectionString = connectionString;
                    hashdata.SelectCommand = "SELECT ID, VALUE FROM swapnilh.Hashtags";
                    hashtags.DataSource = hashdata;
                    hashtags.DataBind();
                    //hashtagsStatus.Text = "";
	            }
	            catch (Exception)
	            {
		            hashtagsStatus.Text = "Error Loading Hashtags";
	            }
                
                int n = parts.Length;

                if (n == 1)
                {
                    //There are query parameters so create an edit page
                    // Check if recipe exists with current logged in user
                    string recipeName = Check_Recipe_And_User(parts[0]);
                    if(!recipeName.Equals(""))
                    {
                        Set_All_File_Paths(parts[0]);
                        
                        RecipeNameBox.Value = recipeName;
                        //Load the ingredients
                        Load_Ingredients(ingredientsFileName);
                        
                        //Load Procedures
                        Load_Procedures(proceduresFileName);
                        
                        //if (File.Exists(MapPath(imageFileName)))
                        //{
                        //    uploadedImage.ImageUrl = imageFileName;
                             
                        //}
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
                                uploadedImage.ImageUrl = imageFileName;
                       
                            }
                        Load_Selected_Hashtags();
                    }
                    else
                    {
                        //Disable all controls
                        //Show error message
                        SavingStatus.Text = "You are not the owner of the recipe to change";
                    }
                }
                else if(n == 0)
                {
                    filename=null;
                    Bind_Current_Ingredients_And_Procedures();
                }
                else
                {
                    //Disable all controls
                    SavingStatus.Text = "Invalid Arguments";
                }
            }
        }

        protected void Bind_Current_Ingredients_And_Procedures()
        {
            ingredients.DataSource = allIngredientsList;
            ingredients.DataBind();

            Procedures.DataSource = allProceduresList;
            Procedures.DataBind();
        }
        protected void Set_All_File_Paths(string file)
        {
            filename = file;
            ingredientsFileName = "../Recipes/" + filename + "_ingredients.xml";
            proceduresFileName = "../Recipes/" + filename + "_procedures.xml";
            imageFileName = "../images/Recipes/" + filename + "_image.jpeg";
        }
        
        protected void Load_Ingredients(string file)
        {
            if (File.Exists(MapPath(file)))
            {
                XDocument ingredFile = XDocument.Load(MapPath(file));
                var allIngredients = from r in ingredFile.Descendants("Ingredient")
                                        select r.Element("Name").Value;
                allIngredientsList = new ArrayList();
                foreach (var r in allIngredients)
                {
                    allIngredientsList.Add(r.ToString());
                }
                ingredients.DataSource = allIngredientsList;
                ingredients.DataBind();
            }
        }
        
        protected void Load_Procedures(string file)
        {
            if (File.Exists(MapPath(file)))
            {
                XDocument procFile = XDocument.Load(MapPath(file));
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
        }
        
        protected void Load_Selected_Hashtags()
        {
            ArrayList hashes = new ArrayList();
            try 
	        {	        
		        using (var conn = new SqlConnection(connectionString))
                using (var cmd = conn.CreateCommand())
                {
                    conn.Open();
                    cmd.CommandText = "SELECT H.VALUE AS HASH FROM swapnilh.HASHTAGS H, swapnilh.RECIPE_HASHTAGS RH WHERE RH.RECIPE_ID=@RECIPEID AND RH.HASHTAGS_ID = H.ID";
                    cmd.Parameters.AddWithValue("@RECIPEID", filename);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            hashes.Add(reader["HASH"].ToString());
                        }
                    }
                }
                        
                foreach(RepeaterItem item in hashtags.Items)
                {
                    LinkButton button = (LinkButton)item.FindControl("hashtag");
                    if(hashes.Contains(button.Text))
                    {
                        button.CssClass = "grid_4 hashtags-sel";
                    }
                }
                hashtagsStatus.Text = "";
	        }
	        catch (Exception)
	        {
		        hashtagsStatus.Text="Error Loading Saved Hashtags For This Recipe";
	        }
        }
        
        [WebMethod()]
        public static string SaveIngredients(string ingredients)
        {
            /*You can do database operations here if required*/

            System.Web.Script.Serialization.JavaScriptSerializer js = new System.Web.Script.Serialization.JavaScriptSerializer();
            string[] array = js.Deserialize<string[]>(ingredients);
            allIngredientsList = new ArrayList(array);
            return "Arrangement Saved!";
        }


        [WebMethod()]
        public static string SaveProcedures(string procedures)
        {
            /*You can do database operations here if required*/

            System.Web.Script.Serialization.JavaScriptSerializer js = new System.Web.Script.Serialization.JavaScriptSerializer();
            string[] array = js.Deserialize<string[]>(procedures);
            allProceduresList = new ArrayList(array);
            return "Arrangement Saved!";
        }

        


        protected void AddProcedureBtn_Click(object sender, EventArgs e)
        {
            if (Procedure != null && !Procedure.Text.Trim().Equals(""))
            {
                allProceduresList.Add(Server.HtmlEncode(Procedure.Text.Trim()));
            }
            Procedures.DataSource = allProceduresList;
            Procedures.DataBind();
            Procedure.Text = "";
           // SavingStatus.Text = "";
        }
          
    </script>
    <script runat="server">    
        protected void AddIngredientBtn_Click(object sender, EventArgs e)
        {
            if (Ingredient != null && !Ingredient.Text.Trim().Equals(""))
            {
                allIngredientsList.Add(Server.HtmlEncode(Ingredient.Text.Trim()));
            }

            ingredients.DataSource = allIngredientsList;
            ingredients.DataBind();
            Ingredient.Text = "";
           // SavingStatus.Text = "";
        }

        protected void SaveRecipeBtn_Click(object sender, EventArgs e)
        {
            if (RecipeNameBox.Value.Trim().Equals(""))
            {
                SavingStatus.Text = "Enter Recipe Name";
                return;
            }
            if (allIngredientsList.Count==0)
            {
                SavingStatus.Text = "Enter Ingredients for the recipe";
                return;
            }
            if (allProceduresList.Count==0)
            {
                SavingStatus.Text = "Enter Procedure for the recipe";
                return;
            }
            if(!isValidImageUrl && !(FileUploadControl.HasFile && isValidImageInUploader()))
            {
                SavingStatus.Text = "Invalid Images provided";
                return;
            }
            Save_Recipe_Db();
            
        }
        
        protected string Check_Recipe_And_User(string recipeid)
        {
            //string sqlIns = "SELECT CASE WHEN EXISTS "+
            //                " (SELECT * "+
            //                " FROM swapnilh.RECIPE "+
            //                " WHERE USERNAME = @username AND ID = @recipeid) "+
            //                " THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS Status";
            string sqlIns = "SELECT NAME FROM swapnilh.RECIPE WHERE (USERNAME = @username) AND (ID = @recipeid)";
            SqlConnection conn = new SqlConnection(connectionString);
            conn.Open();
            try
            {
                SqlCommand cmdIns = conn.CreateCommand();
                cmdIns.CommandText = sqlIns;
                cmdIns.Parameters.AddWithValue("@username", loggedInUser);
                cmdIns.Parameters.AddWithValue("@recipeid", recipeid);
                string Name = Convert.ToString( cmdIns.ExecuteScalar() );
                //Boolean isValidRecipe = Convert.ToBoolean( cmdIns.ExecuteScalar() );
                cmdIns.Dispose();
                cmdIns = null;
                return Name;
            }
            catch(Exception ex)
            {
                SavingStatus.Text = "Error Fetching Recipe! "+ex.ToString();
                return "";
            }
            finally
            {
                conn.Close();
            }
        }
        
        protected void Save_Recipe_Db()
        {
            if(filename == null )
            {
                //New Recipe
                //Check if both image url box and image uploader has contents
                if(isValidImageUrl && FileUploadControl.HasFile)
                {
                    SavingStatus.Text = "Both Image Url text box and Image Upload had contents, removed image upload contents.";
                    return;
                }
                else
                {
                    string sqlIns = "INSERT INTO swapnilh.RECIPE (NAME, USERNAME, DATE) VALUES (@name, @username, @date)";
                    SqlConnection conn = new SqlConnection(connectionString);
                    conn.Open();
                    try
                    {
                        SqlCommand cmdIns = conn.CreateCommand();
                        cmdIns.CommandText = sqlIns;
                        cmdIns.Parameters.AddWithValue("@name", Server.HtmlEncode(RecipeNameBox.Value.Trim()));
                        cmdIns.Parameters.AddWithValue("@username", loggedInUser);
                        cmdIns.Parameters.AddWithValue("@date", DateTime.Now);
                        cmdIns.ExecuteNonQuery();
                        cmdIns.Parameters.Clear();
                        cmdIns.CommandText = "SELECT @@IDENTITY";
 
                        // Get the last inserted id.
                        int insertID = Convert.ToInt32( cmdIns.ExecuteScalar() );
 
                        cmdIns.Dispose();
                        cmdIns = null;
                
                        filename = insertID.ToString();
                        ingredientsFileName = "../Recipes/" + filename + "_ingredients.xml";
                        proceduresFileName = "../Recipes/" + filename + "_procedures.xml";
                        imageFileName = "../images/Recipes/" + filename + "_image.jpeg";
                
                        Save_Ingredients_XML();
                        Save_Procedures_XML();
                        Save_Hash_Tags();
                        if(FileUploadControl.HasFile)
                        {
                            imageFileName = "../images/Recipes/" + filename + "_image.jpeg";
                            UploadImage();
                        }
                        else
                        {
                            imageFileName = ImageUrlBox.Text.Trim();
                        }
                        if(imageFileName==null || imageFileName.Equals(""))
                        {
                            uploadedImage.ImageUrl=defaultImageURL;
                        }
                        else
                        {
                            uploadedImage.ImageUrl = imageFileName;
                        }
                        sqlIns = "UPDATE swapnilh.RECIPE SET IMAGE = @image WHERE ID = @recipeid";
                        conn = new SqlConnection(connectionString);
                        conn.Open();
                        try
                        {
                            cmdIns = conn.CreateCommand();
                            //new SqlCommand(sqlIns, conn.Connection);
                            cmdIns.CommandText = sqlIns;
                            cmdIns.Parameters.AddWithValue("@recipeid", filename);
                            cmdIns.Parameters.AddWithValue("@image", imageFileName);
                            cmdIns.ExecuteNonQuery();
                    
                        }
                        catch (Exception ex)
                        {
                            //OrderStatus.Text = "Error Placing Order! " + ex.ToString();
                        }
                        finally
                        {
                            conn.Close();
                        }
                        SavingStatus.Text = "Recipe Saved!";
                        Response.Redirect("../ViewRecipe.aspx?"+filename);
                    }
                    catch(Exception ex)
                    {
                        SavingStatus.Text = "Error Saving Recipe! "+ex.ToString();
                    }
                    finally
                    {
                        conn.Close();
                    }
                }
            }
            else
            {
                //just edit the recipe
                //if file present at location delete it
                try 
	            {	        
		            if(File.Exists(MapPath(imageFileName)))
                            {
                                File.Delete(MapPath(imageFileName));
                            }
	            }
	            catch (Exception)
	            {
		
	            }
                
                if(FileUploadControl.HasFile)
                {
                    imageFileName = "../images/Recipes/" + filename + "_image.jpeg";
                    UploadImage();
                }
                else
                {
                    imageFileName = ImageUrlBox.Text.Trim();
                }
                string sqlIns = "UPDATE swapnilh.RECIPE SET NAME = @name, DATE = @date , IMAGE = @image WHERE ID = @recipeid";
                SqlConnection conn = new SqlConnection(connectionString);
                conn.Open();
                try
                {
                    SqlCommand cmdIns = conn.CreateCommand();
                    //new SqlCommand(sqlIns, conn.Connection);
                    cmdIns.CommandText = sqlIns;
                    cmdIns.Parameters.AddWithValue("@recipeid", filename);
                    cmdIns.Parameters.AddWithValue("@name", RecipeNameBox.Value.Trim());
                    cmdIns.Parameters.AddWithValue("@date", DateTime.Now);
                    cmdIns.Parameters.AddWithValue("@image", imageFileName);
                    cmdIns.ExecuteNonQuery();
                    
                    Save_Ingredients_XML();
                    Save_Procedures_XML();
                    Save_Hash_Tags();
                   // UploadImage();
                    SavingStatus.Text = "Recipe Saved!";
                    Response.Redirect("../ViewRecipe.aspx?"+filename);
                }
                catch (Exception ex)
                {
                    //OrderStatus.Text = "Error Placing Order! " + ex.ToString();
                }
                finally
                {
                    conn.Close();
                }
            }
            
        }

        protected void Save_Ingredients_XML()
        {
            string fileName = MapPath(ingredientsFileName);
            //<%--Setup XMLWriterSettings to be used to write the XML file--%>
            XmlWriterSettings settings = new XmlWriterSettings();
            settings.Indent = true;
            settings.ConformanceLevel = ConformanceLevel.Auto;
            settings.OmitXmlDeclaration = false;
            //<%--Write to XML using the XMLWriterSettings--%>
            using (XmlWriter writer = XmlWriter.Create(fileName, settings))
            {
                //<%--Starts the XML with encoding declaration--%>
                writer.WriteStartDocument(false);
                //<%--Adds comments to the XML--%>
                writer.WriteComment("This is a comment.");
                //<%--Root node of the XML--%>
                writer.WriteStartElement("Ingredients");

                //<%--End root node--%>
                writer.WriteEndElement();
                writer.Flush();

            }
            XDocument doc = XDocument.Load(fileName);
            foreach (string ingred in allIngredientsList)
            {
                XElement root = new XElement("Ingredient");
                root.Add(new XElement("Name", ingred));
                doc.Element("Ingredients").Add(root);
            }
            doc.Save(fileName);
        }

        protected void Save_Procedures_XML()
        {
            string fileName = MapPath(proceduresFileName);
            //<%--Setup XMLWriterSettings to be used to write the XML file--%>
            XmlWriterSettings settings = new XmlWriterSettings();
            settings.Indent = true;
            settings.ConformanceLevel = ConformanceLevel.Auto;
            settings.OmitXmlDeclaration = false;
            //<%--Write to XML using the XMLWriterSettings--%>
            using (XmlWriter writer = XmlWriter.Create(fileName, settings))
            {
                //<%--Starts the XML with encoding declaration--%>
                writer.WriteStartDocument(false);
                //<%--Adds comments to the XML--%>
                writer.WriteComment("This is a comment.");
                //<%--Root node of the XML--%>
                writer.WriteStartElement("Procedures");

                //<%--End root node--%>
                writer.WriteEndElement();
                writer.Flush();

            }
            XDocument doc = XDocument.Load(fileName);
            foreach (string proc in allProceduresList)
            {
                XElement root = new XElement("Procedure");
                root.Add(new XElement("Name", proc));
                doc.Element("Procedures").Add(root);
            }
            doc.Save(fileName);
        }
        
        protected void Save_Hash_Tags()
        {
            foreach(RepeaterItem item in hashtags.Items)
            {
                LinkButton hash = (LinkButton)item.FindControl("hashtag");
                if(hash.CssClass.Contains("hashtags-sel"))
                {
                    string sqlIns = "INSERT INTO swapnilh.RECIPE_HASHTAGS (RECIPE_ID, HASHTAGS_ID) VALUES (@recipeid, @hashid)";
                    SqlConnection conn = new SqlConnection(connectionString);
                    conn.Open();
                    try
                    {
                        SqlCommand cmdIns = conn.CreateCommand();
                            //new SqlCommand(sqlIns, conn.Connection);
                        cmdIns.CommandText = sqlIns;
                        cmdIns.Parameters.AddWithValue("@recipeid", filename);
                        cmdIns.Parameters.AddWithValue("@hashid", hash.CommandArgument);
                        cmdIns.ExecuteNonQuery();
 
                        //cmdIns.Parameters.Clear();
                        //cmdIns.CommandText = "SELECT SCOPE_IDENTITY";
 
                        //// Get the last inserted id.
                        //int insertID = Convert.ToInt32( cmdIns.ExecuteScalar() );
 
                        cmdIns.Dispose();
                        cmdIns = null;
                
                        //filename = insertID.ToString();
                
                        
                    }
                    catch(Exception ex)
                    {
                        //throw new SqlException
                        SavingStatus.Text = "Error Saving Hashtags! "+ex.ToString();
                    }
                    finally
                    {
                        conn.Close();
                    }
                }
            }
        }
        
        protected void hashtags_itemCommand(object sender, RepeaterCommandEventArgs e)
        {
           LinkButton selectedButton = ((LinkButton)e.Item.FindControl("hashtag"));
            if (selectedButton.CssClass.Contains("hashtags-sel"))
            {
                selectedButton.CssClass = "grid_4 hashtags-unsel";
            }
            else
            {
                selectedButton.CssClass = "grid_4 hashtags-unsel hashtags-sel";
            }
            //selectedButton.Focus();
        }
        
        protected void EditRecipeBtn_Click(object sender, EventArgs e)
        {
            
        }

        protected void ClearAllBtn_Click(object sender, EventArgs e)
        {
            RecipeNameBox.Value = "";
            if (File.Exists(MapPath(imageFileName)))
            {
                File.Delete(MapPath(imageFileName));
                StatusLabel.Text = "";
                uploadedImage.CssClass = "hide";
                uploadedImage.ImageUrl = imageFileName;
            }

            allIngredientsList = new ArrayList();
            ingredients.DataSource = allIngredientsList;
            ingredients.DataBind();

            allProceduresList = new ArrayList();
            Procedures.DataSource = null;
            Procedures.DataBind();

            SavingStatus.Text = "";
        }

        protected void ClearIngredientsBtn_Click(object sender, EventArgs e)
        {
            allIngredientsList = new ArrayList();
            ingredients.DataSource = allIngredientsList;
            ingredients.DataBind();
        }

        protected void ClearProceduresBtn_Click(object sender, EventArgs e)
        {
            allProceduresList = new ArrayList();
            Procedures.DataSource = null;
            Procedures.DataBind();
        }

        protected void DeleteBtn_Click(object sender, EventArgs e)
        {
            string fileName = MapPath(imageFileName);
            if (File.Exists(fileName))
            {
                File.Delete(fileName);
                StatusLabel.Text = "Status: File Deleted.";
                //uploadedImage.CssClass = "hide";
                uploadedImage.ImageUrl = defaultImageURL;
            }
            ImageUrlBox.Text="";
            uploadedImage.ImageUrl = defaultImageURL;
        }

        protected void ingredients_itemcommand(object sender, RepeaterCommandEventArgs e)
        {
            int index = e.Item.ItemIndex;
            if (index < allIngredientsList.Count)
            {
                allIngredientsList.RemoveAt(index);
            }
            ingredients.DataSource = allIngredientsList;
            ingredients.DataBind();
        }

        protected void procedures_itemcommand(object sender, RepeaterCommandEventArgs e)
        {
            int index = e.Item.ItemIndex;
            if (index < allProceduresList.Count)
            {
                allProceduresList.RemoveAt(index);
            }
            Procedures.DataSource = allProceduresList;
            Procedures.DataBind();
        }
        
        protected void ImageUrlBox_TextChanged(object sender, EventArgs e)
        {
            if(!ImageUrlBox.Text.Trim().Equals(""))
            {
                try
                {
                    HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(ImageUrlBox.Text.Trim());
                
                    request.GetResponse();
                    //exists = true;
                    uploadedImage.ImageUrl = ImageUrlBox.Text;
                    ImageUrlStatus.Text = "";
                    isValidImageUrl = true;
                }
                catch
                {
                    ImageUrlStatus.Text = "Invalid URL or No Image at Location";
                    uploadedImage.ImageUrl = defaultImageURL;
                    isValidImageUrl = false;
                   //exists = false;
                }
            }
            else
            {
                isValidImageUrl = true;
                uploadedImage.ImageUrl = defaultImageURL;
            }
        }
        
        protected Boolean isValidImageInUploader()
        {
            if (FileUploadControl.HasFile)
            {
                if (FileUploadControl.PostedFile.ContentType == "image/jpeg"
                    || FileUploadControl.PostedFile.ContentType == "image/jpg"
                    ||FileUploadControl.PostedFile.ContentType == "image/gif"
                    ||FileUploadControl.PostedFile.ContentType == "image/png")
                    {
                    return true;
                }
            }
            return false;
        }
        
        protected void UploadImage()
        {
            try
            {
                if (isValidImageInUploader())
                {
                    string filename = Path.GetFileName(FileUploadControl.FileName);
                    FileUploadControl.SaveAs(Server.MapPath("~/project/" + imageFileName));
                    StatusLabel.Text = "Status: File uploaded!";
                    uploadedImage.CssClass = "unhide image-class";
                    uploadedImage.ImageUrl = imageFileName;
                }
                else
                {
                    StatusLabel.Text = "Status: Only JPEG files are accepted!";
                }
            }
            catch (Exception ex)
            {
                StatusLabel.Text = "Status: The file could not be uploaded. The following error occured: " + ex.Message;
            }
            
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="body" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <div class="container_12">
        <div class="grid_12 common-div">
            <input runat="server" id="RecipeNameBox" class="recipe-name-box" placeholder="Enter Recipe Name" />

        </div>

        <%--Add ingredients section start--%>
        <div class="grid_6 ingrdients-div">
            <div>
                <asp:TextBox runat="server" ID="Ingredient" CssClass="ingredient-box" />
                <asp:Button runat="server" ID="AddIngredientBtn" Text="Add Ingredients" CssClass="add-ingredients" OnClick="AddIngredientBtn_Click" />
            </div>
            <div class="ingredients-box">
                <ul id="IngredientsList" runat="server" class="ingredientslist">
                    <asp:Repeater runat="server" ID="ingredients" OnItemCommand="ingredients_itemcommand">
                        <ItemTemplate>
                            <li>
                                <asp:Label runat="server" ID="ingred" Text='<%# Container.DataItem %>'></asp:Label>
                                <asp:LinkButton runat="server" CssClass="delete-ingredients">
                                    <img src="../images/remove.png" width="20" height="20">
                                </asp:LinkButton>
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
            </div>
            <div>
                <p></p>
                <input type="button" value="Save Ingredients Order" id="SaveIngredientsBtn" class="save-ingredient-order " />
                <asp:Button runat="server" Text="Clear All Ingredients" ID="ClearIngredientsBtn" CssClass="clear-ingredients" OnClick="ClearIngredientsBtn_Click" />

            </div>

        </div>
        <%--Add ingredients section end--%>

        <%--Procedures section start--%>
        <div class="grid_6 procedures-div">
            <div>
                <asp:TextBox runat="server" ID="Procedure" CssClass="procedure-box" />
                <asp:Button runat="server" ID="AddProcedureBtn" OnClick="AddProcedureBtn_Click" Text="Add Procedure" CssClass="add-procedure" />
            </div>
            <div class=" ingredients-box">
                <ul id="ProceduresList" runat="server" class="procedureslist">
                    <asp:Repeater runat="server" ID="Procedures" OnItemCommand="procedures_itemcommand">
                        <ItemTemplate>
                            <li>
                                <asp:Label runat="server" ID="proced" Text='<%# Container.DataItem %>'></asp:Label>
                                <asp:LinkButton ID="LinkButton1" runat="server" CssClass="delete-procedures">
                                    <img src="../images/remove.png" width="20" height="20">
                                </asp:LinkButton>
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
            </div>

            <div>
                <p>
                    <input type="button" value="Save Procedures Order" id="SaveProceduresBtn" class="save-procedure-order" />
                    <asp:Button runat="server" Text="Clear All Procedures" ID="ClearProceduresBtn" CssClass="clear-procedures" OnClick="ClearProceduresBtn_Click" />
                </p>
            </div>
        </div>
        <%--Procedures end--%>

        <%--Image section start--%>
        <div class="grid_6 common-div">
            <asp:Label runat="server" Text="Enter the URL of Image" CssClass="grid_12"></asp:Label>
            <asp:TextBox runat="server" ID="ImageUrlBox" CssClass="grid_11 image-url-box" OnTextChanged="ImageUrlBox_TextChanged"
                AutoPostBack="true"></asp:TextBox>
            <asp:Label runat="server" ID="ImageUrlStatus" CssClass="grid_12" />
            <asp:Label runat="server" CssClass="grid_12" Text="Or, Alternatively Upload Image"></asp:Label>
            <asp:FileUpload ID="FileUploadControl" runat="server" />

            <br />
            <asp:Label runat="server" ID="StatusLabel" Text="Status: " /><br />
            <asp:Image CssClass="grid_12" runat="server" AlternateText="Uploaded Image" ToolTip="Uploaded Image" ID="uploadedImage" /><br />
            <%--<asp:Button runat="server" ID="UploadButton" Text="Upload" OnClick="UploadButton_Click" CssClass="upload-image" />--%>
            <asp:Button runat="server" ID="DeleteBtn" Text="Delete File" OnClick="DeleteBtn_Click" CssClass="delete-image" />
        </div>
        <%--Image section end--%>



        <%--Hash tags start--%>
        <div class="grid_6 hash-div">
            <p>Select the hash tags below that are related to the recipe</p>
            <p>
                <asp:Label runat="server" ID="hashtagsStatus"></asp:Label>
            </p>
            <asp:UpdatePanel ID="HashTagUpdater" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="hashtags" EventName="ItemCommand" />
                </Triggers>
                <ContentTemplate>
                    <asp:Repeater runat="server" ID="hashtags" OnItemCommand="hashtags_itemCommand">
                        <ItemTemplate>
                            <asp:LinkButton ID="hashtag" CssClass="grid_4 hashtags-unsel"
                                Text='<%# DataBinder.Eval(Container.DataItem, "VALUE")%>'
                                CommandArgument='<%# DataBinder.Eval(Container.DataItem, "ID")%>' runat="server" />

                        </ItemTemplate>
                    </asp:Repeater>
                </ContentTemplate>
            </asp:UpdatePanel>

        </div>
        <%--Hash tags end--%>

        <div class="grid_12 common-div">
            <asp:Button runat="server" Text="Save Recipe" ID="SaveRecipeBtn" CssClass="save-recipe" OnClick="SaveRecipeBtn_Click" />
            <asp:Button runat="server" Text="Edit Recipe" ID="EditRecipeBtn" CssClass="edit-recipe-disabled" OnClick="EditRecipeBtn_Click" />
            <asp:Label runat="server" ID="SavingStatus" CssClass="saving-status" Enabled="false"></asp:Label>
            <asp:Button runat="server" ID="ClearAllBtn" Text="Clear All Fields" CssClass="clear-all-fields" OnClick="ClearAllBtn_Click" />
        </div>

    </div>
</asp:Content>

