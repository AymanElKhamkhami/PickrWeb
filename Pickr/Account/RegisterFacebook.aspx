<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegisterFacebook.aspx.cs" Inherits="Pickr.Account.RegisterFacebook" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <h2><%: Title %></h2>
    <p class="text-danger">
        <asp:Literal runat="server" ID="ErrorMessage" />
    </p>

    <div class="form-horizontal">

        <h4>Register as <b><asp:Label runat="server" ID="ExternalUsername" ></asp:Label></b> with an external account</h4>
        <hr />
        <div class="form-group" >
            <asp:Label runat="server" ID="BirthLabel" AssociatedControlID="BirthFacebook" CssClass="col-md-2 control-label">Birth Date</asp:Label>
            <div class="col-md-10">
                <asp:TextBox runat="server" ID="BirthFacebook" CssClass="form-control" TextMode="Date" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="BirthFacebook"
                    CssClass="text-danger" ErrorMessage="The birth date is required." ID="BirthValidator"/>
            </div>
        </div>
        <div class="form-group">
            <asp:Label runat="server" AssociatedControlID="Address" CssClass="col-md-2 control-label">Address</asp:Label>
            <div class="col-md-10">
                <asp:DropDownList runat="server" ID="Address" CssClass="form-control" >
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
                <asp:Button runat="server" OnClick="Register_Click" Text="Register" CssClass="btn btn-default" />
            </div>
        </div>
    </div>
</asp:Content>