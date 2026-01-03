/*
  Get this password for the 'admin' user with:
     > terraform output -json dozzle_passwords
*/
output dozzle_passwords {
  description = "The username/password pairs (as a map(string)) for dozzle users"
  value = module.dozzle_users.passwords
  sensitive = true
}