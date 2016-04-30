<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
<#include "customercommon.ftl">

<#if canNotView>
  <@commonMsg type="error-perm">${uiLabelMap.AccountingEFTNotBelongToYou}.</@commonMsg>
  <@menu type="button">
    <@menuitem type="link" href=makeOfbizUrl("${donePage}") class="+${styles.action_nav!} ${styles.action_cancel!}" text=uiLabelMap.CommonGoBack />
  </@menu>
<#else>

<#macro menuContent menuArgs={}>
  <@menu args=menuArgs>
    <@menuitem type="link" href=makeOfbizUrl("${donePage}") class="+${styles.action_nav!} ${styles.action_cancel!}" text=uiLabelMap.CommonGoBack />
    <@menuitem type="link" href="javascript:document.editeftaccountform.submit()" class="+${styles.action_run_sys!} ${styles.action_update!}" text=uiLabelMap.CommonSave />
  </@menu>
</#macro>
<#assign sectionTitle>
  <#if !eftAccount??>
    ${uiLabelMap.AccountingAddNewEftAccount}
  <#else>
    <#-- Cato: duplicate: ${uiLabelMap.PageTitleEditEFTAccount}-->
  </#if>
</#assign>
<@section title=sectionTitle menuContent=menuContent menuLayoutGeneral="bottom">

  <form method="post" action="<@ofbizUrl><#if !eftAccount??>createEftAccount?DONE_PAGE=${donePage}<#else>updateEftAccount?DONE_PAGE=${donePage}</#if></@ofbizUrl>" name="editeftaccountform">

    <#if eftAccount??>
      <input type="hidden" name="paymentMethodId" value="${paymentMethodId}" />
    </#if>

    <@render resource="component://shop/widget/CustomerScreens.xml#eftAccountFields" ctxVars={"eafFieldNamePrefix":""} />

    <@field type="generic" label=uiLabelMap.PartyBillingAddress>
        <#-- Cato: Billing fields are replaced with common new defs (old defs that were here discarded) -->
        <@render resource="component://shop/widget/CustomerScreens.xml#billaddresspickfields" 
            ctxVars={"bapfUseNewAddr":false, "bapfNewAddrInline":false, "bapfFieldNamePrefix":""}/>
    </@field>
  </form>
</@section>

</#if>

