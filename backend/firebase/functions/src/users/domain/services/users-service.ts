// domain/services/users-service.ts
import { CleanUserFilesFeature, CleanUserFilesResult } from "../ports/in/clean-user-files-feature";
import { UsersRepository } from "../ports/out/users-repository";

export class UsersService implements CleanUserFilesFeature {
    constructor(private readonly usersRepository: UsersRepository) { }

    async removeFileReferences(fileUid: string): Promise<CleanUserFilesResult> {
        const result: CleanUserFilesResult = {
            updatedUsers: [],
            errors: []
        };

        try {
            const users = await this.usersRepository.findUsersWithFile(fileUid);

            for (const user of users) {
                try {
                    await this.usersRepository.removeFileFromUser(user.uid, fileUid);
                    result.updatedUsers.push(user.uid);
                } catch (error) {
                    result.errors.push(`Failed to update user ${user.uid}: ${error}`);
                }
            }
        } catch (error) {
            throw new Error(`Error cleaning user references: ${error}`);
        }

        return result;
    }
}