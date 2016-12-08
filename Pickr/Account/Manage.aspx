<%@ Page Title="Manage Account" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Manage.aspx.cs" Inherits="Pickr.Account.Manage" %>

<%@ Register Src="~/Account/OpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

     <style>

        
        .successNotification {
            position: absolute;
            z-index: 99;
            /*border-bottom-left-radius: 0px;
            border-top-left-radius: 0px;*/
            /*background-color: rgba(52, 152, 219, 0.9);*/
            color: white;
            box-shadow: 0 3px 9px rgba(0, 0, 0, 0.5);
            width: 600px;
            padding: 10px;
            visibility: visible;
            /*-webkit-animation: fadein 10s;*/ /* Safari, Chrome and Opera > 12.1 */
            /*-moz-animation: fadein 10s;*/ /* Firefox < 16 */
            /*-ms-animation: fadein 10s;*/ /* Internet Explorer */
            /*-o-animation: fadein 10s;*/ /* Opera < 12.1 */
            /*animation: fadein 10s;*/
        }

    </style>


    <script>

        $(document).ready(function () {

            $('#notif').hide();

            if (getUrlParameter('updated') == 'true') {
                $('#notif').fadeIn(500);
                //$('#notifIcon').attr('src', 'http://pickr.somee.com/Images/Success.png');
                $('#notifIcon').attr('src', 'http://localhost:8081/Images/Success.png');
                $('#notif').delay(10000).fadeOut(500);
            }

            
        });

        var getUrlParameter = function getUrlParameter(sParam) {
            var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                sURLVariables = sPageURL.split('&'),
                sParameterName,
                i;

            for (i = 0; i < sURLVariables.length; i++) {
                sParameterName = sURLVariables[i].split('=');

                if (sParameterName[0] === sParam) {
                    return sParameterName[1] === undefined ? true : sParameterName[1];
                }
            }
        };

    </script>

    <div class="alert alert-dismissible alert-success successNotification" id="notif">
        <%--<script type="text/javascript">$('#notif').hide();</script>--%>
        <button type="button" class="cls">&times;</button>
        <img id="notifIcon" class="img-responsive" height="50" width="50" alt="User" style="display: inline-block; margin: 0px; margin-right: 15px;" src="" />
        <asp:Label runat="server" ID="notifText"><b>Success - </b> Your profile data was successfully updated.</asp:Label>
    </div>
    <asp:HiddenField runat="server" ID="isUpdateMade" />

    <h2><%: Title %></h2>
    <p class="text-danger">
        <asp:Literal runat="server" ID="ErrorMessage" />
    </p>

    <div class="form-horizontal">
        <h4>Manage your account details</h4>
        <hr />
        <asp:ValidationSummary runat="server" CssClass="text-danger" />
        <asp:Panel runat="server">
            <div class="form-group">
                <asp:Label runat="server" AssociatedControlID="FirstName" CssClass="col-md-2 control-label">First Name</asp:Label>
                <div class="col-md-10">
                    <asp:TextBox runat="server" ID="FirstName" CssClass="form-control" Width="40%" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="FirstName" Display="Dynamic"
                        CssClass="text-danger" ErrorMessage="The first name field cannot be empty." />
                </div>
            </div>
            <div class="form-group">
                <asp:Label runat="server" AssociatedControlID="Surname" CssClass="col-md-2 control-label">Surname</asp:Label>
                <div class="col-md-10">
                    <asp:TextBox runat="server" ID="Surname" CssClass="form-control" Width="40%" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Surname" Display="Dynamic"
                        CssClass="text-danger" ErrorMessage="The surname field cannot be empty." />
                </div>
            </div>

            <div class="form-group">
                <asp:Label runat="server" AssociatedControlID="Birth" CssClass="col-md-2 control-label">Birth Date</asp:Label>
                <div class="col-md-10">
                    <asp:TextBox runat="server" ID="Birth" CssClass="form-control" TextMode="Date" Width="29%" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Birth" Display="Dynamic"
                        CssClass="text-danger" ErrorMessage="The birth date is required." />
                </div>
            </div>
            <div class="form-group">
                <asp:Label runat="server" AssociatedControlID="Gender" CssClass="col-md-2 control-label">Gender</asp:Label>
                <div class="col-md-10">
                    <asp:DropDownList runat="server" ID="Gender" CssClass="form-control" Width="29%">
                        <asp:ListItem Text="Male" Value="m"></asp:ListItem>
                        <asp:ListItem Text="Female" Value="f"></asp:ListItem>
                        <asp:ListItem Text="Not specified" Value="n"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Gender" Display="Dynamic"
                        CssClass="text-danger" ErrorMessage="The gender field is required." />
                </div>
            </div>
            <div class="form-group">
                <asp:Label runat="server" AssociatedControlID="Mobile" CssClass="col-md-2 control-label">Mobile</asp:Label>
                <div class="col-md-10">
                    <asp:TextBox runat="server" ID="Mobile" CssClass="form-control" TextMode="Phone" Width="40%" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Mobile" Enabled="false" Display="Dynamic"
                        CssClass="text-danger" ErrorMessage="The first name field cannot be empty." />
                </div>
            </div>
            <div class="form-group">
                <asp:Label runat="server" AssociatedControlID="Address" CssClass="col-md-2 control-label">Address</asp:Label>
                <div class="col-md-10">
                    <asp:DropDownList runat="server" ID="Address" CssClass="form-control" Width="29%">
                        <asp:ListItem Text="Śródmieście, Łódź" Value="Śródmieście, Łódź"></asp:ListItem>
                        <asp:ListItem Text="Widzew, Łódź" Value="Widzew, Łódź"></asp:ListItem>
                        <asp:ListItem Text="Polesie, Łódź" Value="Polesie, Łódź"></asp:ListItem>
                        <asp:ListItem Text="Bałuty, Łódź" Value="Bałuty, Łódź"></asp:ListItem>
                        <asp:ListItem Text="Górna, Łódź" Value="Górna, Łódź"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Address" Display="Dynamic"
                        CssClass="text-danger" ErrorMessage="The address field is required." />
                </div>
            </div>
        </asp:Panel>
        <asp:Panel runat="server" ID="DriverFields">
            <div class="form-group">
                <asp:Label runat="server" AssociatedControlID="Car" ID="CarLabel" CssClass="col-md-2 control-label">Car Model</asp:Label>
                <div class="col-md-10">
                    <asp:TextBox runat="server" ID="Car" CssClass="form-control" Width="40%" />
                </div>
            </div>
            <div class="form-group form-group-lg">
                <h4 class="col-md-2 control-label">Preferences </h4>
            </div>
            </br>

            <div class="form-group">
                <asp:Label runat="server" AssociatedControlID="Smoking" CssClass="col-md-2 control-label">Smoking</asp:Label>
                <div class="col-md-10">
                    <asp:DropDownList runat="server" ID="Smoking" CssClass="form-control" Width="29%">
                        <asp:ListItem Text="Yes" Value="True"></asp:ListItem>
                        <asp:ListItem Text="No" Value="False"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="form-group">
                <asp:Label runat="server" AssociatedControlID="Music" CssClass="col-md-2 control-label">Music</asp:Label>
                <div class="col-md-10">
                    <asp:DropDownList runat="server" ID="Music" CssClass="form-control" Width="29%">
                        <asp:ListItem Text="Yes" Value="True"></asp:ListItem>
                        <asp:ListItem Text="No" Value="False"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="form-group">
                <asp:Label runat="server" AssociatedControlID="Pets" CssClass="col-md-2 control-label">Pets</asp:Label>
                <div class="col-md-10">
                    <asp:DropDownList runat="server" ID="Pets" CssClass="form-control" Width="29%">
                        <asp:ListItem Text="Yes" Value="True"></asp:ListItem>
                        <asp:ListItem Text="No" Value="False"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="form-group">
                <asp:Label runat="server" AssociatedControlID="Talking" CssClass="col-md-2 control-label">Talking</asp:Label>
                <div class="col-md-10">
                    <asp:DropDownList runat="server" ID="Talking" CssClass="form-control" Width="29%">
                        <asp:ListItem Text="Rarely" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Average" Value="2"></asp:ListItem>
                        <asp:ListItem Text="Chatty" Value="3"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
        </asp:Panel>
        </br>
        <div class="form-group">
            <div class="col-md-offset-2 col-md-10">
                <asp:Button runat="server" ID="Update" OnClick="SaveUpdates_Click" Text="Save" CssClass="btn btn-primary" UseSubmitBehavior="false" />
            </div>
        </div>
    </div>


    

</asp:Content>
