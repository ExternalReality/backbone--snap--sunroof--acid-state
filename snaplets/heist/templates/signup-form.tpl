<form method="post" action="${postAction}">
  <table id="info">
    <tr>
      <td>Login:</td><td><input type="text" name="login" size="20" /></td>
    </tr>
    <tr>
      <td>Password:</td><td><input type="password" name="password" size="20" /></td>
    </tr>
    <tr>
      <td></td>
      <td>
	<select name="role">
	  <option value="PotionMaker">PotionMaker</option>	 
	  <option value="Admin">Admin</option>
	</select>
      </td>
    </tr>
    <tr>
      <td></td>
      <td><input type="submit" value="${submitText}" /></td>  
    </tr>
  </table>
</form>

