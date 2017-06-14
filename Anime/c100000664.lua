 --黒の過程－ニグレド
function c100000664.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100000664.condition)
	e1:SetTarget(c100000664.target)
	e1:SetOperation(c100000664.activate)
	c:RegisterEffect(e1)
end
function c100000664.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x501) and c:IsAbleToRemove()
end
function c100000664.cfilter(c)
	return c:IsFaceup() and c:IsCode(100000650)
end
function c100000664.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c100000664.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	and Duel.IsExistingMatchingCard(c100000664.filter,tp,LOCATION_MZONE,0,1,nil) 
	and (Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)==1 and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,c))
	or Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)==0
end
function c100000664.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	local g=Duel.GetMatchingGroup(c100000664.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
end
function c100000664.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x501) and c:IsLocation(LOCATION_REMOVED)
end
function c100000664.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c100000664.filter,tp,LOCATION_MZONE,0,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		local dc=og:FilterCount(c100000664.filter1,nil)		 
		if dc>0 then
			Duel.Draw(p,dc*2,REASON_EFFECT)
		end
	end
end
