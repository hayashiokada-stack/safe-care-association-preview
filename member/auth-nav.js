import { auth } from "/member/firebase-config.js?v=20260717-2";
import { onAuthStateChanged,signOut } from "https://www.gstatic.com/firebasejs/10.14.1/firebase-auth.js";

function labelFromUser(user){
  return user?.displayName||user?.email||"회원";
}

function escapeHtml(value){
  return String(value).replace(/[&<>"']/g,(ch)=>({
    "&":"&amp;",
    "<":"&lt;",
    ">":"&gt;",
    '"':"&quot;",
    "'":"&#39;"
  }[ch]));
}

function renderLoggedOut(actions,cls){
  actions.innerHTML='<a href="/member/join.html" class="'+cls.primary+'">회원가입</a><a href="/member/login.html" class="'+cls.secondary+'">로그인</a>';
}

function renderLoggedIn(actions,user,cls){
  const label=labelFromUser(user);
  const safeLabel=escapeHtml(label);
  actions.innerHTML=[
    '<span class="member-auth-status" style="font-size:.84rem;font-weight:700;color:#1b3a6b;max-width:170px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis" title="'+safeLabel+'">'+safeLabel+'님</span>',
    '<a href="/member/mypage.html" class="'+cls.secondary+'">마이페이지</a>',
    '<button type="button" id="memberLogoutBtn" class="'+cls.primary+'" style="border:0;background:#5a6a7e">로그아웃</button>'
  ].join("");
  const logoutBtn=actions.querySelector("#memberLogoutBtn");
  logoutBtn?.addEventListener("click",async()=>{
    logoutBtn.disabled=true;
    logoutBtn.textContent="로그아웃 중...";
    await signOut(auth);
    window.location.href="/";
  });
}

async function initAuthNav(){
  const actions=document.querySelector("#site-nav .nav-actions")||document.querySelector("#nav .nav-actions");
  if(!actions)return;
  const cls=actions.querySelector(".nav-cta")
    ?{primary:"nav-cta",secondary:"nav-cta secondary"}
    :{primary:"btn-nav-primary",secondary:"btn-nav-primary secondary"};
  onAuthStateChanged(auth,(user)=>{
    if(user?.emailVerified)renderLoggedIn(actions,user,cls);
    else renderLoggedOut(actions,cls);
  });
}

initAuthNav();
