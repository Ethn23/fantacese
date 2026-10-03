import { prisma } from '@/lib/prisma'

export async function getLeagueRole(userId: string, leagueId: string) {
  const membership = await prisma.leagueMembership.findUnique({
    where: { userId_leagueId: { userId, leagueId } },
  })
  return membership?.role ?? null
}

export async function isLeagueAdmin(userId: string, leagueId: string) {
  const role = await getLeagueRole(userId, leagueId)
  return role === 'LEAGUE_ADMIN'
}

export async function isLeagueMember(userId: string, leagueId: string) {
  const role = await getLeagueRole(userId, leagueId)
  return role !== null
}