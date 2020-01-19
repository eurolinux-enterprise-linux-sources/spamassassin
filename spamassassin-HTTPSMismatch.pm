diff -up Mail-SpamAssassin-3.3.2/lib/Mail/SpamAssassin/Plugin/HTTPSMismatch.pm.bz892348 Mail-SpamAssassin-3.3.2/lib/Mail/SpamAssassin/Plugin/HTTPSMismatch.pm
--- Mail-SpamAssassin-3.3.2/lib/Mail/SpamAssassin/Plugin/HTTPSMismatch.pm.bz892348	2013-02-01 14:44:52.003000000 +0100
+++ Mail-SpamAssassin-3.3.2/lib/Mail/SpamAssassin/Plugin/HTTPSMismatch.pm	2013-02-01 14:53:16.041000000 +0100
@@ -55,29 +55,26 @@ sub check_https_http_mismatch {
     $permsgstatus->{chhm_hit} = 0;
     $permsgstatus->{chhm_anchors} = 0;
 
-    foreach my $v ( values %{$permsgstatus->{html}->{uri_detail}} ) {
+    while ((my $k, my $v) = each (%{$permsgstatus->{html}->{uri_detail}} )) {
       # if the URI wasn't used for an anchor tag, or the anchor text didn't
       # exist, skip this.
       next unless (exists $v->{anchor_text} && @{$v->{anchor_text}});
 
       my $uri;
-      foreach (@{$v->{cleaned}}) {
-        if (m@^https?://([^/:]+)@i) {
-	  $uri = $1;
-
-	  # Skip IPs since there's another rule to catch that already
-          if ($uri =~ /^\d+\.\d+\.\d+\.\d+$/) {
-            undef $uri;
-            next;
-          }
-
-	  # want to compare whole hostnames instead of domains?
-	  # comment this next section to the blank line.
-	  $uri = Mail::SpamAssassin::Util::RegistrarBoundaries::trim_domain($uri);
-          undef $uri unless (Mail::SpamAssassin::Util::RegistrarBoundaries::is_domain_valid($uri));
+      if ($k =~ m@^https?://([^/:]+)@i) {
+	$uri = $1;
 
-	  last if $uri;
+	# Skip IPs since there's another rule to catch that already
+        if ($uri =~ /^\d+\.\d+\.\d+\.\d+$/) {
+          undef $uri;
+          next;
         }
+
+	# want to compare whole hostnames instead of domains?
+	# comment this next section to the blank line.
+	$uri = Mail::SpamAssassin::Util::RegistrarBoundaries::trim_domain($uri);
+        undef $uri unless (Mail::SpamAssassin::Util::RegistrarBoundaries::is_domain_valid($uri));
+
       }
 
       next unless $uri;
