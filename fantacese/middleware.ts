import { auth } from '@/auth'
import { NextResponse } from 'next/server'

export default auth((req) => {
  const isAdminRoute = req.nextUrl.pathname.startsWith('/admin')

  if (isAdminRoute) {
    const siteRole = (req.auth?.user as { siteRole?: string } | undefined)?.siteRole
    if (siteRole !== 'SITE_ADMIN') {
      return NextResponse.redirect(new URL('/', req.nextUrl))
    }
  }
})

export const config = {
  matcher: ['/admin/:path*'],
}