#!/usr/bin/env bash

set -eo pipefail

COSMOS_SDK_DIR=${COSMOS_SDK_DIR:-$(go list -f "{{ .Dir }}" -m github.com/cosmos/cosmos-sdk)}

protoc_gen_gocosmos() {
  if ! grep "github.com/gogo/protobuf => github.com/regen-network/protobuf" go.mod &>/dev/null ; then
    echo -e "\tPlease run this command from somewhere inside the cosmos-sdk folder."
    return 1
  fi

  go get github.com/regen-network/cosmos-proto/protoc-gen-gocosmos@latest 2>/dev/null
}

protoc_gen_gocosmos

proto_dirs=$(find ./proto -path -prune -o -name '*.proto' -print0 | xargs -0 -n1 dirname | sort | uniq)
for dir in $proto_dirs; do
  buf protoc \
  -I "proto" \
  -I="$COSMOS_SDK_DIR/third_party/proto" \
  -I="$COSMOS_SDK_DIR/proto" \
  --gocosmos_out=plugins=interfacetype+grpc,\
Mgoogle/protobuf/any.proto=github.com/cosmos/cosmos-sdk/codec/types:. \
  --grpc-gateway_out=logtostderr=true:. \
  $(find "${dir}" -maxdepth 1 -name '*.proto')

done

# command to generate docs using protoc-gen-doc
buf protoc \
-I "proto" \
-I="$COSMOS_SDK_DIR/third_party/proto" \
-I="$COSMOS_SDK_DIR/proto" \
--doc_out=./docs/core \
--doc_opt=./docs/protodoc-markdown.tmpl,proto-docs.md \
$(find "$(pwd)/proto" -maxdepth 5 -name '*.proto')
go mod tidy

# generate codec/testdata proto code
buf protoc -I "proto" -I "third_party/proto" -I "testutil/testdata" --gocosmos_out=plugins=interfacetype+grpc,\
Mgoogle/protobuf/any.proto=github.com/cosmos/cosmos-sdk/codec/types:. ./testutil/testdata/*.proto

# move proto files to the right places
cp -r github.com/cosmos/cosmos-sdk/* ./
rm -rf github.com


##!/usr/bin/env bash
#
#set -eo pipefail
#
#PROJECT_PROTO_DIR=x/halving/types/
#COSMOS_SDK_DIR=${COSMOS_SDK_DIR:-$(go list -f "{{ .Dir }}" -m github.com/cosmos/cosmos-sdk)}
#
## Generate Go types from protobuf
#buf protoc \
#  -I="./proto" \
#  -I="$COSMOS_SDK_DIR/third_party/proto" \
#  -I="$COSMOS_SDK_DIR/proto" \
#  --gocosmos_out=Mgoogle/protobuf/any.proto=github.com/cosmos/cosmos-sdk/codec/types,Mgoogle/protobuf/empty.proto=github.com/gogo/protobuf/types,plugins=interfacetype+grpc,paths=source_relative:. \
#  --grpc-gateway_out .\
#  --grpc-gateway_opt logtostderr=true \
#  --grpc-gateway_opt paths=Mgoogle/protobuf/any.proto=github.com/cosmos/cosmos-sdk/codec/types,Mgoogle/protobuf/empty.proto=github.com/gogo/protobuf/types,paths=source_relative \
#  --doc_out=./doc \
#  --doc_opt=markdown,proto.md \
#  $(find "${PROJECT_PROTO_DIR}" -maxdepth 1 -name '*.proto')