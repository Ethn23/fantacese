import NextAuth from 'next-auth'
import Credentials from 'next-auth/providers/credentials'
import bcrypt from 'bcryptjs'
import { prisma } from '@/lib/prisma'

export const { handlers, auth, signIn, signOut } = NextAuth({
  session: { strategy: 'jwt' },
  pages: {
    signIn: '/login',
  },
  providers: [
    Credentials({
      credentials: {
        email: {},
        password: {},
      },
      authorize: async (credentials) => {
        const email = credentials?.email as string | undefined
        const password = credentials?.password as string | undefined
        if (!email || !password) return null

        const user = await prisma.user.findUnique({ where: { email } })
        if (!user) return null

        const valid = await bcrypt.compare(password, user.passwordHash)
        if (!valid) return null

        return {
          id: user.id,
          email: user.email,
          name: user.displayName,
          siteRole: user.siteRole,
        }
      },
    }),
  ],
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.id = user.id
        token.siteRole = (user as { siteRole?: string }).siteRole
      }
      return token
    },
    async session({ session, token }) {
      if (session.user) {
        (session.user as typeof session.user & { id?: string; siteRole?: string }).id = token.id as string
        ;(session.user as typeof session.user & { id?: string; siteRole?: string }).siteRole = token.siteRole as string
      }
      return session
    },
  },
})