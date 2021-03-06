<#--
This file is subject to the terms and conditions defined in the
files 'LICENSE' and 'NOTICE', which are part of this source
code package.
-->

<#-- SCIPIO: "Quick Finalize" / "One Page Checkout" template for order entry
    This is the nearest equivalent of shop OnePageCheckout for orderentry.
    NOTE: In the past this was shared by shop, but is no longer supported in shop in Scipio (OnePageCheckout superior). -->

<#include "component://order/webapp/ordermgr/common/common.ftl">
<#import "component://accounting/webapp/accounting/common/acctlib.ftl" as acctlib>

<@script>
function submitForm(form, mode, value) {
    if (mode == "DN") {
        // done action; checkout
        <#-- SCIPIO: NOTE: ?checkoutType=quick is what makes the review page show the "quick" top menu instead of the full one -->
        form.action="<@ofbizUrl>checkout?checkoutType=quick</@ofbizUrl>";
        form.submit();
    } else if (mode == "CS") {
        // continue shopping
        form.action="<@ofbizUrl>updateCheckoutOptions/showcart</@ofbizUrl>";
        form.submit();
    } else if (mode == "NA") {
        // new address
        form.action="<@ofbizUrl>updateCheckoutOptions/editcontactmech?DONE_PAGE=quickcheckout&partyId=${shoppingCart.getPartyId()}&preContactMechTypeId=POSTAL_ADDRESS&contactMechPurposeTypeId=SHIPPING_LOCATION</@ofbizUrl>";
        form.submit();
    } else if (mode == "EA") {
        // edit address
        form.action="<@ofbizUrl>updateCheckoutOptions/editcontactmech?DONE_PAGE=quickcheckout&partyId=${shoppingCart.getPartyId()}&contactMechId="+value+"</@ofbizUrl>";
        form.submit();
    } else if (mode == "NC") {
        // new credit card
        form.action="<@ofbizUrl>updateCheckoutOptions/editcreditcard?DONE_PAGE=quickcheckout&partyId=${shoppingCart.getPartyId()}</@ofbizUrl>";
        form.submit();
    } else if (mode == "EC") {
        // edit credit card
        form.action="<@ofbizUrl>updateCheckoutOptions/editcreditcard?DONE_PAGE=quickcheckout&partyId=${shoppingCart.getPartyId()}&paymentMethodId="+value+"</@ofbizUrl>";
        form.submit();
    } else if (mode == "GC") {
        // edit gift card
        form.action="<@ofbizUrl>updateCheckoutOptions/editgiftcard?DONE_PAGE=quickcheckout&partyId=${shoppingCart.getPartyId()}&paymentMethodId="+value+"</@ofbizUrl>";
        form.submit();
    } else if (mode == "NE") {
        // new eft account
        form.action="<@ofbizUrl>updateCheckoutOptions/editeftaccount?DONE_PAGE=quickcheckout&partyId=${shoppingCart.getPartyId()}</@ofbizUrl>";
        form.submit();
    } else if (mode == "EE") {
        // edit eft account
        form.action="<@ofbizUrl>updateCheckoutOptions/editeftaccount?DONE_PAGE=quickcheckout&partyId=${shoppingCart.getPartyId()}&paymentMethodId="+value+"</@ofbizUrl>";
        form.submit();
    } else if (mode == "SP") {
        // split payment
        form.action="<@ofbizUrl>updateCheckoutOptions/checkoutpayment?partyId=${shoppingCart.getPartyId()}</@ofbizUrl>";
        form.submit();
    } else if (mode == "SA") {
        // selected shipping address
        form.action="<@ofbizUrl>updateCheckoutOptions/quickcheckout</@ofbizUrl>";
        form.submit();
    } else if (mode == "SC") {
        // selected ship to party
        form.action="<@ofbizUrl>cartUpdateShipToCustomerParty</@ofbizUrl>";
        form.submit();
    }
}
</@script>

<#assign shipping = !shoppingCart.containAllWorkEffortCartItems()> <#-- contains items which need shipping? -->

