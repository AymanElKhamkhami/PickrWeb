<%@ Page Title="My Offers" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OffersList.aspx.cs" Inherits="Pickr.OffersList" %>

<%@ Register Src="~/Account/OpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>
<%@ Import Namespace="Pickr.Classes" %>



<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <style>
        .iconbutton {
            color: #E74C3C; 
            cursor: pointer; 
            cursor: hand; 
            font-size:x-large;
            text-decoration:none;
        }

        .warning .iconbutton {
            color: #E74C3C !important; 
            cursor: pointer !important; 
            cursor: hand !important; 
            font-size:x-large !important;
            text-decoration:none !important;
        }

        .iconbutton:hover {
            color:#D62C1A;
            text-decoration:none;
        }

        .warning .iconbutton:hover {
            color:#D62C1A !important;
            text-decoration:none !important;
        }

        .disablediconbutton {
            color: #EF8B80; 
            cursor: default; 
            font-size:x-large;
            text-decoration:none;
        }

        .warning .disablediconbutton {
            color: #EF8B80 !important; 
            cursor: default !important;
            font-size:x-large !important;
            text-decoration:none !important;
        }


        .modal {
            text-align: center;
            padding: 0 !important;
        }

            .modal:before {
                content: '';
                display: inline-block;
                height: 100%;
                vertical-align: middle;
                margin-right: -4px;
            }

        .modal-dialog {
            display: inline-block;
            text-align: left;
            vertical-align: middle;
        }

    </style>
    
    <h2>My Schedule</h2>
    <p class="text-danger">
        <asp:Literal runat="server" ID="ErrorMessage" />
    </p>

<%--    <asp:LinkButton runat="server" class="fa fa-trash fa-2x iconbutton"></asp:LinkButton>
    <i class="fa fa-trash fa-2x iconbutton"></i>--%>

    <asp:Table runat="server" ID="offersList" CssClass="table table-striped table-hover ">
    </asp:Table>

</asp:Content>
