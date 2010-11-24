<cfoutput>

<form id="new_customer" method="post" action="Customer.cfc?method=#formAction#">
	<input type="hidden" name="id" value="#response.customer.id#">

	<div class="field">
		<label for="firstName">First Name</label>
		<input type="text" name="firstName" value="#response.customer.firstName#" />
	</div>
	<div class="field">
		<label for="lastName">Last Name</label>
		<input type="text" name="lastName" value="#response.customer.lastName#" />
	</div>
	<div class="field">
		<label for="creditLimit">Credit Limit</label>
		<input type="text" name="creditLimit" value="#response.customer.creditLimit#" />
	</div>
	<div class="submit">
		<input type="submit" value="Add Customer" />
	</div>
</form>

</cfoutput>
