--Earthbound Salvation
function c511002725.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511002725.condition)
	e1:SetTarget(c511002725.target)
	e1:SetOperation(c511002725.activate)
	c:RegisterEffect(e1)
	if not c511002725.global_check then
		c511002725.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511002725.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511002725.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c511002725.cfilter(tc)
	return tc and tc:IsFaceup()
end
function c511002725.condition(e,tp,eg,ep,ev,re,r,rp)
	return (c511002725.cfilter(Duel.GetFieldCard(tp,LOCATION_SZONE,5)) or c511002725.cfilter(Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)))
end
function c511002725.filter1(c)
	return c:IsEarthbound() and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c511002725.filter2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c511002725.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511002725.filter1,tp,LOCATION_GRAVE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c511002725.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
end
function c511002725.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c511002725.filter1,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(c511002725.filter2,tp,LOCATION_GRAVE,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.HintSelection(sg1)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
end
