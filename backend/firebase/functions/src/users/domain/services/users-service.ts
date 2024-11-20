// domain/services/users-service.ts
import { CleanUserFilesFeature, CleanUserFilesResult } from "../ports/in/clean-user-files-feature";
import { UsersRepository } from "../ports/out/users-repository";

export class UsersService implements CleanUserFilesFeature {
    constructor(private readonly usersRepository: UsersRepository) { }

    async removeFileReferences(userUidList: string[], fileUid: string): Promise<CleanUserFilesResult> {
        const result: CleanUserFilesResult = {
            updatedUsers: [],
            errors: []
        };

        try {

            for (const userUid of userUidList) {
                try {
                    await this.usersRepository.removeFileFromUser(userUid, fileUid);
                    result.updatedUsers.push(userUid);
                } catch (error) {
                    result.errors.push(`Failed to update user ${userUid}: ${error}`);
                }
            }
        } catch (error) {
            throw new Error(`Error cleaning user references: ${error}`);
        }

        return result;
    }
}