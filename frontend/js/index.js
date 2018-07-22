$(document).ready(function() {
  $.auth.configure({
    apiUrl: 'http://localhost:3001/'
  });

  $.auth
    .oAuthSignIn({provider: 'github'})
    .then(function(user) {
      alert('Welcome ' + user.name + '!');
    })
    .fail(function(resp) {
      alert(resp.reason);
    });
});
