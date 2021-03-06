<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false displayWide=false showAnotherWayIfPresent=true>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="robots" content="noindex, nofollow" />

    <#if properties.meta?has_content>
        <#list properties.meta?split(' ') as meta>
            <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
        </#list>
    </#if>
    <title>${msg("loginTitle",(realm.displayName!''))}</title>
    <link rel="icon" href="${url.resourcesPath}/img/favicon.ico" />
    <link href="${url.resourcesPath}/css/style.css" rel="stylesheet" />
</head>

<body class="font-sans flex flex-col min-h-screen">
    <!-- Header -->
    <header class="${properties.kcFormHeaderClass!}">
        <div class="mb-2 lg:mb-4 xl:mb-0 flex content-end items-stretch border-b border-gray-500">
            <div class="p-4 flex flex-col justify-center">
                <a href="https://noi.bz.it"><img src="${url.resourcesPath}/img/noi.svg" alt="NOI Techpark" class="image-noi" /></a>
            </div>
            <div class="flex-1 flex flex-col justify-center px-4 border-l border-gray-500 leading-tight font-light text-2xl lg:text-4xl">
                <#if client?? && client.baseUrl?has_content>
                    <a class="hover:underline" href="${client.baseUrl}">${kcSanitize(msg("loginTitleHtml",((client.name?has_content)?string(client.name, realm.displayNameHtml))))?no_esc}</a>
                <#else>
                    <h2>${kcSanitize(msg("loginTitleHtml",(realm.displayNameHtml!'')))?no_esc}</h2>
                </#if>
            </div>
            <!-- Desktop Navigation -->
            <nav role="navigation" class="hidden lg:flex mr-4 items-center">
                <#if realm.internationalizationEnabled  && locale.supported?size gt 1>
                    <div class="group relative block">
                        <button class="relative border-3 border-black pl-4 pr-4 py-2 text-left group-hover:bg-black group-hover:text-white uppercase cursor-pointer">
                            <div class="block pr-2">
                            ${locale.current}
                            </div>
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" width="18" class="absolute vertical-center fill-current" style="right: 1rem">
                                <path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"/>
                            </svg>
                        </button>
                        <ul class="z-10 shadow hidden absolute right-0 left-0 group-hover:block bg-white">
                            <#list locale.supported as l>
                                <li><a href="${l.url}" class="block px-4 py-2 hover:bg-black hover:text-white">${l.label}</a></li>
                            </#list>
                        </ul>
                    </div>
                </#if>
            </nav>
        </div>
        <!-- Mobile Navigation -->
        <nav role="navigation" class="mb-2 mx-2 xs:mx-4 flex lg:hidden flex-col items-stretch">
            <#if realm.internationalizationEnabled  && locale.supported?size gt 1>
                <div class="group relative block">
                    <button class="relative w-full border-3 border-black pl-4 pr-4 py-2 text-left uppercase" onclick="toggleLanguage()">
                        <div class="block pr-2">
                        ${locale.current}
                        </div>
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" width="18" class="absolute vertical-center fill-current" style="right: 1rem">
                            <path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"/>
                        </svg>
                    </button>
                    <ul id="mobile-languages" class="mobile-languages">
                        <#list locale.supported as l>
                            <li><a href="${l.url}" class="block px-4 py-2 hover:bg-black hover:text-white">${l.label}</a></li>
                        </#list>
                    </ul>
                </div>
            </#if>
        </nav>
    </header>

    <!-- Content -->
    <main class="mx-0 lg:mt-4 xl:mx-4 flex flex-col flex-grow bg-gray-300">
        <div id="kc-form" class="p-2 lg:p-5 flex justify-center">
            <div id="kc-form-wrapper" class="my-4 w-full max-w-2xl p-4 lg:p-5 border-3 border-black bg-white">
                <#nested "header">
                <#if displayInfo>
                    <div id="kc-info" class="mb-4 text-sm text-gray-500">
                        <#nested "info">
                    </div>
                </#if>
                <#-- App-initiated actions should not see warning messages about the need to complete the action -->
                <#-- during login.                                                                               -->
                <#if message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                    <div class="mb-4 border-2 px-4 py-3 <#if message.type = 'error'>bg-red-100 border-red-400 text-red-700<#elseif message.type = 'warning'>bg-yellow-100 border-yellow-400 text-yellow-700<#elseif message.type = 'info'>bg-blue-100 border-blue-400 text-blue-700<#elseif message.type = 'success'>bg-green-100 border-green-400 text-green-700</#if>" role="alert">
                        <strong class="font-bold">${msg(message.type)}!</strong>
                        <span class="block">${kcSanitize(message.summary)?no_esc}</span>
                    </div>
                </#if>

                <#nested "form">

                <#if auth?has_content && auth.showTryAnotherWayLink() && showAnotherWayIfPresent>
                    <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post" <#if displayWide>class="${properties.kcContentWrapperClass!}"</#if>>
                        <div <#if displayWide>class="${properties.kcFormSocialAccountContentClass!} ${properties.kcFormSocialAccountClass!}"</#if>>
                            <div class="${properties.kcFormGroupClass!}">
                                <input type="hidden" name="tryAnotherWay" value="on" />
                                <a href="#" id="try-another-way" onclick="document.forms['kc-select-try-another-way-form'].submit();return false;">${msg("doTryAnotherWay")}</a>
                            </div>
                        </div>
                    </form>
                </#if>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="mt-4 mb-0 xl:mb-4 mx-0 xl:mx-4 p-4 lg:p-5 flex flex-col bg-gray-300">
        <div class="mb-3 text-base lg:text-2xl font-bold">
            &copy; ${.now?string('yyyy')} NOI Techpark
        </div>
        <div class="flex flex-col lg:flex-row leading-relaxed text-xs lg:text-base">
            <div class="mr-5">
                NOI SPA<br />
                Techpark Südtirol / Alto Adige<br />
                <a href="mailto:info@davinci.bz.it" class="hover:underline">info@opendatahub.bz.it</a>
            </div>
            <div class="mt-3 lg:mt-0">
                A.-Volta-Straße 13/A - 39100 Bozen/South Tyrol - Italy<br />
                P.IVA 02595720216<br />
                <a href="https://noi.bz.it" class="hover:underline">noi.bz.it</a>
            </div>
        </div>
        <div class="mt-3 text-xs lg:text-lg font-bold">
            Developed by
            <a href="https://aboutbits.it" class="hover:underline">About Bits</a>
        </div>
    </footer>
</body>
<script>
    function toggleLanguage() {
        var x = document.getElementById("mobile-languages");
        if (x.className === "mobile-languages") {
            x.className += " mobile-languages-open";
        } else {
            x.className = "mobile-languages";
        }
    }
</script>
</html>
</#macro>
