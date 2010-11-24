<html>
	<head></head>

	<body>
		<table id="customers">
			<thead>
				<tr>
					<th>Name</th>
					<th>Email</th>
					<th>Last Update</th>
				</tr>
			</thead>
			
			<tbody>
			<cfloop query="customers">
				<tr>
					<td>#customer.lastName#, #cutomer.firstName#</td>
					<td>#customer.creditLimit#</td>
					<td><cfoutput>#TimeFormat( Now(), 'h.mm.ss')#</cfoutput></td>
				</tr>
			</cfloop>
			</tbody>
		</table>
<cfinclude template="customers.pgm">
	</body>
</html>