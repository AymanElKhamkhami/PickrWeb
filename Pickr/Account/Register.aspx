<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Pickr.Account.Register" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <h2><%: Title %></h2>
    <p class="text-danger">
        <asp:Literal runat="server" ID="ErrorMessage" />
    </p>

    <div class="form-horizontal">
        <h4>Create a new account</h4>
        <hr />
        <asp:ValidationSummary runat="server" CssClass="text-danger" />
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="Email" CssClass="col-md-2 control-label">Email</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="Email" CssClass="form-control" TextMode="Email" Width="40%"/>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Email"
                    CssClass="text-danger" ErrorMessage="The email field is required." />
            </div>
        </div>
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="Username" CssClass="col-md-2 control-label" >Username</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="Username" CssClass="form-control" Width="40%"/>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Username"
                    CssClass="text-danger" ErrorMessage="The username field is required." />
            </div>
        </div>
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="Password" CssClass="col-md-2 control-label" >Password</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="Password" TextMode="Password" CssClass="form-control" Width="40%"/>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Password"
                    CssClass="text-danger" ErrorMessage="The password field is required." />
            </div>
        </div>
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="ConfirmPassword" CssClass="col-md-2 control-label" >Confirm password</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="ConfirmPassword" TextMode="Password" CssClass="form-control" Width="40%"/>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="ConfirmPassword"
                    CssClass="text-danger"  ErrorMessage="The confirm password field is required." />
                <asp:CompareValidator runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword"
                    CssClass="text-danger" Display="Dynamic" ErrorMessage="The password and confirmation password do not match." />
            </div>
        </div>
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="FirstName" CssClass="col-md-2 control-label" >First Name</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="FirstName" CssClass="form-control" Width="40%"/>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="FirstName"
                    CssClass="text-danger" ErrorMessage="The first name field is required." />
            </div>
        </div>
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="Surname" CssClass="col-md-2 control-label" >Surname</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="Surname" CssClass="form-control" Width="40%"/>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Surname"
                    CssClass="text-danger" ErrorMessage="The surname field is required." />
            </div>
        </div>
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="Birth" CssClass="col-md-2 control-label">Birth Date</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="Birth" CssClass="form-control" TextMode="Date" Width="29%" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Birth"
                    CssClass="text-danger" ErrorMessage="The birth date is required." />
            </div>
        </div>
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="Gender" CssClass="col-md-2 control-label" >Gender</asp:Label>
            <div class="col-md-10">
                <asp:DropDownList runat="server" ID="Gender" CssClass="form-control" Width="29%">
                    <asp:ListItem Text="Male" Value="m"></asp:ListItem>
                    <asp:ListItem Text="Female" Value="f"></asp:ListItem>
                    <asp:ListItem Text="Not specified" Value="n"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Gender"
                    CssClass="text-danger" ErrorMessage="The gender field is required." />
            </div>
        </div>
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="Mobile" CssClass="col-md-2 control-label">Mobile</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="Mobile" CssClass="form-control" TextMode="Phone"  Width="40%"/>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Gender" 
                    CssClass="text-danger" ErrorMessage="..." style="opacity:0"/>
            </div>
        </div>
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="Address" CssClass="col-md-2 control-label">Address</asp:Label>
            <div class="col-md-10">
                <asp:DropDownList runat="server" ID="Address" CssClass="form-control"  Width="29%">
                    <asp:ListItem Text="Śródmieście, Łódź" Value="Śródmieście, Łódź"></asp:ListItem>
                    <asp:ListItem Text="Widzew, Łódź" Value="Widzew, Łódź"></asp:ListItem>
                    <asp:ListItem Text="Polesie, Łódź" Value="Polesie, Łódź"></asp:ListItem>
                    <asp:ListItem Text="Bałuty, Łódź" Value="Bałuty, Łódź"></asp:ListItem>
                    <asp:ListItem Text="Górna, Łódź" Value="Górna, Łódź"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Address"
                    CssClass="text-danger" ErrorMessage="The address field is required." />
            </div>
        </div>
        <div class="form-group">
            <div class="col-md-offset-2 col-md-10">
                <asp:Button runat="server" OnClick="CreateUser_Click" Text="Register" CssClass="btn btn-default" />
            </div>
        </div>
    </div>
</asp:Content>