<form method="post" name="checkoutInfoForm">
  <input type="hidden" name="checkoutpage" value="quick"/>
  <input type="hidden" name="BACK_PAGE" value="quickcheckout"/>

    <@section title=shipping?then("1) ${rawLabel('OrderWhereShallWeShipIt')}?", rawLabel('OrderInformationAboutYou'))>
        <@fields type="default-manual">
            <#-- SCIPIO: TODO: convert tables -->
                <@table type="fields" class="+${styles.table_spacing_tiny_hint!}" width="100%">
                  <@tr>
                    <@td colspan="2">
                      <span>${uiLabelMap.OrderShipToParty}:</span>
                      <@field type="select" name="shipToCustomerPartyId" onChange="javascript:submitForm(document.checkoutInfoForm, 'SC', null);">
                          <#list cartParties as cartParty>
                          <option value="${cartParty}">${cartParty}</option>
                          </#list>
                      </@field>
                    </@td>
                  </@tr>
                  <@tr>
                    <@td colspan="2">
                      <span>${uiLabelMap.CommonAdd}:</span>
                      <a href="javascript:submitForm(document.checkoutInfoForm, 'NA', '');" class="${styles.link_nav!} ${styles.action_add!}">${uiLabelMap.PartyAddNewAddress}</a>
                    </@td>
                  </@tr>
                  <#if (shoppingCart.getTotalQuantity() > 1) && !shoppingCart.containAllWorkEffortCartItems()> <#-- no splitting when only rental items -->
                    <#--<@tr type="util"><@td colspan="2"><hr /></@td></@tr>-->
                    <@tr>
                      <@td colspan="2" align="center">
                        <a href="<@ofbizUrl>splitship</@ofbizUrl>" class="${styles.link_nav!} ${styles.action_update!}">${uiLabelMap.OrderSplitIntoMultipleShipments}</a>
                        <#if (shoppingCart.getShipGroupSize() > 1)>
                          <div class="${styles.text_color_alert!}">${uiLabelMap.OrderNOTEMultipleShipmentsExist}.</div>
                        </#if>
                      </@td>
                    </@tr>
                  </#if>
                   <#if shippingContactMechList?has_content>
                     <#--<@tr type="util"><@td colspan="2"><hr /></@td></@tr>-->
                     <#list shippingContactMechList as shippingContactMech>
                       <#assign shippingAddress = shippingContactMech.getRelatedOne("PostalAddress", false)>
                       <@tr>
                         <@td width="1%">
                           <@field type="radio" name="shipping_contact_mech_id" value=shippingAddress.contactMechId onClick="javascript:submitForm(document.checkoutInfoForm, 'SA', null);" checked=((shoppingCart.getShippingContactMechId()!"") == shippingAddress.contactMechId)/>
                         </@td>
                         <@td width="99%">
                             <#if shippingAddress.toName?has_content><b>${uiLabelMap.CommonTo}:</b>&nbsp;${shippingAddress.toName}<br /></#if>
                             <#if shippingAddress.attnName?has_content><b>${uiLabelMap.PartyAddrAttnName}:</b>&nbsp;${shippingAddress.attnName}<br /></#if>
                             <#if shippingAddress.address1?has_content>${shippingAddress.address1}<br /></#if>
                             <#if shippingAddress.address2?has_content>${shippingAddress.address2}<br /></#if>
                             <#if shippingAddress.city?has_content>${shippingAddress.city}</#if>
                             <#if shippingAddress.stateProvinceGeoId?has_content><br />${shippingAddress.stateProvinceGeoId}</#if>
                             <#if shippingAddress.postalCode?has_content><br />${shippingAddress.postalCode}</#if>
                             <#if shippingAddress.countryGeoId?has_content><br />${shippingAddress.countryGeoId}</#if>
                             <a href="javascript:submitForm(document.checkoutInfoForm, 'EA', '${escapeVal(shippingAddress.contactMechId, 'js-html')}');" class="${styles.link_run_session!} ${styles.action_update!}">${uiLabelMap.CommonUpdate}</a>
                           </@td>
                       </@tr>
                       <#if shippingContactMech_has_next>
                         <#--<@tr type="util"><@td colspan="2"><hr /></@td></@tr>-->
                       </#if>
                     </#list>
                   </#if>
                 </@table>

                <#-- Party Tax Info -->
                <#-- commented out by default because the TaxAuthority drop-down is just too wide...
                <hr />
                <div>&nbsp;${uiLabelMap.PartyTaxIdentification}</div>
                <@render resource="component://order/widget/ordermgr/OrderEntryOrderScreens.xml#customertaxinfo" />
                -->
        </@fields>
    </@section>

    <@section title=shipping?then("2) ${rawLabel('OrderHowShallWeShipIt')}?", "2) ${rawLabel('OrderOptions')}?")>
        <@fields type="default-manual">
        
                <@table type="fields" class="+${styles.table_spacing_tiny_hint!}" width="100%">
                 <#if shipping == true>
                  <#assign chosenShippingMethod = rawString(chosenShippingMethod!"N@A")>
                  <#list carrierShipmentMethodList as carrierShipmentMethod>
                    <#assign shippingMethod = rawString(carrierShipmentMethod.shipmentMethodTypeId) + "@" + rawString(carrierShipmentMethod.partyId)>
                    <@tr>
                      <@td width="1%">
                        <@field type="radio" name="shipping_method" value=shippingMethod checked=(shippingMethod == chosenShippingMethod)/>
                      </@td>
                      <@td>
                          <#assign shippingEst = ""><#-- SCIPIO -->
                          <#if shoppingCart.getShippingContactMechId()??>
                            <#assign shippingEst = shippingEstWpr.getShippingEstimate(carrierShipmentMethod)!-1>
                          </#if>
                          <#if carrierShipmentMethod.partyId != "_NA_">${carrierShipmentMethod.partyId!}&nbsp;</#if>${carrierShipmentMethod.description!}
                          <#if shippingEst?has_content><#if (shippingEst > -1)> - <@ofbizCurrency amount=shippingEst isoCode=shoppingCart.getCurrency()/><#elseif rawString(carrierShipmentMethod.shipmentMethodTypeId!) != "NO_SHIPPING"> - ${uiLabelMap.OrderCalculatedOffline}</#if></#if><#-- SCIPIO: NO_SHIPPING check -->
                        </@td>
                    </@tr>
                  </#list>
                  <#if !carrierShipmentMethodList?? || carrierShipmentMethodList?size == 0>
                    <@tr>
                      <@td width="1%">
                        <@field type="radio" name="shipping_method" value="Default" checked=true/>
                      </@td>
                      <@td>${uiLabelMap.OrderUseDefault}.</@td>
                    </@tr>
                  </#if>
                  <#--<@tr type="util"><@td colspan="2"><hr /></@td></@tr>-->
                  <@tr>
                    <@td colspan="2">
                      <@heading>${uiLabelMap.OrderShipAllAtOnce}?</@heading>
                    </@td>
                  </@tr>
                  <@tr>
                    <@td>
                      <@field type="radio" checked=((shoppingCart.getMaySplit()!"N") == "N") name="may_split" value="false"/>
                    </@td>
                    <@td>${uiLabelMap.OrderPleaseWaitUntilBeforeShipping}.</@td>
                  </@tr>
                  <@tr>
                    <@td>
                      <@field type="radio" name="may_split" value="true" checked=((shoppingCart.getMaySplit()!"N") == "Y")/>
                    </@td>
                    <@td>${uiLabelMap.OrderPleaseShipItemsBecomeAvailable}.</@td>
                  </@tr>
                  <#--<@tr type="util"><@td colspan="2"><hr /></@td></@tr>-->
                 <#else>
                    <input type="hidden" name="shipping_method" value="NO_SHIPPING@_NA_"/>
                    <input type="hidden" name="may_split" value="false"/>
                    <input type="hidden" name="is_gift" value="false"/>
                 </#if>
                  <@tr>
                    <@td colspan="2">
                      <@heading>${uiLabelMap.OrderSpecialInstructions}</@heading>
                    </@td>
                  </@tr>
                  <@tr>
                    <@td colspan="2">
                      <@field type="textarea" cols="30" rows="3" wrap="hard" name="shipping_instructions">${shoppingCart.getShippingInstructions()!}</@field>
                    </@td>
                  </@tr>
                 <#if shipping == true>
                  <#if (productStore.showCheckoutGiftOptions!) != "N" && (giftEnable!) != "N">
                  <#--<@tr type="util"><@td colspan="2"><hr /></@td></@tr>-->
                  <@tr>
                    <@td colspan="2">
                        <span><b>${uiLabelMap.OrderIsThisGift}</b></span>
                        <@field type="radio" checked=((shoppingCart.getIsGift()!"Y") == "Y") name="is_gift" value="true" label=uiLabelMap.CommonYes />
                        <@field type="radio" checked=((shoppingCart.getIsGift()!"N") == "N") name="is_gift" value="false" label=uiLabelMap.CommonNo />
                      </@td>
                  </@tr>
                  <#--<@tr type="util"><@td colspan="2"><hr /></@td></@tr>-->
                  <@tr>
                    <@td colspan="2">
                      <@heading>${uiLabelMap.OrderGiftMessage}</@heading>
                    </@td>
                  </@tr>
                  <@tr>
                    <@td colspan="2">
                      <@field type="textarea" cols="30" rows="3" wrap="hard" name="gift_message">${shoppingCart.getGiftMessage()!}</@field>
                    </@td>
                  </@tr>
                  <#else>
                  <input type="hidden" name="is_gift" value="false"/>
                  </#if>
                 </#if>
                  <#--<@tr type="util"><@td colspan="2"><hr /></@td></@tr>-->
                  <@tr>
                    <@td colspan="2">
                      <@heading>${uiLabelMap.PartyEmailAddresses}</@heading>
                    </@td>
                  </@tr>
                  <@tr>
                    <@td colspan="2">
                      <div>${uiLabelMap.OrderEmailSentToFollowingAddresses}:</div>
                      <div>
                      <b>
                      <#list emailList as email>
                        ${email.infoString!}<#if email_has_next>,</#if>
                      </#list>
                      </b>
                      </div>
                      <div>${uiLabelMap.OrderUpdateEmailAddress} <a href="<#if customerDetailLink??>${customerDetailLink}${shoppingCart.getPartyId()}${rawString(externalKeyParam!)}" target="partymgr"
                        <#else><@ofbizUrl>viewprofile?DONE_PAGE=quickcheckout</@ofbizUrl>"</#if> class="${styles.link_nav!}">${uiLabelMap.PartyProfile}</a>.</div>
                      <br />
                      <div>${uiLabelMap.OrderCommaSeperatedEmailAddresses}:</div>
                      <@field type="input" size="30" name="order_additional_emails" value=(shoppingCart.getOrderAdditionalEmails()!)/>
                    </@td>
                  </@tr>
                </@table>
        </@fields>
    </@section>

    <@section title="3) ${rawLabel('OrderHowShallYouPay')}?">
        <#assign subFieldType = "default"><#-- SCIPIO: for sub-fields --><#-- "default-compact" -->
        <@fields type="default-manual">
                <@table type="fields" class="+${styles.table_spacing_tiny_hint!}">
                  <@tr>
                    <@td colspan="2">
                      <span>${uiLabelMap.CommonAdd}:</span>
                      <#if productStorePaymentMethodTypeIdMap.CREDIT_CARD??>
                        <a href="javascript:submitForm(document.checkoutInfoForm, 'NC', '');" class="${styles.link_nav!} ${styles.action_select!}">${uiLabelMap.AccountingCreditCard}</a>
                      </#if>
                      <#if productStorePaymentMethodTypeIdMap.EFT_ACCOUNT??>
                        <a href="javascript:submitForm(document.checkoutInfoForm, 'NE', '');" class="${styles.link_nav!} ${styles.action_select!}">${uiLabelMap.AccountingEFTAccount}</a>
                      </#if>
                    </@td>
                  </@tr>
                  <#--<@tr type="util"><@td colspan="2"><hr /></@td></@tr>-->
                  <@tr>
                    <@td colspan="2" align="center">
                      <a href="javascript:submitForm(document.checkoutInfoForm, 'SP', '');" class="${styles.link_nav!} ${styles.action_update!}">${uiLabelMap.AccountingSplitPayment}</a>
                    </@td>
                  </@tr>
                  <#--<@tr type="util"><@td colspan="2"><hr /></@td></@tr>-->
                  <#if productStorePaymentMethodTypeIdMap.EXT_OFFLINE??>
                  <@tr>
                    <@td width="1%">
                      <@field type="radio" name="checkOutPaymentId" value="EXT_OFFLINE" checked=("EXT_OFFLINE" == checkOutPaymentId)/>
                    </@td>
                    <@td width="50%">${uiLabelMap.OrderPaymentOfflineCheckMoney}
                    </@td>
                  </@tr>
                  </#if>
                  <#if productStorePaymentMethodTypeIdMap.EXT_COD??>
                  <@tr>
                    <@td width="1%">
                      <@field type="radio" name="checkOutPaymentId" value="EXT_COD" checked=("EXT_COD" == checkOutPaymentId)/>
                    </@td>
                    <@td width="50%">${uiLabelMap.OrderCOD}
                    </@td>
                  </@tr>
                  </#if>
                  <#if productStorePaymentMethodTypeIdMap.EXT_WORLDPAY??>
                  <@tr>
                    <@td width="1%">
                      <@field type="radio" name="checkOutPaymentId" value="EXT_WORLDPAY" checked=("EXT_WORLDPAY" == checkOutPaymentId)/>
                    </@td>
                    <@td width="50%">${uiLabelMap.AccountingPayWithWorldPay}
                    </@td>
                  </@tr>
                  </#if>
                  <#if productStorePaymentMethodTypeIdMap.EXT_PAYPAL??>
                  <@tr>
                    <@td width="1%">
                      <@field type="radio" name="checkOutPaymentId" value="EXT_PAYPAL" checked=("EXT_PAYPAL" == checkOutPaymentId)/>
                    </@td>
                    <@td width="50%">${uiLabelMap.AccountingPayWithPayPal}
                    </@td>
                  </@tr>
                  </#if>
                  <#if productStorePaymentMethodTypeIdMap.EXT_LIGHTNING??>
                  <@tr>
                    <@td width="1%">
                      <@field type="radio" name="checkOutPaymentId" value="EXT_LIGHTNING" checked=("EXT_LIGHTNING" == checkOutPaymentId)/>
                    </@td>
                    <@td width="50%">${uiLabelMap.AccountingPayWithBitcoin}
                    </@td>
                  </@tr>
                  </#if>
                  <#if productStorePaymentMethodTypeIdMap.EXT_STRIPE??>
                  <@tr>
                    <@td width="1%">
                      <@field type="radio" name="checkOutPaymentId" value="EXT_STRIPE" checked=("EXT_STRIPE" == checkOutPaymentId)/>
                    </@td>
                    <@td width="50%">${uiLabelMap.AccountingPayWithStripe}
                    </@td>
                  </@tr>
                  </#if>
                  <#if productStorePaymentMethodTypeIdMap.EXT_REDSYS??>
                  <@tr>
                    <@td width="1%">
                      <@field type="radio" name="checkOutPaymentId" value="EXT_REDSYS" checked=("EXT_REDSYS" == checkOutPaymentId)/>
                    </@td>
                    <@td width="50%">${uiLabelMap.AccountingPayWithRedsys}
                    </@td>
                  </@tr>
                  </#if>
                  <#--<@tr type="util"><@td colspan="2"><hr /></@td></@tr>-->

                  <#-- financial accounts -->
                  <#list finAccounts as finAccount>
                      <@tr>
                        <@td width="1%">
                          <@field type="radio" name="checkOutPaymentId" value="FIN_ACCOUNT|${rawString(finAccount.finAccountId)}" checked=("FIN_ACCOUNT" == checkOutPaymentId)/>
                        </@td>
                        <@td width="50%">${uiLabelMap.AccountingFinAccount} #${finAccount.finAccountId}
                        </@td>
                      </@tr>
                  </#list>

                  <#if !paymentMethodList?has_content>
                    <#if (!finAccounts?has_content)>
                      <@tr>
                        <@td colspan="2"><b>${uiLabelMap.AccountingNoPaymentMethods}</b></@td>
                      </@tr>
                    </#if>
                  <#else>
                  <#list paymentMethodList as paymentMethod>
                    <#if paymentMethod.paymentMethodTypeId == "CREDIT_CARD">
                     <#if productStorePaymentMethodTypeIdMap.CREDIT_CARD??>
                      <#assign creditCard = paymentMethod.getRelatedOne("CreditCard", false)!>
                      <@tr>
                        <@td width="1%">
                          <@field type="radio" name="checkOutPaymentId" value=paymentMethod.paymentMethodId checked=(shoppingCart.isPaymentSelected(paymentMethod.paymentMethodId))/>
                        </@td>
                        <@td width="50%">
                          <span>CC:&nbsp;${Static["org.ofbiz.party.contact.ContactHelper"].formatCreditCard(creditCard)}</span>
                          <a href="javascript:submitForm(document.checkoutInfoForm, 'EC', '${escapeVal(paymentMethod.paymentMethodId, 'js-html')}');" class="${styles.link_run_session!} ${styles.action_update!}">${uiLabelMap.CommonUpdate}</a>
                          <#if paymentMethod.description?has_content><br /><span>(${paymentMethod.description})</span></#if>
                          <@fields type=subFieldType ignoreParentField=true>
                            <@field type="input" label=uiLabelMap.OrderCardSecurityCode size="5" maxlength="10" name="securityCode_${rawString(paymentMethod.paymentMethodId)}" value=""/>
                          </@fields>
                        </@td>
                      </@tr>
                     </#if>
                    <#elseif paymentMethod.paymentMethodTypeId == "EFT_ACCOUNT">
                     <#if productStorePaymentMethodTypeIdMap.EFT_ACCOUNT??>
                      <#assign eftAccount = paymentMethod.getRelatedOne("EftAccount", false)!>
                      <@tr>
                        <@td width="1%">
                          <@field type="radio" name="checkOutPaymentId" value=paymentMethod.paymentMethodId checked=(shoppingCart.isPaymentSelected(paymentMethod.paymentMethodId))/>
                        </@td>
                        <@td width="50%">
                          <span>${uiLabelMap.AccountingEFTAccount}:&nbsp;${eftAccount.bankName!}: ${eftAccount.accountNumber!}</span>
                          <a href="javascript:submitForm(document.checkoutInfoForm, 'EE', '${escapeVal(paymentMethod.paymentMethodId, 'js-html')}');" class="${styles.link_run_session!} ${styles.action_update!}">${uiLabelMap.CommonUpdate}</a>
                          <#if paymentMethod.description?has_content><br /><span>(${paymentMethod.description})</span></#if>
                        </@td>
                      </@tr>
                     </#if>
                    <#elseif paymentMethod.paymentMethodTypeId == "GIFT_CARD">
                     <#if productStorePaymentMethodTypeIdMap.GIFT_CARD??>
                      <#assign giftCard = paymentMethod.getRelatedOne("GiftCard", false)!>
                      <#assign giftCardNumber = acctlib.getPayMethDisplayNumber(giftCard, paymentMethod)!><#-- SCIPIO: Refactored -->
                      <@tr>
                        <@td width="1%">
                          <@field type="radio" name="checkOutPaymentId" value=paymentMethod.paymentMethodId checked=(shoppingCart.isPaymentSelected(paymentMethod.paymentMethodId))/>
                        </@td>
                        <@td width="50%">
                          <span>${uiLabelMap.AccountingGift}:&nbsp;${giftCardNumber}</span>
                          <a href="javascript:submitForm(document.checkoutInfoForm, 'EG', '${escapeVal(paymentMethod.paymentMethodId, 'js-html')}');" class="${styles.link_run_session!} ${styles.action_update!}">[${uiLabelMap.CommonUpdate}]</a>
                          <#if paymentMethod.description?has_content><br /><span>(${paymentMethod.description})</span></#if>
                        </@td>
                      </@tr>
                     </#if>
                    </#if>
                  </#list>
                  </#if>

                <#-- special billing account functionality to allow use w/ a payment method -->
                <#if productStorePaymentMethodTypeIdMap.EXT_BILLACT??>
                  <#if billingAccountList?has_content>
                    <#--<@tr type="util"><@td colspan="2"><hr /></@td></@tr>-->
                    <@tr>
                      <@td width="1%">
                        <@field type="select" name="billingAccountId">
                          <option value=""></option>
                            <#list billingAccountList as billingAccount>
                              <#assign availableAmount = billingAccount.accountBalance?double>
                              <#assign accountLimit = billingAccount.accountLimit?double>
                              <option value="${billingAccount.billingAccountId}" <#if billingAccount.billingAccountId == (selectedBillingAccountId!"")>selected="selected"</#if>>${billingAccount.description!""} [${billingAccount.billingAccountId}] Available: <@ofbizCurrency amount=availableAmount isoCode=billingAccount.accountCurrencyUomId/> Limit: <@ofbizCurrency amount=accountLimit isoCode=billingAccount.accountCurrencyUomId/></option>
                            </#list>
                        </@field>
                      </@td>
                      <@td width="50%">${uiLabelMap.FormFieldTitle_billingAccountId}
                      </@td>
                    </@tr>
                    <@tr>
                      <@td width="1%" align="right">
                        <@field type="input" size="5" name="billingAccountAmount" value=""/>
                      </@td>
                      <@td width="50%">
                        ${uiLabelMap.OrderBillUpTo}
                      </@td>
                    </@tr>
                  </#if>
                </#if>
                <#-- end of special billing account functionality -->

                <#if productStorePaymentMethodTypeIdMap.GIFT_CARD??>
                  <#--<@tr type="util"><@td colspan="2"><hr /></@td></@tr>-->
                  <@tr>
                    <@td width="1%">
                      <@field type="checkbox" name="addGiftCard" value="Y" checkboxType="simple-standard"/>
                    </@td>
                    <@td width="50%">${uiLabelMap.AccountingUseGiftCardNotOnFile}
                    </@td>
                  </@tr>
                  <@tr>
                    <@td width="1%"></@td>
                    <@td width="50%">
                      <@fields type=subFieldType ignoreParentField=true>
                        <@field type="input" label=uiLabelMap.AccountingNumber size="15" name="giftCardNumber" value=((requestParameters.giftCardNumber)!) onFocus="document.checkoutInfoForm.addGiftCard.checked=true;"/>
                      </@fields>
                    </@td>
                  </@tr>
                  <#if shoppingCart.isPinRequiredForGC(delegator)>
                  <@tr>
                    <@td width="1%"></@td>
                    <@td width="50%">
                      <@fields type=subFieldType ignoreParentField=true>
                        <@field type="input" label=uiLabelMap.AccountingPIN type="text" size="10" name="giftCardPin" value=((requestParameters.giftCardPin)!) onFocus="document.checkoutInfoForm.addGiftCard.checked=true;"/>
                      </@fields>
                    </@td>
                  </@tr>
                  </#if>
                  <@tr>
                    <@td width="1%"></@td>
                    <@td width="50%">
                      <@fields type=subFieldType ignoreParentField=true>
                        <@field type="input" label=uiLabelMap.AccountingAmount size="6" name="giftCardAmount" value=((requestParameters.giftCardAmount)!) onFocus="document.checkoutInfoForm.addGiftCard.checked=true;"/>
                      </@fields>
                    </@td>
                  </@tr>
                </#if>
            </@table>
        </@fields>
    </@section>                    
            
</form>

<#-- SCIPIO: NOTE: we still need this because the page is long so it's too annoying for user to scroll way back up to click "continue" -->
<@row>
  <@cell>
    <@menu type="button">
      <#-- SCIPIO: I don't like this view-override
      <@menuitem type="link" href="javascript:submitForm(document.checkoutInfoForm, 'CS', '');" text=uiLabelMap.OrderBacktoShoppingCart class="+${styles.action_nav!} ${styles.action_cancel!}" />-->
      <@menuitem type="link" href="javascript:submitForm(document.checkoutInfoForm, 'DN', '');" text=uiLabelMap.CommonContinue class="+${styles.action_run_session!} ${styles.action_continue!}" /><#-- OrderContinueToFinalOrderReview -->
    </@menu>
  </@cell>
</@row>

