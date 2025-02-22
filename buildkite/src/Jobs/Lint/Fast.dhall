let Prelude = ../../External/Prelude.dhall

let B = ../../External/Buildkite.dhall

let S = ../../Lib/SelectFiles.dhall

let Pipeline = ../../Pipeline/Dsl.dhall

let JobSpec = ../../Pipeline/JobSpec.dhall

let Cmd = ../../Lib/Cmds.dhall

let Command = ../../Command/Base.dhall

let Docker = ../../Command/Docker/Type.dhall

let RunInToolchain = ../../Command/RunInToolchain.dhall

let Size = ../../Command/Size.dhall

let commands =
      [ Cmd.run "./scripts/lint_codeowners.sh"
      , Cmd.run "./scripts/lint_rfcs.sh"
      , Cmd.run "make check-snarky-submodule"
      , Cmd.run "./scripts/lint_preprocessor_deps.sh"
      ]

in  Pipeline.build
      Pipeline.Config::{
        spec = JobSpec::{
        , dirtyWhen = [
            S.strictly (S.contains "Makefile"),
            S.strictlyStart (S.contains "src/"),
            S.strictlyStart (S.contains "rfcs/"),
            S.exactly "scripts/check-snarky-submodule" "sh"
          ]
        , path = "Lint"
        , name = "Fast"
        }
      , steps =
        [ Command.build
            Command.Config::{
            , commands = commands
            , label =
                "Fast lint steps; CODEOWNERs, RFCs, Check Snarky & Proof-Systems submodules, Preprocessor Deps"
            , key = "lint"
            , target = Size.Small
            , docker = Some Docker::{
              , image = (../../Constants/ContainerImages.dhall).toolchainBase
              }
            }
        ]
      }
