<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="Pickr.Account.Profile" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">


    <div class="row">
        <div class="col-lg-3 col-md-4 hide-sm">
            <div class="panel panel-default">
                <img runat="server" id="Picture" alt="Profile Picture" class="img-responsive" style="height:100%; width:100%; border-radius:5px;" title="" src="http://www.dmcsrestful.somee.com/images/profile/default-m.jpg">
            </div>

            <div class="panel panel-default">
                <div class="panel-heading">Personal info</div>
                <div class="panel-body">
                    <dl>
                        <ul class="list-unstyled ">
                            <li class="row row-condensed">
                                <div class="media">
                                    <i class="icon icon-ok icon-lima h3 pull-left"></i>
                                    <div class="media-body">
                                        <div class="text-muted">Full name</div>
                                        <div>
                                            <asp:Label runat="server" ID="FullName" CssClass="text-normal"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li class="row row-condensed">
                                <div class="media">
                                    <i class="icon icon-ok icon-lima h3 pull-left"></i>
                                    <div class="media-body">
                                        <div class="text-muted">Age</div>
                                        <div>
                                            <asp:Label runat="server" ID="Age" CssClass="text-normal"></asp:Label></div>
                                    </div>
                                </div>
                            </li>
                            <li class="row row-condensed">
                                <div class="media">
                                    <i class="icon icon-ok icon-lima h3 pull-left"></i>
                                    <div class="media-body">
                                        <div class="text-muted">User Mode</div>
                                        <div>
                                            <asp:Label runat="server" ID="Mode" CssClass="text-normal"></asp:Label></div>
                                    </div>
                                </div>
                            </li>
                        </ul>

                    </dl>
                </div>
            </div>

            <asp:Panel runat="server" ID="DrivingInfo">
                <div class="panel panel-default">
                    <div class="panel-heading">Driving info</div>
                    <div class="panel-body">
                        <dl>
                            <ul class="list-unstyled ">
                                <li class="row row-condensed">
                                    <div class="media">
                                        <i class="icon icon-ok icon-lima h3 pull-left"></i>
                                        <div class="media-body">
                                            <div class="text-muted">Rating</div>
                                            <div>
                                                <asp:Label runat="server" ID="Rating" CssClass="text-normal"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <li class="row row-condensed">
                                    <div class="media">
                                        <i class="icon icon-ok icon-lima h3 pull-left"></i>
                                        <div class="media-body">
                                            <div class="text-muted">
                                                <asp:Label runat="server" ID="CarLabel" CssClass="text-normal">Car model</asp:Label></div>
                                            <div>
                                                <asp:Label runat="server" ID="Car" CssClass="text-normal"></asp:Label></div>
                                        </div>
                                    </div>
                                </li>
                                <li class="row row-condensed">
                                    <div class="media">
                                        <i class="icon icon-ok icon-lima h3 pull-left"></i>
                                        <div class="media-body">
                                            <div class="text-muted">Preferences</div>
                                            <div>
                                                <asp:Label runat="server" CssClass="text-muted">Smoking: </asp:Label>
                                                <asp:Label runat="server" ID="Smoking" CssClass="text-normal"></asp:Label>
                                            </div>
                                            <div>
                                                <asp:Label runat="server" CssClass="text-muted">Music: </asp:Label>
                                                <asp:Label runat="server" ID="Music" CssClass="text-normal"></asp:Label></div>
                                            <div>
                                                <asp:Label runat="server" CssClass="text-muted">Pets: </asp:Label>
                                                <asp:Label runat="server" ID="Pets" CssClass="text-normal"></asp:Label></div>
                                            <div>
                                                <asp:Label runat="server" CssClass="text-muted">Talking: </asp:Label>
                                                <asp:Label runat="server" ID="Talking" CssClass="text-normal"></asp:Label></div>
                                        </div>
                                    </div>
                                </li>
                            </ul>

                        </dl>
                    </div>
                </div>
            </asp:Panel>
            <div class="panel panel-default">
                <div class="panel-heading">Contact info</div>
                <div class="panel-body">
                    <dl>
                        <ul class="list-unstyled ">
                            <li class="row row-condensed">
                                <div class="media">
                                    <i class="icon icon-ok icon-lima h3 pull-left"></i>
                                    <div class="media-body">
                                        <div class="text-muted">E-mail</div>
                                        <div>
                                            <asp:Label runat="server" ID="Email" CssClass="text-normal"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li class="row row-condensed">
                                <div class="media">
                                    <i class="icon icon-ok icon-lima h3 pull-left"></i>
                                    <div class="media-body">
                                        <div class="text-muted">Phone number</div>
                                        <div>
                                            <asp:Label runat="server" ID="Mobile" CssClass="text-normal"></asp:Label></div>
                                    </div>
                                </div>
                            </li>
                        </ul>

                    </dl>
                </div>
            </div>

        </div>

        <div class="col-lg-9 col-md-8 col-sm-12">
            <div class="row row-space-4">

                <div class="col-sm-8 col-md-12 col-lg-12">

                    <h1 runat="server" id="Head"></h1>
                    <div class="h5 row-space-top-2">
                        <a runat="server" id="Address" target="_blank" class="link-reset"></a>
                        ·<%--&bull;--%>
            <asp:Label runat="server" ID="MemberSince" CssClass="text-normal"></asp:Label>
                    </div>

                    <div runat="server" id="Edit" class="edit_profile_container row-space-3">
                        <a href="Manage"><i class="fa fa-pencil" aria-hidden="true"></i> Edit profile</a>
                    </div>
                </div>
            </div>
            <div class="row-space-top-2">
                <p></p>
            </div>

            <div data-hypernova-key="user_profile_badgesbundlejs">
                <div class="row-space-6 row-space-top-2" data-reactid=".xwkwpqc4jk" data-react-checksum="-1073353867">
                    <%--<div class="badge-container space-top-4" data-reactid=".xwkwpqc4jk.$Commentaire">
                        <a class="link-reset" rel="nofollow" href="/users/show/31924116#reviews" data-reactid=".xwkwpqc4jk.$Commentaire.0">
                            <div class="text-center text-wrap" data-reactid=".xwkwpqc4jk.$Commentaire.0.0">
                                <div class="badge-pill h3" data-reactid=".xwkwpqc4jk.$Commentaire.0.0.1"><span class="badge-pill-count" data-reactid=".xwkwpqc4jk.$Commentaire.0.0.1.0">1</span></div>
                                <br class="show-sm" data-reactid=".xwkwpqc4jk.$Commentaire.0.0.2">
                                <span class="badge-pill-label" data-reactid=".xwkwpqc4jk.$Commentaire.0.0.3">Commentaire</span>
                            </div>
                        </a>
                    </div>--%>
                    <%--<div class="badge-container space-top-4" data-reactid=".xwkwpqc4jk.$Vérifié">
                        <div data-reactid=".xwkwpqc4jk.$Vérifié.0">
                            <a class="link-reset" rel="nofollow" data-reactid=".xwkwpqc4jk.$Vérifié.0.0">
                                <div class="text-center text-wrap" id="verified-id-icon" data-reactid=".xwkwpqc4jk.$Vérifié.0.0.0">
                                    <img alt="Verified" src="https://a1.muscache.com/airbnb/static/badges/verified_badge-6ee370f5ca86a52ed6198fac858ac1f4.png" width="32" height="32" data-reactid=".xwkwpqc4jk.$Vérifié.0.0.0.0"><br class="show-sm" data-reactid=".xwkwpqc4jk.$Vérifié.0.0.0.2">
                                    <span class="badge-pill-label" data-reactid=".xwkwpqc4jk.$Vérifié.0.0.0.3">Verified</span>
                                </div>
                            </a>
                            <noscript data-reactid=".xwkwpqc4jk.$Vérifié.0.1"></noscript>
                        </div>
                    </div>--%>
                </div>
            </div>
            <script type="application/json" data-hypernova-key="user_profile_badgesbundlejs"><!--{"badgeClassName":"space-top-4","className":"row-space-6 row-space-top-2","isSelf":true,"attributes":{"badges":[{"image_path":null,"count":1,"link":"/users/show/31924116#reviews","label":"Commentaire"},{"id":"verified-id-icon","image_path":"https://a1.muscache.com/airbnb/static/badges/verified_badge-6ee370f5ca86a52ed6198fac858ac1f4.png","image_size":"32x32","label":"Vérifié"}],"verifications_tooltip":{"smart_name":"Ayman","verifications_header_text":"Identification vérifiée"}},"phrases":{"superhost_tooltip":{"superhost.profile_badge.guest.tooltip":"Chaque Superhost possède son propre style, mais tous ont satisfait aux mêmes critères d'hospitalité qui reflètent leur expérience et leur engagement.","superhost.profile_badge.guest.tooltip.cta":"Découvrir les critères pour devenir Superhost","superhost.profile_badge.host.tooltip":"Félicitations, vous êtes Superhost ! Nous vous récompenserons par une assistance utilisateurs prioritaire, des pré-annonces produit et bien plus encore.","superhost.profile_badge.host.tooltip.cta":"Revoir vos récompenses"},"verifications_tooltip":{"verifications.this_person_has_verified_online_and_offline_id":"Ayman a effectué sa vérification d'identification en ligne et hors ligne.","verifications.learn_more":"En savoir plus"}},"trebuchets":{}}--></script>

            <div class="social_connections_and_reviews" style="margin-top:170px;">
                <div class="reviews row-space-4" id="reviews">
                    <h2>Comments
            <small>(1)</small>
                    </h2>
                    <div>
                        <div class="reviews_section as_guest row-space-top-3">
                            <h4 runat="server" id="commentsFrom" class="row-space-4">
                            </h4>
                            <div class="reviews">
                                <div class="row text-center-sm" id="review-64627450">
                                    <div class="col-md-2 col-sm-12">
                                        <div class="avatar-wrapper">
                                            <a href="/users/show/50138732" class="text-muted">
                                                <div class="media-photo media-round row-space-1">
                                                    <img alt="Paweł" class="lazy" data-original="https://a2.muscache.com/im/pictures/3e5c8ea8-42c1-4eec-bfcf-66eb4e467228.jpg?aki_policy=profile_medium" height="68" src="https://a2.muscache.com/im/pictures/3e5c8ea8-42c1-4eec-bfcf-66eb4e467228.jpg?aki_policy=profile_medium" title="Paweł" width="68" style="display: inline;">
                                                </div>
                                                <div class="text-muted date show-sm">
                                                    Paweł
                                                </div>
                                            </a>
                                        </div>
                                    </div>
                                    <div class="col-md-10 col-sm-12">
                                        <div class="row-space-2">
                                            <div class="comment-container expandable expandable-trigger-more row-space-2 expanded">
                                                <div class="expandable-content">
                                                    <p runat="server" id="comment"></p>
                                                    <div class="expandable-indicator"></div>
                                                </div>
                                                <a class="expandable-trigger-more text-muted" href="#">
                                                </a>
                                            </div>


                                            <div class="text-muted date hide-sm pull-left">
                                                Lives in <a href="/s/Cracovie--Pologne" class="link-reset">Widzew, Lodz</a> ·
            march 2016
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row row-space-2 line-separation">
                                    <div class="col-10 col-offset-2">
                                        <hr>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>


</asp:Content>
