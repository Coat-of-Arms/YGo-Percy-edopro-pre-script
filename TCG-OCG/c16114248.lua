--ペア・サイクロイド
function c16114248.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMixN(c,true,true,c16114248.ffilter,2)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
end
function c16114248.ffilter(c,fc,sub,mg,sg)
	return c:IsRace(RACE_MACHINE) and (not sg or sg:GetCount()==0 or sg:IsExists(c16114248.fusfilter,1,c,c:GetFusionCode()))
end
function c16114248.fusfilter(c,code)
	return c:IsFusionCode(code) or c:IsHasEffect(511002961)
end
