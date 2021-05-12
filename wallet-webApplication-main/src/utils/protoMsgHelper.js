import {MsgSend} from "@cosmjs/stargate/build/codec/cosmos/bank/v1beta1/tx";
import {MsgBeginRedelegate, MsgDelegate, MsgUndelegate} from "@cosmjs/stargate/build/codec/cosmos/staking/v1beta1/tx";
import {
    MsgSetWithdrawAddress,
    MsgWithdrawDelegatorReward
} from "@cosmjs/stargate/build/codec/cosmos/distribution/v1beta1/tx";

const msgSendTypeUrl = "/cosmos.bank.v1beta1.MsgSend";
const msgDelegateTypeUrl = "/cosmos.staking.v1beta1.MsgDelegate";
const msgRedelegateTypeUrl = "/cosmos.staking.v1beta1.MsgBeginRedelegate";
const msgUnbondTypeUrl = "/cosmos.staking.v1beta1.MsgUndelegate";
const msgWithdrawRewardsTypeUrl = "/cosmos.distribution.v1beta1.MsgWithdrawDelegatorReward";
const msgSetWithdrawAddressTypeUrl = "/cosmos.distribution.v1beta1.MsgSetWithdrawAddress";


function SendMsg(fromAddress, toAddress, amount) {
    return {
        typeUrl: msgSendTypeUrl,
        value: MsgSend.fromPartial({
            fromAddress: fromAddress,
            toAddress: toAddress,
            amount: [{
                denom: "uxprt",
                amount: String(amount),
            }],
        }),
    };
}


function DelegateMsg(delegatorAddress, validatorAddress, amount) {
    return {
        typeUrl: msgDelegateTypeUrl,
        value: MsgDelegate.fromPartial({
            delegatorAddress: delegatorAddress,
            validatorAddress: validatorAddress,
            amount: {
                denom: "uxprt",
                amount: String(amount),
            },
        }
        ),
    };
}

function RedelegateMsg(delegatorAddress, validatorSrcAddress, validatorDstAddress, amount) {
    return {
        typeUrl: msgRedelegateTypeUrl,
        value: MsgBeginRedelegate.fromPartial({
            delegatorAddress: delegatorAddress,
            validatorSrcAddress: validatorSrcAddress,
            validatorDstAddress: validatorDstAddress,
            amount: {
                denom: "uxprt",
                amount: String(amount),
            },
        }
        ),
    };
}

function UnbondMsg(delegatorAddress, validatorAddress, amount) {
    return {
        typeUrl: msgUnbondTypeUrl,
        value: MsgUndelegate.fromPartial({
            delegatorAddress: delegatorAddress,
            validatorAddress: validatorAddress,
            amount: {
                denom: "uxprt",
                amount: String(amount),
            },
        }
        ),
    };

}

function WithdrawMsg(delegatorAddress, validatorAddress) {
    return {
        typeUrl: msgWithdrawRewardsTypeUrl,
        value: MsgWithdrawDelegatorReward.fromPartial({
            delegatorAddress: delegatorAddress,
            validatorAddress: validatorAddress,
        }),
    };
}

function SetWithDrawAddressMsg(delegatorAddress, withdrawAddress) {
    return {
        typeUrl: msgSetWithdrawAddressTypeUrl,
        value: MsgSetWithdrawAddress.fromPartial({
            delegatorAddress: delegatorAddress,
            withdrawAddress: withdrawAddress,
        }),
    };
}

export {SendMsg, DelegateMsg, RedelegateMsg, UnbondMsg, WithdrawMsg, SetWithDrawAddressMsg};