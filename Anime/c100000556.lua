--バリアン・ボム
function c100000556.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_TOHAND)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetTarget(c100000556.target)
	e1:SetOperation(c100000556.operation)
	c:RegisterEffect(e1)
	if not c100000556.global_check then
		c100000556.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c100000556.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c100000556.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c100000556.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c100000556.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsBarian,tp,0,LOCATION_HAND,nil)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,hg)
	if g:GetCount()>0 then
		Duel.Destroy(hg,REASON_EFFECT)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
end
