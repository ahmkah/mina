open Mina_base

module Test_input : Transaction_snark_tests.Test_zkapp_update.Input_intf =
struct
  let test_description = "token_symbol"

  let failure_expected =
    ( Mina_base.Transaction_status.Failure.Update_not_permitted_token_symbol
    , Transaction_snark_tests.Util.Pass_2 )

  let snapp_update =
    { Account_update.Update.dummy with
      token_symbol = Zkapp_basic.Set_or_keep.Set "Zoozoo"
    }

  let is_non_zkapp_update = true
end

let%test_module "Update account token symbol" =
  ( module struct
    include Transaction_snark_tests.Test_zkapp_update.Make (Test_input)
  end )
